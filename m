From: akpm@linux-foundation.org
Subject: + oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch added to -mm tree
Date: Wed, 28 Oct 2009 22:40:56 -0700
Message-ID: <200910290540.n9T5euV8011236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZJ2FlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Oct 2009 01:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     oom_kill: use rss value instead of vm size for badness
has been added to the -mm tree.  Its filename is
     oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch

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

mm-dont-call-pte_unmap-against-an-improper-pte.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
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
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch

