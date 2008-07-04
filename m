From: akpm@linux-foundation.org
Subject: - mips-remove-board_watchpoint_handler.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:26:49 -0700
Message-ID: <200807040726.m647QnxI019304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYGDH06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney@avtrex.com, mm-commits@vger.kernel.org


The patch titled
     mips: remove board_watchpoint_handler
has been removed from the -mm tree.  Its filename was
     mips-remove-board_watchpoint_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -892,11 +891,6 @@ asmlinkage void do_mdmx(struct pt_regs *
 
 asmlinkage void do_watch(struct pt_regs *regs)
 {
-	if (board_watchpoint_handler) {
-		(*board_watchpoint_handler)(regs);
-		return;
-	}
