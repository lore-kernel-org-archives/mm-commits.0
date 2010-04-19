From: akpm@linux-foundation.org
Subject: + drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch added to -mm tree
Date: Mon, 19 Apr 2010 13:58:53 -0700
Message-ID: <201004192058.o3JKws6D009114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab0DSU7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 16:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kusumi.tomohiro@jp.fujitsu.com, James.Bottomley@HansenPartnership.com, xiyou.wangcong@gmail.com


The patch titled
     drivers/scsi/scsi_sysfs.c: fix sdev_rw_attr macro for scsi device sysfs entries
has been added to the -mm tree.  Its filename is
     drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/scsi_sysfs.c: fix sdev_rw_attr macro for scsi device sysfs entries
From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

Fix the sdev_rw_attr() macro for scsi device sysfs entries.  It seems
there is no such function snscanf in the current linux kernel, so it fails
to compile scsi driver when someone try to add a new rw entry.  This has
been unfixed for a long time probably because current scsi device has no
rw entries.

# grep snscanf . -rn
./drivers/scsi/scsi_sysfs.c:489:        snscanf (buf, 20, format_string, &sdev->field);                 \

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries
+++ a/drivers/scsi/scsi_sysfs.c
@@ -474,7 +474,7 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_
 
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -486,7 +486,7 @@ sdev_store_##field (struct device *dev, 
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf (buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
_

Patches currently in -mm which might be from kusumi.tomohiro@jp.fujitsu.com are

drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch

