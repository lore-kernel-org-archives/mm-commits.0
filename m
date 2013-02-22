From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:35:44 -0800
Message-ID: <20130222233545.015655A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60501 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:35:46 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so120314ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:35:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, linfeng@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch

This patch was dropped because it was folded into memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix

put register_page_bootmem_memmap inside CONFIG_MEMORY_HOTPLUG_SPARSE

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix
+++ a/arch/x86/mm/init_64.c
@@ -1034,6 +1034,7 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
@@ -1091,6 +1092,7 @@ void register_page_bootmem_memmap(unsign
 		}
 	}
 }
+#endif
 
 void __meminit vmemmap_populate_print_last(void)
 {
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch
memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch
memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch
memcg-cleanup-mem_cgroup_init-comment.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch

