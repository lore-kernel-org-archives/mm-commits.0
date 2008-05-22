From: akpm@linux-foundation.org
Subject: + mips-remove-board_watchpoint_handler.patch added to -mm tree
Date: Thu, 22 May 2008 16:51:06 -0700
Message-ID: <200805222351.m4MNp62P027891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759789AbYEVXvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@avtrex.com


The patch titled
     mips: remove board_watchpoint_handler
has been added to the -mm tree.  Its filename is
     mips-remove-board_watchpoint_handler.patch

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
Subject: mips: remove board_watchpoint_handler
From: David Daney <ddaney@avtrex.com>

It is not used anywhere in tree.

Signed-off-by: David Daney <ddaney@avtrex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/traps.c |    6 ------
 include/asm-mips/traps.h |    1 -
 2 files changed, 7 deletions(-)

diff -puN arch/mips/kernel/traps.c~mips-remove-board_watchpoint_handler arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~mips-remove-board_watchpoint_handler
+++ a/arch/mips/kernel/traps.c
@@ -71,7 +71,6 @@ extern asmlinkage void handle_reserved(v
 extern int fpu_emulator_cop1Handler(struct pt_regs *xcp,
 	struct mips_fpu_struct *ctx, int has_fpu);
 
-void (*board_watchpoint_handler)(struct pt_regs *regs);
 void (*board_be_init)(void);
 int (*board_be_handler)(struct pt_regs *regs, int is_fixup);
 void (*board_nmi_handler_setup)(void);
@@ -890,11 +889,6 @@ asmlinkage void do_mdmx(struct pt_regs *
 
 asmlinkage void do_watch(struct pt_regs *regs)
 {
-	if (board_watchpoint_handler) {
-		(*board_watchpoint_handler)(regs);
-		return;
-	}
