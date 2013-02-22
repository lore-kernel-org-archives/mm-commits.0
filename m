From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:35:50 -0800
Message-ID: <20130222233551.0D85D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:63448 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:35:52 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so120297qcr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:35:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, linfeng@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: cleanup: removing the arch specific functions without any implementation
has been removed from the -mm tree.  Its filename was
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memory-hotplug: cleanup: removing the arch specific functions without any implementation

After introducing CONFIG_HAVE_BOOTMEM_INFO_NODE Kconfig option, the
related arch specific functions become confusing, remove them.

Guys who want to implement memory-hotplug feature on such archs for this
part should look into register_page_bootmem_info_node() and flesh out from
top to end.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c  |    5 -----
 arch/powerpc/mm/init_64.c |    5 -----
 arch/s390/mm/vmem.c       |    6 ------
 arch/sparc/mm/init_64.c   |    5 -----
 4 files changed, 21 deletions(-)

diff -puN arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/ia64/mm/discontig.c
@@ -823,9 +823,4 @@ int __meminit vmemmap_populate(struct pa
 	return vmemmap_populate_basepages(start_page, size, node);
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif
diff -puN arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/powerpc/mm/init_64.c
@@ -298,10 +298,5 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff -puN arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/s390/mm/vmem.c
@@ -268,12 +268,6 @@ out:
 	return ret;
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
-
 /*
  * Add memory segment to the segment list if it doesn't overlap with
  * an already present segment.
diff -puN arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix
+++ a/arch/sparc/mm/init_64.c
@@ -2230,11 +2230,6 @@ void __meminit vmemmap_populate_print_la
 	}
 }
 
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-	/* TODO */
-}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
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

