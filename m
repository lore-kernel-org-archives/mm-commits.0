From: akpm@linux-foundation.org
Subject: - intel_cacheinfo-adjustmentspatch.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:48 -0700
Message-ID: <200709160926.l8G9Qm7E009208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbXIPJjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, akinobu.mita@gmail.com, ashok.raj@intel.com, stable@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel_cacheinfo: fix null pointer deref
has been removed from the -mm tree.  Its filename was
     intel_cacheinfo-adjustmentspatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_cacheinfo: fix null pointer deref
From: "Jan Beulich" <jbeulich@novell.com>

Prevent doing anything from cache_remove_dev() when info setup failed.

(akpm: am awaiting a better Subject: and changelog)

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-adjustmentspatch arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-adjustmentspatch
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -748,6 +748,8 @@ static void __cpuinit cache_remove_dev(s
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
+	if (unlikely(cpuid4_info[cpu] == NULL))
+		return;
 	for (i = 0; i < num_cache_leaves; i++) {
 		cache_remove_shared_cpu_map(cpu, i);
 		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
x86-misc-constifications.patch
x86-constify-stacktrace_ops.patch
x86-constify-wd_ops.patch
x86-multi-byte-single-instruction-nops.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
