From: akpm@linux-foundation.org
Subject: + proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch added to -mm tree
Date: Tue, 26 Apr 2011 15:03:40 -0700
Message-ID: <201104262203.p3QM3fqA022609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab1DZWEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 18:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, bookjovi@gmail.com, hughd@google.com, wilsons@start.ca


The patch titled
     proc: put check_mem_permission after __get_free_page in mem_write
has been added to the -mm tree.  Its filename is
     proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch

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
Subject: proc: put check_mem_permission after __get_free_page in mem_write
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It whould be better if put check_mem_permission after __get_free_page in
mem_write, to be same as function mem_read.

Hugh Dickins explained the reason.

    check_mem_permission gets a reference to the mm.  If we __get_free_page
    after check_mem_permission, imagine what happens if the system is out
    of memory, and the mm we're looking at is selected for killing by the
    OOM killer: while we wait in __get_free_page for more memory, no memory
    is freed from the selected mm because it cannot reach exit_mmap while
    we hold that reference.

Reported-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Stephen Wilson <wilsons@start.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc-put-check_mem_permission-after-__get_free_page-in-mem_write fs/proc/base.c
--- a/fs/proc/base.c~proc-put-check_mem_permission-after-__get_free_page-in-mem_write
+++ a/fs/proc/base.c
@@ -894,20 +894,20 @@ static ssize_t mem_write(struct file * f
 	if (!task)
 		goto out_no_task;
 
+	copied = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out_task;
+
 	mm = check_mem_permission(task);
 	copied = PTR_ERR(mm);
 	if (IS_ERR(mm))
-		goto out_task;
+		goto out_free;
 
 	copied = -EIO;
 	if (file->private_data != (void *)((long)current->self_exec_id))
 		goto out_mm;
 
-	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		goto out_mm;
-
 	copied = 0;
 	while (count > 0) {
 		int this_len, retval;
@@ -929,9 +929,11 @@ static ssize_t mem_write(struct file * f
 		count -= retval;			
 	}
 	*ppos = dst;
-	free_page((unsigned long) page);
+
 out_mm:
 	mmput(mm);
+out_free:
+	free_page((unsigned long) page);
 out_task:
 	put_task_struct(task);
 out_no_task:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-use-pte-pages-in-oom-score.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
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
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
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
vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch
proc-fix-pagemap_read-error-case-was-re-proc-put-check_mem_permission-before-__get_free_page-in-mem_read.patch

