From: akpm@linux-foundation.org
Subject: + printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch added to -mm tree
Date: Tue, 23 Jun 2009 09:16:17 -0700
Message-ID: <200906231616.n5NGGH0Y023518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbZFWQQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 12:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, mingo@elte.hu


The patch titled
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix 2
has been added to the -mm tree.  Its filename is
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch

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
Subject: printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix 2
From: Dave Young <hidave.darkstar@gmail.com>

use pr_debug for debug printk.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2 kernel/printk.c
--- a/kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2
+++ a/kernel/printk.c
@@ -211,7 +211,7 @@ static int __init boot_delay_setup(char 
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch

