From: akpm@linux-foundation.org
Subject: + intel_cacheinfo-adjustmentspatch.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:27:47 -0700
Message-ID: <200709132227.l8DMRls4008944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbXIMW2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de, akinobu.mita@gmail.com, ashok.raj@intel.com, stable@kernel.org, venkatesh.pallipadi@intel.com


The patch titled
     intel_cacheinfo: fix something
has been added to the -mm tree.  Its filename is
     intel_cacheinfo-adjustmentspatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_cacheinfo: fix something
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

intel_cacheinfo-adjustmentspatch.patch
revert-x86_64-mm-intel_cacheinfo-adjustments.patch
fix-x86_64-mm-unwinder.patch
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
