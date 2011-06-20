From: akpm@linux-foundation.org
Subject: + ppc-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:48:18 -0700
Message-ID: <201106202148.p5KLmIu5023353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261Ab1FTVyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, benh@kernel.crashing.org


The patch titled
     ppc, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     ppc-exec-remove-redundant-set_fsuser_ds.patch

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
@@ -831,8 +831,6 @@ void start_thread(struct pt_regs *regs, 
 	unsigned long load_addr = regs->gpr[2];	/* saved by ELF_PLAT_INIT */
 #endif
 
-	set_fs(USER_DS);
-
 	/*
 	 * If we exec out of a kernel thread then thread.regs will not be
 	 * set.  Do it now.
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
linux-next.patch
alpha-exec-remove-redundant-set_fsuser_ds.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
cris-exec-remove-redundant-set_fsuser_ds.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
h8300-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
m32r-exec-remove-redundant-set_fsuser_ds.patch
m68k-exec-remove-redundant-set_fsuser_ds.patch
microblaze-exec-remove-redundant-set_fsuser_ds.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
ppc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
um-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch

