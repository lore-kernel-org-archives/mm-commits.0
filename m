From: akpm@linux-foundation.org
Subject: - revert-memory-hotplug-register-section-node-id-to-free.patch removed from -mm tree
Date: Wed, 07 May 2008 00:46:57 -0700
Message-ID: <200805070746.m477kv8B018577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbYEGHrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 03:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, pbadari@us.ibm.com, tony@bakeyournoodle.com, torvalds@linux-foundation.org, y-goto@jp.fujitsu.com, yhlu.kernel@g


The patch titled
     revert "memory hotplug: register section/node id to free"
has been removed from the -mm tree.  Its filename was
     revert-memory-hotplug-register-section-node-id-to-free.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "memory hotplug: register section/node id to free"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 04753278769f3b6c3b79a080edb52f21d83bf6e2
Author: Yasunori Goto <y-goto@jp.fujitsu.com>
Date:   Mon Apr 28 02:13:31 2008 -0700

    memory hotplug: register section/node id to free

    This patch set is to free pages which is allocated by bootmem for
    memory-hotremove.  Some structures of memory management are allocated by
    bootmem.  ex) memmap, etc.
    
    To remove memory physically, some of them must be freed according to
    circumstance.  This patch set makes basis to free those pages, and free
    memmaps.
    
    Basic my idea is using remain members of struct page to remember information
    of users of bootmem (section number or node id).  When the section is
    removing, kernel can confirm it.  By this information, some issues can be
    solved.
    
      1) When the memmap of removing section is allocated on other
         section by bootmem, it should/can be free.
      2) When the memmap of removing section is allocated on the
         same section, it shouldn't be freed. Because the section has to be
         logical memory offlined already and all pages must be isolated against
         page allocater. If it is freed, page allocator may use it which will
         be removed physically soon.
      3) When removing section has other section's memmap,
         kernel will be able to show easily which section should be removed
         before it for user. (Not implemented yet)
      4) When the above case 2), the page isolation will be able to check and skip
         memmap's page when logical memory offline (offline_pages()).
         Current page isolation code fails in this case because this page is
         just reserved page and it can't distinguish this pages can be
         removed or not. But, it will be able to do by this patch.
         (Not implemented yet.)
      5) The node information like pgdat has similar issues. But, this
         will be able to be solved too by this.
         (Not implemented yet, but, remembering node id in the pages.)
    
    Fortunately, current bootmem allocator just keeps PageReserved flags,
    and doesn't use any other members of page struct. The users of
    bootmem doesn't use them too.
    
    This patch:
    
    This is to register information which is node or section's id.  Kernel can
    distinguish which node/section uses the pages allcated by bootmem.  This is
    basis for hot-remove sections or nodes.
    
    Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Cc: Badari Pulavarty <pbadari@us.ibm.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Due to:

On Thu, 1 May 2008 15:13:05 +1000 tony@bakeyournoodle.com (Tony Breeds) wrote:

> On Tue, Apr 29, 2008 at 11:12:41PM -0700, David Miller wrote:
> at this commit.   However reverting just this one comitt doesn't fix the
> regression.  I also needed to revert
> 04753278769f3b6c3b79a080edb52f21d83bf6e2 (memory hotplug: register
> section/node id to free")
> 
> Problem seen on power4, power5 and ps3.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   27 --------
 include/linux/mmzone.h         |    1 
 mm/bootmem.c                   |    1 
 mm/memory_hotplug.c            |   99 -------------------------------
 mm/sparse.c                    |    3 
 5 files changed, 3 insertions(+), 128 deletions(-)

diff -puN include/linux/memory_hotplug.h~revert-memory-hotplug-register-section-node-id-to-free include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~revert-memory-hotplug-register-section-node-id-to-free
+++ a/include/linux/memory_hotplug.h
@@ -11,15 +11,6 @@ struct pglist_data;
 struct mem_section;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-
-/*
- * Magic number for free bootmem.
- * The normal smallest mapcount is -1. Here is smaller value than it.
- */
-#define SECTION_INFO		0xfffffffe
-#define MIX_INFO		0xfffffffd
-#define NODE_INFO		0xfffffffc
-
 /*
  * pgdat resizing functions
  */
@@ -154,18 +145,6 @@ static inline void arch_refresh_nodedata
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-static inline void put_page_bootmem(struct page *page)
-{
-}
-#else
-extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
-extern void put_page_bootmem(struct page *page);
-#endif
-
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
@@ -193,10 +172,6 @@ static inline int mhp_notimplemented(con
 	return -ENOSYS;
 }
 
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 extern int add_memory(int nid, u64 start, u64 size);
@@ -205,7 +180,5 @@ extern int remove_memory(u64 start, u64 
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
-extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
-					  unsigned long pnum);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN include/linux/mmzone.h~revert-memory-hotplug-register-section-node-id-to-free include/linux/mmzone.h
--- a/include/linux/mmzone.h~revert-memory-hotplug-register-section-node-id-to-free
+++ a/include/linux/mmzone.h
@@ -896,7 +896,6 @@ static inline struct mem_section *__nr_t
 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
 extern int __section_nr(struct mem_section* ms);
-extern unsigned long usemap_size(void);
 
 /*
  * We use the lower bits of the mem_map pointer to store
diff -puN mm/bootmem.c~revert-memory-hotplug-register-section-node-id-to-free mm/bootmem.c
--- a/mm/bootmem.c~revert-memory-hotplug-register-section-node-id-to-free
+++ a/mm/bootmem.c
@@ -461,7 +461,6 @@ void __init free_bootmem_node(pg_data_t 
 
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
-	register_page_bootmem_info_node(pgdat);
 	return free_all_bootmem_core(pgdat);
 }
 
diff -puN mm/memory_hotplug.c~revert-memory-hotplug-register-section-node-id-to-free mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~revert-memory-hotplug-register-section-node-id-to-free
+++ a/mm/memory_hotplug.c
@@ -60,105 +60,8 @@ static void release_memory_resource(stru
 	return;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void get_page_bootmem(unsigned long info,  struct page *page, int magic)
-{
-	atomic_set(&page->_mapcount, magic);
-	SetPagePrivate(page);
-	set_page_private(page, info);
-	atomic_inc(&page->_count);
-}
-
-void put_page_bootmem(struct page *page)
-{
-	int magic;
-
-	magic = atomic_read(&page->_mapcount);
-	BUG_ON(magic >= -1);
-
-	if (atomic_dec_return(&page->_count) == 1) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		reset_page_mapcount(page);
-		__free_pages_bootmem(page, 0);
-	}
-
-}
-
-void register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long *usemap, mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-
-	if (!pfn_valid(start_pfn))
-		return;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	/* Get section's memmap address */
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	/*
-	 * Get page for the memmap's phys address
-	 * XXX: need more consideration for sparse_vmemmap...
-	 */
-	page = virt_to_page(memmap);
-	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
-	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
-
-	/* remember memmap's page */
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, SECTION_INFO);
-
-	usemap = __nr_to_section(section_nr)->pageblock_flags;
-	page = virt_to_page(usemap);
-
-	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_INFO);
-
-}
-
-void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-	unsigned long i, pfn, end_pfn, nr_pages;
-	int node = pgdat->node_id;
-	struct page *page;
-	struct zone *zone;
-
-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
-	page = virt_to_page(pgdat);
-
-	for (i = 0; i < nr_pages; i++, page++)
-		get_page_bootmem(node, page, NODE_INFO);
-
-	zone = &pgdat->node_zones[0];
-	for (; zone < pgdat->node_zones + MAX_NR_ZONES - 1; zone++) {
-		if (zone->wait_table) {
-			nr_pages = zone->wait_table_hash_nr_entries
-				* sizeof(wait_queue_head_t);
-			nr_pages = PAGE_ALIGN(nr_pages) >> PAGE_SHIFT;
-			page = virt_to_page(zone->wait_table);
-
-			for (i = 0; i < nr_pages; i++, page++)
-				get_page_bootmem(node, page, NODE_INFO);
-		}
-	}
-
-	pfn = pgdat->node_start_pfn;
-	end_pfn = pfn + pgdat->node_spanned_pages;
-
-	/* register_section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION)
-		register_page_bootmem_info_section(pfn);
-
-}
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static int __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
diff -puN mm/sparse.c~revert-memory-hotplug-register-section-node-id-to-free mm/sparse.c
--- a/mm/sparse.c~revert-memory-hotplug-register-section-node-id-to-free
+++ a/mm/sparse.c
@@ -211,6 +211,7 @@ static unsigned long sparse_encode_mem_m
 /*
  * Decode mem_map from the coded memmap
  */
+static
 struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
 {
 	/* mask off the extra low bits of information */
@@ -233,7 +234,7 @@ static int __meminit sparse_init_one_sec
 	return 1;
 }
 
-unsigned long usemap_size(void)
+static unsigned long usemap_size(void)
 {
 	unsigned long size_bytes;
 	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

