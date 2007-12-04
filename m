From: akpm@linux-foundation.org
Subject: - i4l-fix-isdn_ioctl-memory-overrun-vulnerability.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:37:24 -0800
Message-ID: <200712040737.lB47bOC1006799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbXLDHio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, adlab@venustech.com.cn, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     I4L: fix isdn_ioctl memory overrun vulnerability
has been removed from the -mm tree.  Its filename was
     i4l-fix-isdn_ioctl-memory-overrun-vulnerability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I4L: fix isdn_ioctl memory overrun vulnerability
From: Karsten Keil <kkeil@suse.de>

Fix possible memory overrun issue in the isdn ioctl code.  Found by ADLAB
<adlab@venustech.com.cn>

Signed-off-by: Karsten Keil <kkeil@suse.de>
Cc: ADLAB <adlab@venustech.com.cn>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_common.c~i4l-fix-isdn_ioctl-memory-overrun-vulnerability drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~i4l-fix-isdn_ioctl-memory-overrun-vulnerability
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1515,6 +1515,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
@@ -1599,6 +1600,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						drvidx = -1;
 						for (i = 0; i < ISDN_MAX_DRIVERS; i++)
@@ -1643,7 +1645,7 @@ isdn_ioctl(struct inode *inode, struct f
 					} else {
 						p = (char __user *) iocts.arg;
 						for (i = 0; i < 10; i++) {
-							sprintf(bname, "%s%s",
+							snprintf(bname, sizeof(bname), "%s%s",
 								strlen(dev->drv[drvidx]->msn2eaz[i]) ?
 								dev->drv[drvidx]->msn2eaz[i] : "_",
 								(i < 9) ? "," : "\0");
@@ -1673,6 +1675,7 @@ isdn_ioctl(struct inode *inode, struct f
 					char *p;
 					if (copy_from_user(&iocts, argp, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
_

Patches currently in -mm which might be from kkeil@suse.de are

fix-versus-precedence-in-various-places.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
gigaset-permit-module-unload.patch
