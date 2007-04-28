From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:34:27 -0700
Message-ID: <200704280134.l3S1YRBa012619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030848AbXD1Bec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     Fix lguest oops when guest dies while receiving I/O
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix lguest oops when guest dies while receiving I/O
From: Rusty Russell <rusty@rustcorp.com.au>

lguest needs to hold a reference to its task in case it exits while another
Guest is sending it I/O.  Otherwise we can oops in
access_process_vm->get_task_mm->task_lock().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o
+++ a/drivers/lguest/lguest_user.c
@@ -107,7 +107,8 @@ static int initialize(struct file *file,
 	setup_regs(lg->regs, args[2]);
 	setup_guest_gdt(lg);
 	lg->tsk = current;
-	lg->mm = get_task_mm(current);
+	get_task_struct(lg->tsk);
+	lg->mm = get_task_mm(lg->tsk);
 	lg->last_pages = NULL;
 	mutex_unlock(&lguest_lock);
 
@@ -160,6 +161,7 @@ static int close(struct inode *inode, st
 	mutex_lock(&lguest_lock);
 	release_all_dma(lg);
 	free_guest_pagetable(lg);
+	put_task_struct(lg->tsk);
 	mmput(lg->mm);
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

extend-print_symbol-capability.patch
git-kbuild.patch
git-net.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
