From: akpm@linux-foundation.org
Subject: [merged] ppc-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:29 -0700
Message-ID: <201107211912.p6LJCM33032248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     ppc, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     ppc-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/process.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/powerpc/kernel/process.c~ppc-exec-remove-redundant-set_fsuser_ds arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~ppc-exec-remove-redundant-set_fsuser_ds
+++ a/arch/powerpc/kernel/process.c
@@ -832,8 +832,6 @@ void start_thread(struct pt_regs *regs, 
 	unsigned long load_addr = regs->gpr[2];	/* saved by ELF_PLAT_INIT */
 #endif
 
-	set_fs(USER_DS);
-
 	/*
 	 * If we exec out of a kernel thread then thread.regs will not be
 	 * set.  Do it now.
_

Patches currently in -mm which might be from minipli@googlemail.com are

linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
microblaze-exec-remove-redundant-set_fsuser_ds.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
h8300-exec-remove-redundant-set_fsuser_ds.patch
alpha-exec-remove-redundant-set_fsuser_ds.patch
m32r-exec-remove-redundant-set_fsuser_ds.patch
m68k-exec-remove-redundant-set_fsuser_ds.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch
cris-exec-remove-redundant-set_fsuser_ds.patch
um-exec-remove-redundant-set_fsuser_ds.patch

