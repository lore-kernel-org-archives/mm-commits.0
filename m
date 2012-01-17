From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:11 -0800
Message-ID: <20120117210112.0EF705C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56418 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQVBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:14 -0500
Received: by werc1 with SMTP id c1so78022wer.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, dougg@torque.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()

Instead of open coding this function use kstrtoul_from_user() directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user
+++ a/drivers/scsi/sg.c
@@ -2368,16 +2368,15 @@ static ssize_t 
 sg_proc_write_adio(struct file *filp, const char __user *buffer,
 		   size_t count, loff_t *off)
 {
-	int num;
-	char buff[11];
+	int err;
+	unsigned long num;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	sg_allow_dio = simple_strtoul(buff, NULL, 10) ? 1 : 0;
+	err = kstrtoul_from_user(buffer, count, 0, &num);
+	if (err)
+		return err;
+	sg_allow_dio = num ? 1 : 0;
 	return count;
 }
 
@@ -2390,17 +2389,15 @@ static ssize_t 
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)
 {
-	int num;
+	int err;
 	unsigned long k = ULONG_MAX;
-	char buff[11];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	k = simple_strtoul(buff, NULL, 10);
+
+	err = kstrtoul_from_user(buffer, count, 0, &k);
+	if (err)
+		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
 		sg_big_buff = k;
 		return count;
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
debugobjects-fix-selftest-for-static-warnings.patch

