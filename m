From: akpm@linux-foundation.org
Subject: - x86-constify-wd_ops.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:22 -0700
Message-ID: <200709202117.l8KLHMNc003075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbXITV20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     x86: constify wd_ops
has been removed from the -mm tree.  Its filename was
     x86-constify-wd_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: constify wd_ops
From: "Jan Beulich" <jbeulich@novell.com>

.. as they're, with a single exception, never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~x86-constify-wd_ops arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~x86-constify-wd_ops
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -34,7 +34,7 @@ struct wd_ops {
 	u64 checkbit;
 };
 
-static struct wd_ops *wd_ops;
+static const struct wd_ops *wd_ops;
 
 /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
  * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
@@ -325,7 +325,7 @@ static void single_msr_rearm(struct nmi_
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops k7_wd_ops = {
+static const struct wd_ops k7_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_k7_watchdog,
@@ -388,7 +388,7 @@ static void p6_rearm(struct nmi_watchdog
 	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
 }
 
-static struct wd_ops p6_wd_ops = {
+static const struct wd_ops p6_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_p6_watchdog,
@@ -540,7 +540,7 @@ static void p4_rearm(struct nmi_watchdog
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops p4_wd_ops = {
+static const struct wd_ops p4_wd_ops = {
 	.reserve = p4_reserve,
 	.unreserve = p4_unreserve,
 	.setup = setup_p4_watchdog,
@@ -558,6 +558,8 @@ static struct wd_ops p4_wd_ops = {
 #define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
 #define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
 
+static struct wd_ops intel_arch_wd_ops;
+
 static int setup_intel_arch_watchdog(unsigned nmi_hz)
 {
 	unsigned int ebx;
@@ -599,11 +601,11 @@ static int setup_intel_arch_watchdog(uns
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  //unused
-	wd_ops->checkbit = 1ULL << (eax.split.bit_width - 1);
+	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
 }
 
-static struct wd_ops intel_arch_wd_ops = {
+static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_intel_arch_watchdog,
_

Patches currently in -mm which might be from jbeulich@novell.com are

tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
