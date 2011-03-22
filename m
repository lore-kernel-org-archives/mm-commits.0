From: akpm@linux-foundation.org
Subject: + page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch added to -mm tree
Date: Tue, 22 Mar 2011 14:09:04 -0700
Message-ID: <201103222109.p2ML95Uq027799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216Ab1CVVJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 17:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@in.ibm.com, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
has been added to the -mm tree.  Its filename is
     page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
From: Johannes Weiner <hannes@cmpxchg.org>

Subject: mm: do not define unused free_page_cgroup without memory hotplug

Without memory hotplug configured in, the page cgroup array is never
actually freed again:

mm/page_cgroup.c:149:13: warning: `free_page_cgroup' defined but not used

Wrap the definition in ifdefs.  Rather than moving it into an existing
ifdef section, to keep it close to its allocation counterpart.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Ackedy-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
+++ a/mm/page_cgroup.c
@@ -146,6 +146,7 @@ static void *__init_refok alloc_page_cgr
 	return addr;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 static void free_page_cgroup(void *addr)
 {
 	if (is_vmalloc_addr(addr)) {
@@ -159,6 +160,7 @@ static void free_page_cgroup(void *addr)
 		}
 	}
 }
+#endif
 
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-simplify-code-of-swapc.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

