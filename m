From: akpm@linux-foundation.org
Subject: + parisc-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:48:16 -0700
Message-ID: <201106202148.p5KLmG6X023348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755932Ab1FTVzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, deller@gmx.de, kyle@mcmartin.ca


The patch titled
     parisc, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     parisc-exec-remove-redundant-set_fsuser_ds.patch

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
Subject: parisc, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/processor.h |    2 --
 arch/parisc/kernel/process.c        |    1 -
 2 files changed, 3 deletions(-)

diff -puN arch/parisc/include/asm/processor.h~parisc-exec-remove-redundant-set_fsuser_ds arch/parisc/include/asm/processor.h
--- a/arch/parisc/include/asm/processor.h~parisc-exec-remove-redundant-set_fsuser_ds
+++ a/arch/parisc/include/asm/processor.h
@@ -196,7 +196,6 @@ typedef unsigned int elf_caddr_t;
 	/* offset pc for priv. level */			\
 	pc |= 3;					\
 							\
-	set_fs(USER_DS);				\
 	regs->iasq[0] = spaceid;			\
 	regs->iasq[1] = spaceid;			\
 	regs->iaoq[0] = pc;				\
@@ -299,7 +298,6 @@ on downward growing arches, it looks lik
 	elf_addr_t pc = (elf_addr_t)new_pc | 3;		\
 	elf_caddr_t *argv = (elf_caddr_t *)bprm->exec + 1;	\
 							\
-	set_fs(USER_DS);				\
 	regs->iasq[0] = spaceid;			\
 	regs->iasq[1] = spaceid;			\
 	regs->iaoq[0] = pc;				\
diff -puN arch/parisc/kernel/process.c~parisc-exec-remove-redundant-set_fsuser_ds arch/parisc/kernel/process.c
--- a/arch/parisc/kernel/process.c~parisc-exec-remove-redundant-set_fsuser_ds
+++ a/arch/parisc/kernel/process.c
@@ -192,7 +192,6 @@ void flush_thread(void)
 	/* Only needs to handle fpu stuff or perf monitors.
 	** REVISIT: several arches implement a "lazy fpu state".
 	*/
-	set_fs(USER_DS);
 }
 
 void release_thread(struct task_struct *dead_task)
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

