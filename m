From: akpm@linux-foundation.org
Subject: - intel_cacheinfo-misc-section-annotation-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:43 -0700
Message-ID: <200710180707.l9I77hpY031724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759556AbXJRHIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel_cacheinfo: Misc section annotation fixes /  cleanups
has been removed from the -mm tree.  Its filename was
     intel_cacheinfo-misc-section-annotation-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_cacheinfo: Misc section annotation fixes /  cleanups
From: Satyam Sharma <satyam@infradead.org>

cache_sysfs_init() is only ever called at device_initcall() time.  Marking it
__cpuinit is quite wrong, and wasteful when HOTPLUG_CPU=y.  It must be __init.

cache_shared_cpu_map_setup() and cache_remove_shared_cpu_map(), OTOH, are
functions called from another function that is __cpuinit.  But the !CONFIG_SMP
empty-body stubs of these functions are unconditionally marked __init, which
is actively wrong, and will lead to oops.  But we never saw this oops, because
they always managed to get inlined in their callsites, by virtue of being
empty-body stubs!  They should still be __cpuinit, of course.

assocs[], levels[] and types[] are only referenced from function that is
__cpuinit.  So these are candidates for being marked __cpuinitdata.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-misc-section-annotation-fixes arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-misc-section-annotation-fixes
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -170,15 +170,15 @@ union l3_cache {
 	unsigned val;
 };
 
-static const unsigned short assocs[] = {
+static unsigned short assocs[] __cpuinitdata = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static const unsigned char levels[] = { 1, 1, 2, 3 };
-static const unsigned char types[] = { 1, 2, 3, 3 };
+static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
+static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
 static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		       union _cpuid4_leaf_ebx *ebx,
@@ -493,8 +493,8 @@ static void __cpuinit cache_remove_share
 	}
 }
 #else
-static void __init cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
-static void __init cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
+static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
 static void free_cache_attributes(unsigned int cpu)
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
