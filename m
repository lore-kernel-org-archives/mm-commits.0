From: akpm@linux-foundation.org
Subject: + drivers-watchdog-geodewdtc-build-fix.patch added to -mm tree
Date: Fri, 30 May 2008 13:09:14 -0700
Message-ID: <200805302009.m4UK9Eoc009279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbYE3UJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, brigad@rpi.edu, jordan.crouse@amd.com, sfr@canb.auug.org.au, wim@iguana.be


The patch titled
     drivers/watchdog/geodewdt.c: build fix
has been added to the -mm tree.  Its filename is
     drivers-watchdog-geodewdtc-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/watchdog/geodewdt.c: build fix
From: Ingo Molnar <mingo@elte.hu>

-tip testing found the following build failure on latest -git:

  drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
  drivers/watchdog/geodewdt.c:225: error: too many arguments to function 'geode_mfgpt_alloc_timer'
  make[1]: *** [drivers/watchdog/geodewdt.o] Error 1
  make: *** [drivers/watchdog/geodewdt.o] Error 2

with this config:

  http://redhat.com/~mingo/misc/config-Fri_May_30_15_19_52_CEST_2008.bad

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: David Brigada <brigad@rpi.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/geodewdt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/watchdog/geodewdt.c~drivers-watchdog-geodewdtc-build-fix drivers/watchdog/geodewdt.c
--- a/drivers/watchdog/geodewdt.c~drivers-watchdog-geodewdtc-build-fix
+++ a/drivers/watchdog/geodewdt.c
@@ -221,8 +221,7 @@ geodewdt_probe(struct platform_device *d
 {
 	int ret, timer;
 
-	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
-					MFGPT_DOMAIN_WORKING, THIS_MODULE);
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 
 	if (timer == -1) {
 		printk(KERN_ERR "geodewdt:  No timers were available\n");
_

Patches currently in -mm which might be from mingo@elte.hu are

linux-next.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
git-x86-fixup.patch
kgdb-use-put_unaligned_be32-helper.patch
lguest-use-cpu-capability-accessors.patch
arch-x86-mm-patc-nopat-should-be-__init.patch
sched-delete-dead-stuff.patch
sched-delete-dead-stuff-2.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
provide-rtc_cmos-platform-device-take-2.patch
drivers-watchdog-geodewdtc-build-fix.patch
suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
pm-boot-time-suspend-selftest.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
introduce-have_efficient_unaligned_access-kconfig-symbol.patch
percpu-introduce-define_per_cpu_page_aligned.patch
remove-argument-from-open_softirq-which-is-always-null.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
rtc-remove-and-clarify-unneeded-externs.patch
markers-use-rcu_barrier_sched-and-call_rcu_sched.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
kgdb-use-the-common-ascii-hex-helpers.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

