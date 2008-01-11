From: akpm@linux-foundation.org
Subject: + cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:45:21 -0800
Message-ID: <200801112345.m0BNjLgN003994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762904AbYAKXpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile
has been added to the -mm tree.  Its filename is
     cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch

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
Subject: CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile
From: Jesper Nilsson <jesper.nilsson@axis.com>

This fixes compile error when nr_free_pages() from linux/swap.h
expands to global_page_state(NR_FREE_PAGES), but linux/vmstat.h isn't
included to declare global_page_state().

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/arch-v10/kernel/time.c~cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/vmstat.h>
 #include <asm/arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch
cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch
cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch
avoid-overflows-in-kernel-timec.patch
