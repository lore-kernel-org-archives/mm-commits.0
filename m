From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-avoid-abuse-of-red_inactive.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:05 -0700
Message-ID: <201107260752.p6Q7q8Zg003090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab1GZHwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hartleys@visionengravers.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/memblock.c: avoid abuse of RED_INACTIVE
has been removed from the -mm tree.  Its filename was
     mm-memblockc-avoid-abuse-of-red_inactive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memblock.c: avoid abuse of RED_INACTIVE
From: Andrew Morton <akpm@linux-foundation.org>

RED_INACTIVE is a slab thing, and reusing it for memblock was
inappropriate, because memblock is dealing with phys_addr_t's which have a
Kconfigurable sizeof().

Create a new poison type for this application.  Fixes the sparse warning

	warning: cast truncates bits from constant value (9f911029d74e35b becomes 9d74e35b)
	

Reported-by: H Hartley Sweeten <hartleys@visionengravers.com>
Tested-by: H Hartley Sweeten <hartleys@visionengravers.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    6 ++++++
 mm/memblock.c          |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN include/linux/poison.h~mm-memblockc-avoid-abuse-of-red_inactive include/linux/poison.h
--- a/include/linux/poison.h~mm-memblockc-avoid-abuse-of-red_inactive
+++ a/include/linux/poison.h
@@ -40,6 +40,12 @@
 #define	RED_INACTIVE	0x09F911029D74E35BULL	/* when obj is inactive */
 #define	RED_ACTIVE	0xD84156C5635688C0ULL	/* when obj is active */
 
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+#define MEMBLOCK_INACTIVE	0x3a84fb0144c9e71bULL
+#else
+#define MEMBLOCK_INACTIVE	0x44c9e71bUL
+#endif
+
 #define SLUB_RED_INACTIVE	0xbb
 #define SLUB_RED_ACTIVE		0xcc
 
diff -puN mm/memblock.c~mm-memblockc-avoid-abuse-of-red_inactive mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-avoid-abuse-of-red_inactive
+++ a/mm/memblock.c
@@ -758,9 +758,9 @@ void __init memblock_analyze(void)
 
 	/* Check marker in the unused last array entry */
 	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= (phys_addr_t)RED_INACTIVE);
+		!= MEMBLOCK_INACTIVE);
 	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= (phys_addr_t)RED_INACTIVE);
+		!= MEMBLOCK_INACTIVE);
 
 	memblock.memory_size = 0;
 
@@ -786,8 +786,8 @@ void __init memblock_init(void)
 	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
 
 	/* Write a marker in the unused last array entry */
-	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
-	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
+	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
+	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
 
 	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
 	 * This simplifies the memblock_add() code below...
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

