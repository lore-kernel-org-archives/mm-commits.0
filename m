From: akpm@linux-foundation.org
Subject: + drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch added to -mm tree
Date: Thu, 28 Jul 2011 16:53:07 -0700
Message-ID: <201107282353.p6SNr7X8015800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186Ab1G1XyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 19:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, dougg@torque.net


The patch titled
     drivers/scsi/sg.c: convert to kstrtoul_from_user()
has been added to the -mm tree.  Its filename is
     drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch

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
Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()
From: Stephen Boyd <sboyd@codeaurora.org>

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
@@ -2367,16 +2367,15 @@ static ssize_t 
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
 
@@ -2389,17 +2388,15 @@ static ssize_t 
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
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch

