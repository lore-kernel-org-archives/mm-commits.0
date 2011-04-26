From: akpm@linux-foundation.org
Subject: + mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch added to -mm tree
Date: Tue, 26 Apr 2011 12:52:04 -0700
Message-ID: <201104261952.p3QJq4bN014926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946Ab1DZTxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 15:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, arve@android.com, dave@linux.vnet.ibm.com, john.stultz@linaro.org, mel@csn.ul.ie


The patch titled
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve-fix
has been added to the -mm tree.  Its filename is
     mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-=
migrate_reserve-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking=
-it-migrate_reserve-fix
=46rom: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: Arve Hjonnevag <arve@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
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
@@ -3350,7 +3350,7 @@ static int pageblock_is_reserved(unsigne
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
oom-use-pte-pages-in-oom-score.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-shoul=
d-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.pat=
ch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patc=
h
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.=
patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
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
mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migra=
te_reserve-fix.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
alpha-replace-with-new-cpumask-apis.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
