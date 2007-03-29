From: akpm@linux-foundation.org
Subject: - lguest-preparation-export_symbol_gpl-5-functions.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:46 -0700
Message-ID: <200703292338.l2TNckWW015365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392AbXC2Xix (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest preparation: EXPORT_SYMBOL_GPL 5 functions
has been removed from the -mm tree.  Its filename was
     lguest-preparation-export_symbol_gpl-5-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest preparation: EXPORT_SYMBOL_GPL 5 functions
From: Rusty Russell <rusty@rustcorp.com.au>

lguest does some fairly lowlevel things to support a host, which normal
modules don't need:

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
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |    1 +
 kernel/fork.c            |    1 +
 mm/memory.c              |    1 +
 mm/vmalloc.c             |    2 ++
 4 files changed, 5 insertions(+)

diff -puN arch/i386/kernel/traps.c~lguest-preparation-export_symbol_gpl-5-functions arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~lguest-preparation-export_symbol_gpl-5-functions
+++ a/arch/i386/kernel/traps.c
@@ -1070,6 +1070,7 @@ asmlinkage void math_state_restore(void)
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
 
diff -puN kernel/fork.c~lguest-preparation-export_symbol_gpl-5-functions kernel/fork.c
--- a/kernel/fork.c~lguest-preparation-export_symbol_gpl-5-functions
+++ a/kernel/fork.c
@@ -126,6 +126,7 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
diff -puN mm/memory.c~lguest-preparation-export_symbol_gpl-5-functions mm/memory.c
--- a/mm/memory.c~lguest-preparation-export_symbol_gpl-5-functions
+++ a/mm/memory.c
@@ -2736,3 +2736,4 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+EXPORT_SYMBOL_GPL(access_process_vm);
diff -puN mm/vmalloc.c~lguest-preparation-export_symbol_gpl-5-functions mm/vmalloc.c
--- a/mm/vmalloc.c~lguest-preparation-export_symbol_gpl-5-functions
+++ a/mm/vmalloc.c
@@ -159,6 +159,7 @@ int map_vm_area(struct vm_struct *area, 
 	flush_cache_vmap((unsigned long) area->addr, end);
 	return err;
 }
+EXPORT_SYMBOL_GPL(map_vm_area);
 
 static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
 					    unsigned long start, unsigned long end,
@@ -237,6 +238,7 @@ struct vm_struct *__get_vm_area(unsigned
 {
 	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(__get_vm_area);
 
 /**
  *	get_vm_area  -  reserve a contingous kernel virtual area
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
