From: akpm@linux-foundation.org
Subject: - i386-intel_cacheinfocfind_num_cache_leaves-should.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:15 -0700
Message-ID: <200707230934.l6N9YFF6016367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335AbXGWJfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: intel_cacheinfo.c:find_num_cache_leaves() should be __cpuinit
has been removed from the -mm tree.  Its filename was
     i386-intel_cacheinfocfind_num_cache_leaves-should.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: intel_cacheinfo.c:find_num_cache_leaves() should be __cpuinit
From: Adrian Bunk <bunk@stusta.de>

WARNING: arch/i386/kernel/built-in.o(.text+0xb6a7): Section mismatch: reference to .init.text:find_num_cache_leaves (between 'init_intel_cacheinfo' and 'cache_shared_cpu_map_setup')

It could be __init_refok, but gcc >= 4.0 anyway inlines it into the
__cpuinit init_intel_cacheinfo(), and IMHO it's too small for "noinline
__init".

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~i386-intel_cacheinfocfind_num_cache_leaves-should arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~i386-intel_cacheinfocfind_num_cache_leaves-should
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -239,8 +239,7 @@ static int __cpuinit cpuid4_cache_lookup
 	return 0;
 }
 
-/* will only be called once; __init is safe here */
-static int __init find_num_cache_leaves(void)
+static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
 	union _cpuid4_leaf_eax	cache_eax;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
