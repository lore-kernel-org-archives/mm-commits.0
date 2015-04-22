From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-introduce-automatic-device_id-generation.patch removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:19 -0700
Message-ID: <553804db.9E/rHDiIhe3CFe8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbDVUaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce automatic device_id generation
has been removed from the -mm tree.  Its filename was
     zram-introduce-automatic-device_id-generation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: introduce automatic device_id generation

The existing device creation interface requires user to provide new and
unique device_id for every device being created.  This might be difficult
to handle (f.e.  in automated scripts).

Extend zram-control/zram_add interface to support read and write
operations.  Write operation remains the same:

	echo X > /sys/class/zram-control/zram_add

will add /dev/zramX (or return error).

Read operation is treated as 'pick up available device_id, add new device
and return device_id'.

Example:
	 cat /sys/class/zram-control/zram_add
	2
	 cat /sys/class/zram-control/zram_add
	3

so user-space can proceed with /dev/zram2, /dev/zram3 init and usage.

An attempt to use already used device_id (-EEXIST)

	echo 3 > /sys/class/zram-control/zram_add
	-bash: echo: write error: File exists

Returning zram_add error code back to user (-ENOMEM in this case)

	cat /sys/class/zram-control/zram_add
	cat: /sys/class/zram-control/zram_add: Cannot allocate memory

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-zram |    7 +++-
 Documentation/blockdev/zram.txt            |   10 ++++++
 drivers/block/zram/zram_drv.c              |   31 +++++++++++++++++--
 3 files changed, 43 insertions(+), 5 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-zram~zram-introduce-automatic-device_id-generation Documentation/ABI/testing/sysfs-class-zram
--- a/Documentation/ABI/testing/sysfs-class-zram~zram-introduce-automatic-device_id-generation
+++ a/Documentation/ABI/testing/sysfs-class-zram
@@ -11,8 +11,11 @@ Date:		March 2015
 KernelVersion:	4.1
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
 Description:
-		Add a specific /dev/zramX device, where X is a device_id
-		provided by user
+		RW attribuite. Write operation adds a specific /dev/zramX
+		device, where X is a device_id provided by user.
+		Read operation will automatically pick up avilable device_id
+		X, add /dev/zramX device and return that device_id X back to
+		user.
 
 		What:		/sys/class/zram-control/zram_add
 Date:		March 2015
diff -puN Documentation/blockdev/zram.txt~zram-introduce-automatic-device_id-generation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-introduce-automatic-device_id-generation
+++ a/Documentation/blockdev/zram.txt
@@ -110,6 +110,16 @@ In order to add a new /dev/zramX device 
 To remove the existing /dev/zramX device (where X is a device id) execute
 	echo X > /sys/class/zram-control/zram_remove
 
+Additionally, zram also handles automatic device_id generation and assignment.
+
+	cat /sys/class/zram-control/zram_add
+	1
+	cat /sys/class/zram-control/zram_add
+	2
+
+this will pick up available device_id X, add corresponding /dev/zramX
+device and return its device_id X back to user (or error code).
+
 8) Stats:
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
diff -puN drivers/block/zram/zram_drv.c~zram-introduce-automatic-device_id-generation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-automatic-device_id-generation
+++ a/drivers/block/zram/zram_drv.c
@@ -1140,8 +1140,15 @@ static int zram_add(int device_id)
 	if (!zram)
 		return ret;
 
-	ret = idr_alloc(&zram_index_idr, zram, device_id,
-			device_id + 1, GFP_KERNEL);
+	if (device_id < 0) {
+		/* generate new device_id */
+		ret = idr_alloc(&zram_index_idr, zram, 0, 0, GFP_KERNEL);
+		device_id = ret;
+	} else {
+		/* use provided device_id */
+		ret = idr_alloc(&zram_index_idr, zram, device_id,
+				device_id + 1, GFP_KERNEL);
+	}
 	if (ret < 0)
 		goto out_free_dev;
 
@@ -1334,6 +1341,24 @@ static ssize_t zram_add_store(struct cla
 	return ret ? ret : count;
 }
 
+static ssize_t zram_add_show(struct class *class,
+			struct class_attribute *attr,
+			char *buf)
+{
+	int ret;
+
+	mutex_lock(&zram_index_mutex);
+	/* read operation on zram_add is - pick up device_id
+	 * automatically, add corresponding device and return
+	 * that device_id back to user */
+	ret = zram_add(-1);
+	mutex_unlock(&zram_index_mutex);
+
+	if (ret < 0)
+		return ret;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ret);
+}
+
 static ssize_t zram_remove_store(struct class *class,
 			struct class_attribute *attr,
 			const char *buf,
@@ -1345,7 +1370,7 @@ static ssize_t zram_remove_store(struct 
 }
 
 static struct class_attribute zram_control_class_attrs[] = {
-	__ATTR_WO(zram_add),
+	__ATTR_RW(zram_add),
 	__ATTR_WO(zram_remove),
 	__ATTR_NULL,
 };
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

