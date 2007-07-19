From: akpm@linux-foundation.org
Subject: - lguest-export-symbols-for-lguest-as-a-module.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:49 -0700
Message-ID: <200707192004.l6JK4ner019982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760916AbXGSUQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: export symbols for lguest as a module
has been removed from the -mm tree.  Its filename was
     lguest-export-symbols-for-lguest-as-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: export symbols for lguest as a module
From: Rusty Russell <rusty@rustcorp.com.au>

lguest does some fairly lowlevel things to support a host, which
normal modules don't need:

math_state_restore:
	When the guest triggers a Device Not Available fault, we need
	to be able to restore the FPU

__put_task_struct:
	We need to hold a reference to another task for inter-guest
	I/O, and put_task_struct() is an inline function which calls
	__put_task_struct.

access_process_vm:
	We need to access another task for inter-guest I/O.

map_vm_area & __get_vm_area:
	We need to map the switcher shim (ie. monitor) at 0xFFC01000.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |    1 +
 kernel/fork.c            |    1 +
 mm/memory.c              |    1 +
 mm/vmalloc.c             |    2 ++
 4 files changed, 5 insertions(+)

diff -puN arch/i386/kernel/traps.c~lguest-export-symbols-for-lguest-as-a-module arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/arch/i386/kernel/traps.c
@@ -1056,6 +1056,7 @@ asmlinkage void math_state_restore(void)
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
 
diff -puN kernel/fork.c~lguest-export-symbols-for-lguest-as-a-module kernel/fork.c
--- a/kernel/fork.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/kernel/fork.c
@@ -127,6 +127,7 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
diff -puN mm/memory.c~lguest-export-symbols-for-lguest-as-a-module mm/memory.c
--- a/mm/memory.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/mm/memory.c
@@ -2865,3 +2865,4 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+EXPORT_SYMBOL_GPL(access_process_vm);
diff -puN mm/vmalloc.c~lguest-export-symbols-for-lguest-as-a-module mm/vmalloc.c
--- a/mm/vmalloc.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/mm/vmalloc.c
@@ -164,6 +164,7 @@ int map_vm_area(struct vm_struct *area, 
 	flush_cache_vmap((unsigned long) area->addr, end);
 	return err;
 }
+EXPORT_SYMBOL_GPL(map_vm_area);
 
 static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
 					    unsigned long start, unsigned long end,
@@ -242,6 +243,7 @@ struct vm_struct *__get_vm_area(unsigned
 {
 	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(__get_vm_area);
 
 /**
  *	get_vm_area  -  reserve a contingous kernel virtual area
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
