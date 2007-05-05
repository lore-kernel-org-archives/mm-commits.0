From: akpm@linux-foundation.org
Subject: + lguest-export-symbols-for-lguest-as-a-module.patch added to -mm tree
Date: Fri, 04 May 2007 23:53:54 -0700
Message-ID: <200705050653.l456rtuL031829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbXEEGyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 May 2007 02:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: export symbols for lguest as a module
has been added to the -mm tree.  Its filename is
     lguest-export-symbols-for-lguest-as-a-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1058,6 +1058,7 @@ asmlinkage void math_state_restore(void)
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
 
diff -puN kernel/fork.c~lguest-export-symbols-for-lguest-as-a-module kernel/fork.c
--- a/kernel/fork.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/kernel/fork.c
@@ -126,6 +126,7 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
diff -puN mm/memory.c~lguest-export-symbols-for-lguest-as-a-module mm/memory.c
--- a/mm/memory.c~lguest-export-symbols-for-lguest-as-a-module
+++ a/mm/memory.c
@@ -2828,3 +2828,4 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+EXPORT_SYMBOL_GPL(access_process_vm);
diff -puN mm/vmalloc.c~lguest-export-symbols-for-lguest-as-a-module mm/vmalloc.c
--- a/mm/vmalloc.c~lguest-export-symbols-for-lguest-as-a-module
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

origin.patch
array_size-check-for-type.patch
git-kbuild.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
