From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:27 -0700
Message-ID: <200705080006.l4806RN6009191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967396AbXEHAG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: arch/um/kernel/tt/include/mode_kern-tt.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: arch/um/kernel/tt/include/mode_kern-tt.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tt/include/mode_kern-tt.h |   52 ---------------------
 1 file changed, 52 deletions(-)

diff -puN arch/um/kernel/tt/include/mode_kern-tt.h~remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth /dev/null
--- a/arch/um/kernel/tt/include/mode_kern-tt.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_MODE_KERN_H__
-#define __TT_MODE_KERN_H__
-
-#include "linux/sched.h"
-#include "asm/page.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-
-extern void switch_to_tt(void *prev, void *next);
-extern void flush_thread_tt(void);
-extern void start_thread_tt(struct pt_regs *regs, unsigned long eip,
-			   unsigned long esp);
-extern int copy_thread_tt(int nr, unsigned long clone_flags, unsigned long sp,
-			  unsigned long stack_top, struct task_struct *p,
-			  struct pt_regs *regs);
-extern void release_thread_tt(struct task_struct *task);
-extern void initial_thread_cb_tt(void (*proc)(void *), void *arg);
-extern void init_idle_tt(void);
-extern void flush_tlb_kernel_range_tt(unsigned long start, unsigned long end);
-extern void flush_tlb_kernel_vm_tt(void);
-extern void __flush_tlb_one_tt(unsigned long addr);
-extern void flush_tlb_range_tt(struct vm_area_struct *vma,
-			       unsigned long start, unsigned long end);
-extern void flush_tlb_mm_tt(struct mm_struct *mm);
-extern void force_flush_all_tt(void);
-extern long execute_syscall_tt(void *r);
-extern void before_mem_tt(unsigned long brk_start);
-extern unsigned long set_task_sizes_tt(int arg, unsigned long *host_size_out,
-				       unsigned long *task_size_out);
-extern int start_uml_tt(void);
-extern int external_pid_tt(struct task_struct *task);
-extern int thread_pid_tt(struct task_struct *task);
-
-#define kmem_end_tt (host_task_size - ABOVE_KMEM)
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-r8169.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
