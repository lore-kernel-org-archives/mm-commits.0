From: akpm@linux-foundation.org
Subject: + mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch added to -mm tree
Date: Thu, 13 Mar 2008 16:08:37 -0700
Message-ID: <200803132308.m2DN8bRE005291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbYCMXJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 19:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     MIPS Alchemy: Crapectomy after removal of pm_send_all calls.
has been added to the -mm tree.  Its filename is
     mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MIPS Alchemy: Crapectomy after removal of pm_send_all calls.
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

origin.patch
pm-remove-legacy-pm.patch
mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch
git-mips.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-replace-remaining-__function__-occurences.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
ioc3-fix-section-missmatch.patch
input-fix-cobalt_btns-loadable-keymap-support.patch
mm-try-both-endianess-when-checking-for-endianess.patch
ioc3c-replace-remaining-__function__-occurrences.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
asm-futexh-should-include-linux-uaccessh.patch

