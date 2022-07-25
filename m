Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36445C43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiGYTnH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiGYTkR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F359FC2
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E180B810F8
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5833C341C6;
        Mon, 25 Jul 2022 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658778011;
        bh=h49je4HLTPweXsQu8xqpB08EqgabiDdCe639uMMt0KY=;
        h=Date:To:From:Subject:From;
        b=GTPvtQLG8zJmO4sfUhm6jY/rd3b9w99BNPzJR2+OUTPNljRVnKDj5cO2WD6cWknHC
         QEI/MSjtx6Ew/JxUezmu5Wv445YUF8XB7UX445HoBShgtfTr+DD7jap+SVFALw2+Za
         uBgDnybXz6x4+mAiYLxwabN5z0DFRzweGJyYKmWc=
Date:   Mon, 25 Jul 2022 12:40:10 -0700
To:     mm-commits@vger.kernel.org, ben-linux@fluff.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + profile-setup_profiling_timer-is-moslty-not-implemented.patch added to mm-nonmm-unstable branch
Message-Id: <20220725194010.E5833C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: profile: setup_profiling_timer() is moslty not implemented
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profile-setup_profiling_timer-is-moslty-not-implemented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profile-setup_profiling_timer-is-moslty-not-implemented.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ben Dooks <ben-linux@fluff.org>
Subject: profile: setup_profiling_timer() is moslty not implemented
Date: Thu, 21 Jul 2022 20:55:09 +0100

The setup_profiling_timer() is mostly un-implemented by many
architectures.  In many places it isn't guarded by CONFIG_PROFILE which is
needed for it to be used.  Make it a weak symbol in kernel/profile.c and
remove the 'return -EINVAL' implementations from the kenrel.

There are a couple of architectures which do return 0 from the
setup_profiling_timer() function but they don't seem to do anything else
with it.  To keep the /proc compatibility for now, leave these for a
future update or removal.

On ARM, this fixes the following sparse warning:
arch/arm/kernel/smp.c:793:5: warning: symbol 'setup_profiling_timer' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20220721195509.418205-1-ben-linux@fluff.org
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/smp.c     |    6 ------
 arch/arc/kernel/smp.c       |    8 --------
 arch/arm/kernel/smp.c       |    8 --------
 arch/arm64/kernel/smp.c     |    8 --------
 arch/csky/kernel/smp.c      |    5 -----
 arch/hexagon/kernel/smp.c   |    5 -----
 arch/ia64/kernel/smp.c      |    6 ------
 arch/openrisc/kernel/smp.c  |    6 ------
 arch/parisc/kernel/smp.c    |    7 -------
 arch/powerpc/kernel/smp.c   |    7 -------
 arch/riscv/kernel/smp.c     |    6 ------
 arch/sparc/kernel/smp_32.c  |    5 -----
 arch/sparc/kernel/smp_64.c  |    6 ------
 arch/x86/include/asm/apic.h |    2 --
 arch/x86/kernel/apic/apic.c |    5 -----
 kernel/profile.c            |    8 ++++++--
 16 files changed, 6 insertions(+), 92 deletions(-)

--- a/arch/alpha/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/alpha/kernel/smp.c
@@ -497,12 +497,6 @@ smp_cpus_done(unsigned int max_cpus)
 	       ((bogosum + 2500) / (5000/HZ)) % 100);
 }
 
-int
-setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 static void
 send_ipi_message(const struct cpumask *to_whom, enum ipi_message_type operation)
 {
--- a/arch/arc/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/arc/kernel/smp.c
@@ -232,14 +232,6 @@ int __cpu_up(unsigned int cpu, struct ta
 	return 0;
 }
 
-/*
- * not supported here
- */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 /*****************************************************************************/
 /*              Inter Processor Interrupt Handling                           */
 /*****************************************************************************/
--- a/arch/arm64/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/arm64/kernel/smp.c
@@ -1078,14 +1078,6 @@ bool smp_crash_stop_failed(void)
 }
 #endif
 
-/*
- * not supported here
- */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 static bool have_cpu_die(void)
 {
 #ifdef CONFIG_HOTPLUG_CPU
--- a/arch/arm/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/arm/kernel/smp.c
@@ -787,14 +787,6 @@ void panic_smp_self_stop(void)
 		cpu_relax();
 }
 
-/*
- * not supported here
- */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 #ifdef CONFIG_CPU_FREQ
 
 static DEFINE_PER_CPU(unsigned long, l_p_j_ref);
--- a/arch/csky/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/csky/kernel/smp.c
@@ -243,11 +243,6 @@ void __init smp_cpus_done(unsigned int m
 {
 }
 
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 void csky_start_secondary(void)
 {
 	struct mm_struct *mm = &init_mm;
--- a/arch/hexagon/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/hexagon/kernel/smp.c
@@ -240,11 +240,6 @@ void arch_send_call_function_ipi_mask(co
 	send_ipi(mask, IPI_CALL_FUNC);
 }
 
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 void smp_start_cpus(void)
 {
 	int i;
--- a/arch/ia64/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/ia64/kernel/smp.c
@@ -333,9 +333,3 @@ smp_send_stop (void)
 {
 	send_IPI_allbutself(IPI_CPU_STOP);
 }
-
-int
-setup_profiling_timer (unsigned int multiplier)
-{
-	return -EINVAL;
-}
--- a/arch/openrisc/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/openrisc/kernel/smp.c
@@ -197,12 +197,6 @@ void smp_send_stop(void)
 	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
-/* not supported, yet */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 {
 	smp_cross_call = fn;
--- a/arch/parisc/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/parisc/kernel/smp.c
@@ -513,10 +513,3 @@ void __cpu_die(unsigned int cpu)
 
 	pdc_cpu_rendezvous_unlock();
 }
-
-#ifdef CONFIG_PROC_FS
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-#endif
--- a/arch/powerpc/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/powerpc/kernel/smp.c
@@ -1674,13 +1674,6 @@ void start_secondary(void *unused)
 	BUG();
 }
 
-#ifdef CONFIG_PROFILING
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return 0;
-}
-#endif
-
 static void __init fixup_topology(void)
 {
 	int i;
--- a/arch/riscv/kernel/smp.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/riscv/kernel/smp.c
@@ -64,12 +64,6 @@ bool arch_match_cpu_phys_id(int cpu, u64
 	return phys_id == cpuid_to_hartid_map(cpu);
 }
 
-/* Unsupported */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 static void ipi_stop(void)
 {
 	set_cpu_online(smp_processor_id(), false);
--- a/arch/sparc/kernel/smp_32.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/sparc/kernel/smp_32.c
@@ -174,11 +174,6 @@ void smp_call_function_interrupt(void)
 	irq_exit();
 }
 
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	int i, cpuid, extra;
--- a/arch/sparc/kernel/smp_64.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/sparc/kernel/smp_64.c
@@ -1186,12 +1186,6 @@ void __irq_entry smp_penguin_jailcell(in
 	preempt_enable();
 }
 
-/* /proc/profile writes can call this, don't __init it please. */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 }
--- a/arch/x86/include/asm/apic.h~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/x86/include/asm/apic.h
@@ -98,8 +98,6 @@ static inline bool apic_from_smp_config(
 #include <asm/paravirt.h>
 #endif
 
-extern int setup_profiling_timer(unsigned int);
-
 static inline void native_apic_mem_write(u32 reg, u32 v)
 {
 	volatile u32 *addr = (volatile u32 *)(APIC_BASE + reg);
--- a/arch/x86/kernel/apic/apic.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/arch/x86/kernel/apic/apic.c
@@ -1115,11 +1115,6 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_apic_timer
 	set_irq_regs(old_regs);
 }
 
-int setup_profiling_timer(unsigned int multiplier)
-{
-	return -EINVAL;
-}
-
 /*
  * Local APIC start and shutdown
  */
--- a/kernel/profile.c~profile-setup_profiling_timer-is-moslty-not-implemented
+++ a/kernel/profile.c
@@ -425,6 +425,12 @@ read_profile(struct file *file, char __u
 	return read;
 }
 
+/* default is to not implement this call */
+int __weak setup_profiling_timer(unsigned mult)
+{
+	return -EINVAL;
+}
+
 /*
  * Writing to /proc/profile resets the counters
  *
@@ -435,8 +441,6 @@ static ssize_t write_profile(struct file
 			     size_t count, loff_t *ppos)
 {
 #ifdef CONFIG_SMP
-	extern int setup_profiling_timer(unsigned int multiplier);
-
 	if (count == sizeof(int)) {
 		unsigned int multiplier;
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

profile-setup_profiling_timer-is-moslty-not-implemented.patch

