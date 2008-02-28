From: akpm@linux-foundation.org
Subject: + memcg-when-do_swaps-do_wp_page-fails.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:36 -0800
Message-ID: <200802280352.m1S3qaZt014211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYB1Dw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:52:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: when do_swap's do_wp_page fails
has been added to the -mm tree.  Its filename is
     memcg-when-do_swaps-do_wp_page-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: when do_swap's do_wp_page fails
From: Hugh Dickins <hugh@veritas.com>

Don't uncharge when do_swap_page's call to do_wp_page fails: the page which
was charged for is there in the pagetable, and will be correctly uncharged
when that area is unmapped - it was only its COWing which failed.

And while we're here, remove earlier XXX comment: yes, OR in do_wp_page's
return value (maybe VM_FAULT_WRITE) with do_swap_page's there; but if it
fails, mask out success bits, which might confuse some arches e.g.  sparc.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~memcg-when-do_swaps-do_wp_page-fails mm/memory.c
--- a/mm/memory.c~memcg-when-do_swaps-do_wp_page-fails
+++ a/mm/memory.c
@@ -2093,12 +2093,9 @@ static int do_swap_page(struct mm_struct
 	unlock_page(page);
 
 	if (write_access) {
-		/* XXX: We could OR the do_wp_page code with this one? */
-		if (do_wp_page(mm, vma, address,
-				page_table, pmd, ptl, pte) & VM_FAULT_OOM) {
-			mem_cgroup_uncharge_page(page);
-			ret = VM_FAULT_OOM;
-		}
+		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
+		if (ret & VM_FAULT_ERROR)
+			ret &= VM_FAULT_ERROR;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch
memcg-fix-oops-on-null-lru-list.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch
