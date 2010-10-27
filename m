From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-apic-io_apicc-fix-warning.patch added to -mm tree
Date: Wed, 27 Oct 2010 13:36:03 -0700
Message-ID: <201010272107.o9RL7rse018212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932270Ab0J0VIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 17:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/apic/io_apic.c: fix warning
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-apic-io_apicc-fix-warning.patch

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
Subject: arch/x86/kernel/apic/io_apic.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/apic/io_apic.c: In function 'ack_apic_level':
arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable 'desc'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-warning arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-warning
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -2430,13 +2430,12 @@ static void ack_apic_level(struct irq_da
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
drivers-rtc-rtc-jz4740c-add-alarm-function-checkpatch-fixes.patch
gpio-add-support-for-74x164-serial-in-parallel-out-8-bit-shift-register-fix.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
ptrace-cleanup-arch_ptrace-on-x86-fix.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch

