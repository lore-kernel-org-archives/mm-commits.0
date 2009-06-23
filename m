From: akpm@linux-foundation.org
Subject: + printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch added to -mm tree
Date: Mon, 22 Jun 2009 22:56:16 -0700
Message-ID: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZFWF4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 01:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, mingo@elte.hu


The patch titled
     printk boot_delay: rename printk_delay_msec to loops_per_msec
has been added to the -mm tree.  Its filename is
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch

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
Subject: printk boot_delay: rename printk_delay_msec to loops_per_msec
From: Dave Young <hidave.darkstar@gmail.com>

Rename `printk_delay_msec' to `loops_per_msec', because the patch "printk:
add printk_delay to make messages readable for some scenarios" wishes to
more appropriately use the `printk_delay_msec' identifier.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec kernel/printk.c
--- a/kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec
+++ a/kernel/printk.c
@@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
+static unsigned long long loops_per_msec;
 
 static int __init boot_delay_setup(char *str)
 {
 	unsigned long lpj;
-	unsigned long long loops_per_msec;
 
 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
@@ -212,10 +211,9 @@ static int __init boot_delay_setup(char 
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk_delay_msec = loops_per_msec;
 	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"HZ: %d, printk_delay_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
+		"HZ: %d, loops_per_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
 __setup("boot_delay=", boot_delay_setup);
@@ -228,7 +226,7 @@ static void boot_delay_msec(void)
 	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
 		return;
 
-	k = (unsigned long long)printk_delay_msec * boot_delay;
+	k = (unsigned long long)loops_per_msec * boot_delay;
 
 	timeout = jiffies + msecs_to_jiffies(boot_delay);
 	while (k) {
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch

