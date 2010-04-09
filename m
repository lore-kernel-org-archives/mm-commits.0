From: akpm@linux-foundation.org
Subject: + rtc-m41t80-use-nonseekable_open.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:30 -0700
Message-ID: <201004092315.o39NFUoe017207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab0DIXPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, a.zummo@towertech.it, fweisbec@gmail.com, p_gortmaker@yahoo.com


The patch titled
     rtc-m41t80: use nonseekable_open()
has been added to the -mm tree.  Its filename is
     rtc-m41t80-use-nonseekable_open.patch

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
Subject: rtc-m41t80: use nonseekable_open()
From: Jan Blunck <jblunck@suse.de>

Use nonseekable_open() for this since seeking is not supported anyway.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-nonseekable_open drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-nonseekable_open
+++ a/drivers/rtc/rtc-m41t80.c
@@ -595,10 +595,6 @@ static void wdt_disable(void)
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	/*  Can't seek (pwrite) on this device
-	if (ppos != &file->f_pos)
-	return -ESPIPE;
-	*/
 	if (count) {
 		wdt_ping();
 		return 1;
@@ -695,7 +691,7 @@ static int wdt_open(struct inode *inode,
 		 */
 		wdt_is_open = 1;
 		unlock_kernel();
-		return 0;
+		return nonseekable_open(inode, file);
 	}
 	return -ENODEV;
 }
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

