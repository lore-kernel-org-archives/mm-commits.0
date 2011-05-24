From: akpm@linux-foundation.org
Subject: [folded] mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:56:06 -0700
Message-ID: <201105242356.p4ONu7dT023899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933171Ab1EXX4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, arve@android.com, dave@linux.vnet.ibm.com, john.stultz@linaro.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve-fix
has been removed from the -mm tree.  Its filename was
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve-fix.patch

This patch was dropped because it was folded into mm-check-if-any-page-=
in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking=
-it-migrate_reserve-fix
=46rom: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserv=
ed-before-marking-it-migrate_reserve-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-if-any-page-in-a-pageblock-is-reserved-b=
efore-marking-it-migrate_reserve-fix
+++ a/mm/page_alloc.c
@@ -3335,7 +3335,7 @@ static int pageblock_is_reserved(unsigne
 	unsigned long pfn;
=20
 	for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
-		if (PageReserved(pfn_to_page(pfn)))
+		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
 			return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu=
=2Ecom are

origin.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-shoul=
d-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.pat=
ch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patc=
h
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migra=
te_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migra=
te_reserve-fix-2.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patc=
h
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.pa=
tch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.p=
atch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-f=
ix.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=3Dn.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
alpha-replace-with-new-cpumask-apis.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
