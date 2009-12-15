From: akpm@linux-foundation.org
Subject: [to-be-updated] oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch removed from -mm tree
Date: Mon, 14 Dec 2009 19:44:37 -0800
Message-ID: <200912150344.nBF3idOj030328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbZLODq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 22:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom_kill: use rss value instead of vm size for badness
has been removed from the -mm tree.  Its filename was
     oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom_kill: use rss value instead of vm size for badness
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's reported that OOM-Killer kills Gnone/KDE first.  And yes, we can
reproduce it easily.

Now, oom-killer uses mm->total_vm as its base value.  But in recent
applications, there are a big gap between VM size and RSS size.  Because

  - Applications attaches much dynamic libraries. (Gnome, KDE, etc...)
  - Applications may alloc big VM area but use small part of them.
    (Java, and multi-threaded applications has this tendency because
     of default-size of stack.)

I think using mm->total_vm as score for oom-kill is not good.  By the same
reason, overcommit memory can't work as expected.  (In other words, if we
depends on total_vm, using overcommit more positive is a good choice.)

This patch uses mm->anon_rss/file_rss as base value for calculating badness.

Following is changes to OOM score(badness) on an environment with 1.6G memory
plus memory-eater(500M & 1G).

Top 10 of badness score. (The highest one is the first candidate to be killed)
Before
badness program
91228	gnome-settings-
94210	clock-applet
103202	mixer_applet2
106563	tomboy
112947	gnome-terminal
128944	mmap              <----------- 500M malloc
129332	nautilus
215476	bash              <----------- parent of 2 mallocs.
256944	mmap              <----------- 1G malloc
423586	gnome-session

After
badness
1911	mixer_applet2
1955	clock-applet
1986	xinit
1989	gnome-session
2293	nautilus
2955	gnome-terminal
4113	tomboy
104163	mmap             <----------- 500M malloc.
168577	bash             <----------- parent of 2 mallocs
232375	mmap             <----------- 1G malloc

seems good for me.  Maybe we can tweak this patch more, but this one will
be a good one as a start point.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-use-rss-value-instead-of-vm-size-for-badness mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-use-rss-value-instead-of-vm-size-for-badness
+++ a/mm/oom_kill.c
@@ -93,7 +93,7 @@ unsigned long badness(struct task_struct
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
-	points = mm->total_vm;
+	points = get_mm_rss(mm);
 
 	/*
 	 * After this unlock we can no longer dereference local variable `mm'
@@ -117,7 +117,7 @@ unsigned long badness(struct task_struct
 	list_for_each_entry(child, &p->children, sibling) {
 		task_lock(child);
 		if (child->mm != mm && child->mm)
-			points += child->mm->total_vm/2 + 1;
+			points += get_mm_rss(child->mm)/2 + 1;
 		task_unlock(child);
 	}
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-mem-cgroup-charge-swapin-copy.patch
linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
memcg-fix-memorymemswusage_in_bytes-for-root-cgroup.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch
memcg-add-mem_cgroup_cancel_charge.patch
memcg-cleanup-mem_cgroup_move_parent.patch
memcg-remove-memcg_tasklist.patch

