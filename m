From: akpm@osdl.org
Subject: - swsusp-add-ioctl-for-swap-files-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:13 -0800
Message-ID: <200612072259.kB7MxDkI029477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50998 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163673AbWLGW7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: add ioctl for swap files support
has been removed from the -mm tree.  Its filename was
     swsusp-add-ioctl-for-swap-files-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: add ioctl for swap files support
From: "Rafael J. Wysocki" <rjw@sisk.pl>

To be able to use swap files as suspend storage from the userland suspend
tools we need an additional ioctl() that will allow us to provide the kernel
with both the swap header's offset and the identification of the resume
partition.

The new ioctl() should be regarded as a replacement for the
SNAPSHOT_SET_SWAP_FILE ioctl() that from now on will be considered as
obsolete, but has to stay for backwards compatibility of the interface.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/power.h |   14 +++++++++++++-
 kernel/power/user.c  |   31 +++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff -puN kernel/power/power.h~swsusp-add-ioctl-for-swap-files-support kernel/power/power.h
--- a/kernel/power/power.h~swsusp-add-ioctl-for-swap-files-support
+++ a/kernel/power/power.h
@@ -106,6 +106,16 @@ extern int snapshot_write_next(struct sn
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 extern void snapshot_free_unused_memory(struct snapshot_handle *handle);
 
+/*
+ * This structure is used to pass the values needed for the identification
+ * of the resume swap area from a user space to the kernel via the
+ * SNAPSHOT_SET_SWAP_AREA ioctl
+ */
+struct resume_swap_area {
+	loff_t offset;
+	u_int32_t dev;
+} __attribute__((packed));
+
 #define SNAPSHOT_IOC_MAGIC	'3'
 #define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
 #define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
@@ -119,7 +129,9 @@ extern void snapshot_free_unused_memory(
 #define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
-#define SNAPSHOT_IOC_MAXNR	12
+#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
+							struct resume_swap_area)
+#define SNAPSHOT_IOC_MAXNR	13
 
 #define PMOPS_PREPARE	1
 #define PMOPS_ENTER	2
diff -puN kernel/power/user.c~swsusp-add-ioctl-for-swap-files-support kernel/power/user.c
--- a/kernel/power/user.c~swsusp-add-ioctl-for-swap-files-support
+++ a/kernel/power/user.c
@@ -343,6 +343,37 @@ OutS3:
 		}
 		break;
 
+	case SNAPSHOT_SET_SWAP_AREA:
+		if (data->bitmap) {
+			error = -EPERM;
+		} else {
+			struct resume_swap_area swap_area;
+			dev_t swdev;
+
+			error = copy_from_user(&swap_area, (void __user *)arg,
+					sizeof(struct resume_swap_area));
+			if (error) {
+				error = -EFAULT;
+				break;
+			}
+
+			/*
+			 * User space encodes device types as two-byte values,
+			 * so we need to recode them
+			 */
+			swdev = old_decode_dev(swap_area.dev);
+			if (swdev) {
+				offset = swap_area.offset;
+				data->swap = swap_type_of(swdev, offset);
+				if (data->swap < 0)
+					error = -ENODEV;
+			} else {
+				data->swap = -1;
+				error = -EINVAL;
+			}
+		}
+		break;
+
 	default:
 		error = -ENOTTY;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

