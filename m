From: akpm@linux-foundation.org
Subject: +
 mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch added to -mm tree
Date: Wed, 01 Oct 2014 15:22:09 -0700
Message-ID: <542c7e91.EHrhbM1L7i08tFHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaJAWWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: add vmstat counters and kpageflags bit
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm/balloon_compaction: add vmstat counters and kpageflags bit

Always mark pages with PageBalloon even if balloon compaction is disabled
and expose this mark in /proc/kpageflags as KPF_BALLOON.

Also this patch adds three counters into /proc/vmstat: "balloon_inflate",
"balloon_deflate" and "balloon_migrate".  They accumulate balloon
activity.  Current size of balloon is (balloon_inflate - balloon_deflate)
pages.

All generic balloon code now gathered under option CONFIG_MEMORY_BALLOON. 
It should be selected by ballooning driver which wants use this feature. 
Currently virtio-balloon is the only user.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/Kconfig                 |    1 +
 drivers/virtio/virtio_balloon.c        |    1 +
 fs/proc/page.c                         |    3 +++
 include/linux/balloon_compaction.h     |    2 ++
 include/linux/vm_event_item.h          |    7 +++++++
 include/uapi/linux/kernel-page-flags.h |    1 +
 mm/Kconfig                             |    7 ++++++-
 mm/Makefile                            |    3 ++-
 mm/balloon_compaction.c                |    2 ++
 mm/vmstat.c                            |   12 +++++++++++-
 tools/vm/page-types.c                  |    1 +
 11 files changed, 37 insertions(+), 3 deletions(-)

diff -puN drivers/virtio/Kconfig~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit drivers/virtio/Kconfig
--- a/drivers/virtio/Kconfig~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/drivers/virtio/Kconfig
@@ -25,6 +25,7 @@ config VIRTIO_PCI
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
+	select MEMORY_BALLOON
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff -puN drivers/virtio/virtio_balloon.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/drivers/virtio/virtio_balloon.c
@@ -396,6 +396,7 @@ static int virtballoon_migratepage(struc
 	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
 	balloon_page_insert(vb_dev_info, newpage);
 	vb_dev_info->isolated_pages--;
+	__count_vm_event(BALLOON_MIGRATE);
 	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb->pfns, newpage);
diff -puN fs/proc/page.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit fs/proc/page.c
--- a/fs/proc/page.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/fs/proc/page.c
@@ -133,6 +133,9 @@ u64 stable_page_flags(struct page *page)
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
 
+	if (PageBalloon(page))
+		u |= 1 << KPF_BALLOON;
+
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/include/linux/balloon_compaction.h
@@ -166,11 +166,13 @@ static inline gfp_t balloon_mapping_gfp_
 static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	__SetPageBalloon(page);
 	list_add(&page->lru, &balloon->pages);
 }
 
 static inline void balloon_page_delete(struct page *page)
 {
+	__ClearPageBalloon(page);
 	list_del(&page->lru);
 }
 
diff -puN include/linux/vm_event_item.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/include/linux/vm_event_item.h
@@ -72,6 +72,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+#ifdef CONFIG_MEMORY_BALLOON
+		BALLOON_INFLATE,
+		BALLOON_DEFLATE,
+#ifdef CONFIG_BALLOON_COMPACTION
+		BALLOON_MIGRATE,
+#endif
+#endif
 #ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
diff -puN include/uapi/linux/kernel-page-flags.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -31,6 +31,7 @@
 
 #define KPF_KSM			21
 #define KPF_THP			22
+#define KPF_BALLOON		23
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff -puN mm/Kconfig~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit mm/Kconfig
--- a/mm/Kconfig~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/mm/Kconfig
@@ -231,11 +231,16 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	boolean
 
 #
+# support for memory balloon
+config MEMORY_BALLOON
+	boolean
+
+#
 # support for memory balloon compaction
 config BALLOON_COMPACTION
 	bool "Allow for balloon memory compaction/migration"
 	def_bool y
-	depends on COMPACTION && VIRTIO_BALLOON
+	depends on COMPACTION && MEMORY_BALLOON
 	help
 	  Memory fragmentation introduced by ballooning might reduce
 	  significantly the number of 2MB contiguous memory blocks that can be
diff -puN mm/Makefile~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit mm/Makefile
--- a/mm/Makefile~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/mm/Makefile
@@ -16,7 +16,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o balloon_compaction.o vmacache.o \
+			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   iov_iter.o debug.o $(mmu-y)
 
@@ -64,3 +64,4 @@ obj-$(CONFIG_ZBUD)	+= zbud.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
+obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
diff -puN mm/balloon_compaction.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/mm/balloon_compaction.c
@@ -36,6 +36,7 @@ struct page *balloon_page_enqueue(struct
 	BUG_ON(!trylock_page(page));
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, page);
+	__count_vm_event(BALLOON_INFLATE);
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 	unlock_page(page);
 	return page;
@@ -74,6 +75,7 @@ struct page *balloon_page_dequeue(struct
 			}
 			spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 			balloon_page_delete(page);
+			__count_vm_event(BALLOON_DEFLATE);
 			spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 			unlock_page(page);
 			dequeued_page = true;
diff -puN mm/vmstat.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit mm/vmstat.c
--- a/mm/vmstat.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/mm/vmstat.c
@@ -735,7 +735,7 @@ static void walk_zones_in_node(struct se
 					TEXT_FOR_HIGHMEM(xx) xx "_movable",
 
 const char * const vmstat_text[] = {
-	/* Zoned VM counters */
+	/* enum zone_stat_item countes */
 	"nr_free_pages",
 	"nr_alloc_batch",
 	"nr_inactive_anon",
@@ -778,10 +778,13 @@ const char * const vmstat_text[] = {
 	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
 	"nr_free_cma",
+
+	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
+	/* enum vm_event_item counters */
 	"pgpgin",
 	"pgpgout",
 	"pswpin",
@@ -860,6 +863,13 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_MEMORY_BALLOON
+	"balloon_inflate",
+	"balloon_deflate",
+#ifdef CONFIG_BALLOON_COMPACTION
+	"balloon_migrate",
+#endif
+#endif /* CONFIG_MEMORY_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
diff -puN tools/vm/page-types.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit tools/vm/page-types.c
--- a/tools/vm/page-types.c~mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit
+++ a/tools/vm/page-types.c
@@ -132,6 +132,7 @@ static const char * const page_flag_name
 	[KPF_NOPAGE]		= "n:nopage",
 	[KPF_KSM]		= "x:ksm",
 	[KPF_THP]		= "t:thp",
+	[KPF_BALLOON]		= "o:balloon",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-redesign-ballooned-pages-management.patch
mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch
mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch
linux-next.patch

