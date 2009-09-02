From: akpm@linux-foundation.org
Subject: + kcore-register-vmemmap-range.patch added to -mm tree
Date: Wed, 02 Sep 2009 15:51:22 -0700
Message-ID: <200909022251.n82MpNK5029187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbZIBXBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 19:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, jirislaby@gmail.com, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     kcore: register vmemmap range
has been added to the -mm tree.  Its filename is
     kcore-register-vmemmap-range.patch

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
Subject: kcore: register vmemmap range
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Benjamin Herrenschmidt <benh@kernel.crashing.org> pointed out that vmemmap
range is not included in KCORE_RAM, KCORE_VMALLOC ....

This adds KCORE_VMEMMAP if SPARSEMEM_VMEMMAP is used.  By this, vmemmap
can be readable via /proc/kcore

Because it's not vmalloc area, vread/vwrite cannot be used.  But the range
is static against the memory layout, this patch handles vmemmap area by
the same scheme with physical memory.

This patch assumes SPARSEMEM_VMEMMAP range is not in VMALLOC range.  It's
correct now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c         |   52 ++++++++++++++++++++++++++++++++++++--
 include/linux/proc_fs.h |    1 
 2 files changed, 51 insertions(+), 2 deletions(-)

diff -puN fs/proc/kcore.c~kcore-register-vmemmap-range fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-register-vmemmap-range
+++ a/fs/proc/kcore.c
@@ -103,7 +103,7 @@ static void free_kclist_ents(struct list
 	}
 }
 /*
- * Replace all KCORE_RAM information with passed list.
+ * Replace all KCORE_RAM/KCORE_VMEMMAP information with passed list.
  */
 static void __kcore_update_ram(struct list_head *list)
 {
@@ -113,7 +113,8 @@ static void __kcore_update_ram(struct li
 	write_lock(&kclist_lock);
 	if (kcore_need_update) {
 		list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
-			if (pos->type == KCORE_RAM)
+			if (pos->type == KCORE_RAM
+				|| pos->type == KCORE_VMEMMAP)
 				list_move(&pos->list, &garbage);
 		}
 		list_splice_tail(list, &kclist_head);
@@ -151,6 +152,47 @@ static int kcore_update_ram(void)
 
 #else /* !CONFIG_HIGHMEM */
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+/* calculate vmemmap's address from given system ram pfn and register it */
+int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+{
+	unsigned long pfn = __pa(ent->addr) >> PAGE_SHIFT;
+	unsigned long nr_pages = ent->size >> PAGE_SHIFT;
+	unsigned long start, end;
+	struct kcore_list *vmm, *tmp;
+
+
+	start = ((unsigned long)pfn_to_page(pfn)) & PAGE_MASK;
+	end = ((unsigned long)pfn_to_page(pfn + nr_pages)) - 1;
+	end = ALIGN(end, PAGE_SIZE);
+	/* overlap check (because we have to align page */
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->type != KCORE_VMEMMAP)
+			continue;
+		if (start < tmp->addr + tmp->size)
+			if (end > tmp->addr)
+				end = tmp->addr;
+	}
+	if (start < end) {
+		vmm = kmalloc(sizeof(*vmm), GFP_KERNEL);
+		if (!vmm)
+			return 0;
+		vmm->addr = start;
+		vmm->size = end - start;
+		vmm->type = KCORE_VMEMMAP;
+		list_add_tail(&vmm->list, head);
+	}
+	return 1;
+
+}
+#else
+int get_sparsemem_vmemamp_info(struct kcore_list *ent, struct list_head *head)
+{
+	return 1;
+}
+
+#endif
+
 static int
 kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
 {
@@ -181,6 +223,12 @@ kclist_add_private(unsigned long pfn, un
 
 	ent->type = KCORE_RAM;
 	list_add_tail(&ent->list, head);
+
+	if (!get_sparsemem_vmemmap_info(ent, head)) {
+		list_del(&ent->list);
+		goto free_out;
+	}
+
 	return 0;
 free_out:
 	kfree(ent);
diff -puN include/linux/proc_fs.h~kcore-register-vmemmap-range include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~kcore-register-vmemmap-range
+++ a/include/linux/proc_fs.h
@@ -82,6 +82,7 @@ enum kcore_type {
 	KCORE_TEXT,
 	KCORE_VMALLOC,
 	KCORE_RAM,
+	KCORE_VMEMMAP,
 	KCORE_OTHER,
 };
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-do-batched-scans-for-mem_cgroup.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
kcore-use-registerd-physmem-information.patch
kcore-register-vmemmap-range.patch
kcore-register-module-area-in-generic-way.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

