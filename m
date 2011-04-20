From: akpm@linux-foundation.org
Subject: [alternative-merged] lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch removed from -mm tree
Date: Wed, 20 Apr 2011 16:14:25 -0700
Message-ID: <201104202314.p3KNEPTC000714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1DTXOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 19:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jes@wildopensource.com, nicolas.ferre@atmel.com, patrice.vilchez@atmel.com, plagnioj@jcrosoft.com, mm-commits@vger.kernel.org


The patch titled
     lib/genpool.c: document return values, fix gen_pool_add_virt() return value
has been removed from the -mm tree.  Its filename was
     lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/genpool.c: document return values, fix gen_pool_add_virt() return value
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Jes Sorensen <jes@wildopensource.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 ++
 lib/genalloc.c           |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/genalloc.h~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value
+++ a/include/linux/genalloc.h
@@ -45,6 +45,8 @@ extern int gen_pool_add_virt(struct gen_
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
 static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
 			       size_t size, int nid)
diff -puN lib/genalloc.c~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value lib/genalloc.c
--- a/lib/genalloc.c~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value
+++ a/lib/genalloc.c
@@ -48,6 +48,8 @@ EXPORT_SYMBOL(gen_pool_create);
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
 int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
 		 size_t size, int nid)
@@ -59,7 +61,7 @@ int gen_pool_add_virt(struct gen_pool *p
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_init(&chunk->lock);
 	chunk->phys_addr = phys;
@@ -78,6 +80,8 @@ EXPORT_SYMBOL(gen_pool_add_virt);
  * gen_pool_virt_to_phys - return the physical address of memory
  * @pool: pool to allocate from
  * @addr: starting address of memory
+ *
+ * Returns the physical address on success, or ~0UL on error.
  */
 unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

