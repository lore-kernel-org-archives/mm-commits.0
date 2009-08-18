From: akpm@linux-foundation.org
Subject: + misc-remove-redundant-start_kernel-prototypes.patch added to -mm tree
Date: Tue, 18 Aug 2009 16:09:37 -0700
Message-ID: <200908182309.n7IN9bSb030882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbZHRXJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 19:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, dhowells@redhat.com


The patch titled
     misc: remove redundant start_kernel prototypes
has been added to the -mm tree.  Its filename is
     misc-remove-redundant-start_kernel-prototypes.patch

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
Subject: misc: remove redundant start_kernel prototypes
From: Rusty Russell <rusty@rustcorp.com.au>

Impact: cleanup

No need for redeclaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/gdb-stub.h     |    1 -
 arch/mn10300/include/asm/gdb-stub.h |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/frv/include/asm/gdb-stub.h~misc-remove-redundant-start_kernel-prototypes arch/frv/include/asm/gdb-stub.h
--- a/arch/frv/include/asm/gdb-stub.h~misc-remove-redundant-start_kernel-prototypes
+++ a/arch/frv/include/asm/gdb-stub.h
@@ -90,7 +90,6 @@ extern void gdbstub_do_rx(void);
 extern asmlinkage void __debug_stub_init_break(void);
 extern asmlinkage void __break_hijack_kernel_event(void);
 extern asmlinkage void __break_hijack_kernel_event_breaks_here(void);
-extern asmlinkage void start_kernel(void);
 
 extern asmlinkage void gdbstub_rx_handler(void);
 extern asmlinkage void gdbstub_rx_irq(void);
diff -puN arch/mn10300/include/asm/gdb-stub.h~misc-remove-redundant-start_kernel-prototypes arch/mn10300/include/asm/gdb-stub.h
--- a/arch/mn10300/include/asm/gdb-stub.h~misc-remove-redundant-start_kernel-prototypes
+++ a/arch/mn10300/include/asm/gdb-stub.h
@@ -109,7 +109,6 @@ extern asmlinkage int  gdbstub_intercept
 extern asmlinkage void gdbstub_exception(struct pt_regs *, enum exception_code);
 extern asmlinkage void __gdbstub_bug_trap(void);
 extern asmlinkage void __gdbstub_pause(void);
-extern asmlinkage void start_kernel(void);
 
 #ifndef CONFIG_MN10300_CACHE_DISABLED
 extern asmlinkage void gdbstub_purge_cache(void);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
kmod-fix-race-in-usermodehelper-code.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
misc-remove-redundant-start_kernel-prototypes.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
cpu_hotplug-dont-affect-current-tasks-affinity.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch
reiser4.patch

