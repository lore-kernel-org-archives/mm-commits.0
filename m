From: akpm@linux-foundation.org
Subject: - mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch removed from -mm tree
Date: Tue, 18 Mar 2008 16:23:03 -0700
Message-ID: <200803182323.m2INN35K021274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757792AbYCSTlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     MIPS Alchemy: crapectomy after removal of pm_send_all calls
has been removed from the -mm tree.  Its filename was
     mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MIPS Alchemy: crapectomy after removal of pm_send_all calls
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/au1000/common/power.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN arch/mips/au1000/common/power.c~mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls arch/mips/au1000/common/power.c
--- a/arch/mips/au1000/common/power.c~mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls
+++ a/arch/mips/au1000/common/power.c
@@ -283,18 +283,6 @@ static int pm_do_sleep(ctl_table * ctl, 
 	return 0;
 }
 
-static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
-			 void __user *buffer, size_t * len, loff_t *ppos)
-{
-	if (!write) {
-		*len = 0;
-	} else {
-		suspend_mode = 1;
-	}
-	return 0;
-}
-
-
 static int pm_do_freq(ctl_table * ctl, int write, struct file *file,
 		      void __user *buffer, size_t * len, loff_t *ppos)
 {
@@ -408,14 +396,6 @@ static int pm_do_freq(ctl_table * ctl, i
 
 static struct ctl_table pm_table[] = {
 	{
-		.ctl_name 	= CTL_UNNUMBERED,
-		.procname	= "suspend",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0600,
-		.proc_handler	= &pm_do_suspend
-	},
-	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sleep",
 		.data		= NULL,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-acpi.patch
git-mips.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-replace-remaining-__function__-occurences.patch
git-net.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
mm-try-both-endianess-when-checking-for-endianess.patch
serial-add-vr41xx_siu_early_setup-for-serial-console.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
asm-futexh-should-include-linux-uaccessh.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

