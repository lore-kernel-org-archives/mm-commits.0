From: akpm@osdl.org
Subject: + hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:51:24 -0800
Message-ID: <200701310051.l0V0pOVi002961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59628 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbXAaAwD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:52:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu, oleg@tv-sign.ru, rusty@rustcorp.com.au


The patch titled
     hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU
has been added to the -mm tree.  Its filename is
     hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU
From: Avi Kivity <avi@qumranet.com>

KVM wants the cpu hotplug notifications, both for cpu hotplug itself, but more
commonly for host suspend/resume.

In order to avoid extensive #ifdefs, provide stubs when CONFIG_CPU_HOTPLUG is
not defined.

In all, we have four cases:

- UP: register and unregister stubbed out
- SMP+hotplug: full register and unregister
- SMP, no hotplug, core: register as __init, unregister stubbed
      (cpus are brought up during core initialization)
- SMP, no hotplug, module: register and unregister stubbed out
      (cpus cannot be brought up during module lifetime)

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cpu.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/cpu.h~hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers include/linux/cpu.h
--- a/include/linux/cpu.h~hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers
+++ a/include/linux/cpu.h
@@ -49,10 +49,20 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-extern int register_cpu_notifier(struct notifier_block *nb);
 #ifdef CONFIG_HOTPLUG_CPU
+extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
+
+#ifndef MODULE
+extern int register_cpu_notifier(struct notifier_block *nb);
+#else
+static inline int register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+#endif
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch
