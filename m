From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch added to -mm tree
Date: Fri, 11 Jan 2013 13:13:55 -0800
Message-ID: <20130111211356.161B2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:34704 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3AKVN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jan 2013 16:13:58 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so133065wgb.0
        for <mm-commits@vger.kernel.org>; Fri, 11 Jan 2013 13:13:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, linfeng@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug-remove-memmap-of-sparse-vmemmap-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memory-hotplug-remove-memmap-of-sparse-vmemmap-fix

Defconfig for x86_64 complains:
arch/x86/mm/init_64.c: In function `vmemmap_free':
arch/x86/mm/init_64.c:1317: error: implicit declaration of function `remove_pagetable'

vmemmap_free is only used for CONFIG_MEMORY_HOTPLUG so let's move it
inside ifdef

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   16 ++++++++--------
 include/linux/mm.h    |    2 ++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap-fix
+++ a/arch/x86/mm/init_64.c
@@ -981,6 +981,14 @@ remove_pagetable(unsigned long start, un
 	flush_tlb_all();
 }
 
+void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	remove_pagetable(start, end, false);
+}
+
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1309,14 +1317,6 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
-void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
-{
-	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
-
-	remove_pagetable(start, end, false);
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
diff -puN include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap-fix include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap-fix
+++ a/include/linux/mm.h
@@ -1720,7 +1720,9 @@ int vmemmap_populate_basepages(struct pa
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
+#ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(struct page *memmap, unsigned long nr_pages);
+#endif
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long size);
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

