From: akpm@linux-foundation.org
Subject: + intel_cacheinfo-misc-section-annotation-fixes.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:22:24 -0700
Message-ID: <200708232222.l7NMMOCh029713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762213AbXHWWWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, ak@suse.de, venkatesh.pallipadi@intel.com


The patch titled
     intel_cacheinfo: Misc section annotation fixes /  cleanups
has been added to the -mm tree.  Its filename is
     intel_cacheinfo-misc-section-annotation-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-misc-section-annotation-fixes arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-misc-section-annotation-fixes
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -170,15 +170,15 @@ union l3_cache {
 	unsigned val;
 };
 
-static const unsigned short assocs[] = {
+static const unsigned short assocs[] __cpuinitdata = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static const unsigned char levels[] = { 1, 1, 2, 3 };
-static const unsigned char types[] = { 1, 2, 3, 3 };
+static const unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
+static const unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
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
@@ -782,7 +782,7 @@ static struct notifier_block __cpuinitda
     .notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
