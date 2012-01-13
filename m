From: akpm@linux-foundation.org
Subject: [merged] parisc-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:08 -0800
Message-ID: <20120113203208.9733B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55751 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2AMUcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:09 -0500
Received: by mail-yx0-f202.google.com with SMTP id l1so72024yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, deller@gmx.de, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     parisc-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: parisc, exec: remove redundant set_fs(USER_DS)

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
arm-exec-remove-redundant-set_fsuser_ds.patch

