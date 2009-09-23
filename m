From: akpm@linux-foundation.org
Subject: [merged] printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:12 -0700
Message-ID: <200909231952.n8NJqCu7028634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbZIWTwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk boot_delay: rename printk_delay_msec to loops_per_msec
has been removed from the -mm tree.  Its filename was
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk boot_delay: rename printk_delay_msec to loops_per_msec
From: Dave Young <hidave.darkstar@gmail.com>

Rename `printk_delay_msec' to `loops_per_msec', because the patch "printk:
add printk_delay to make messages readable for some scenarios" wishes to
more appropriately use the `printk_delay_msec' identifier.

[akpm@linux-foundation.org: add a comment]
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec kernel/printk.c
--- a/kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec
+++ a/kernel/printk.c
@@ -206,12 +206,11 @@ __setup("log_buf_len=", log_buf_len_setu
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
+static unsigned long long loops_per_msec;	/* based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
 {
 	unsigned long lpj;
-	unsigned long long loops_per_msec;
 
 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
@@ -220,10 +219,9 @@ static int __init boot_delay_setup(char 
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk_delay_msec = loops_per_msec;
-	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"HZ: %d, printk_delay_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
+	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+		"HZ: %d, loops_per_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
 __setup("boot_delay=", boot_delay_setup);
@@ -236,7 +234,7 @@ static void boot_delay_msec(void)
 	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
 		return;
 
-	k = (unsigned long long)printk_delay_msec * boot_delay;
+	k = (unsigned long long)loops_per_msec * boot_delay;
 
 	timeout = jiffies + msecs_to_jiffies(boot_delay);
 	while (k) {
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

