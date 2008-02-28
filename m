From: akpm@linux-foundation.org
Subject: + memcg-css_put-after-remove_list.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:52 -0800
Message-ID: <200802280352.m1S3qq2I014235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbYB1Dxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: css_put after remove_list
has been added to the -mm tree.  Its filename is
     memcg-css_put-after-remove_list.patch

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
Subject: memcg: css_put after remove_list
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_uncharge_page does css_put on the mem_cgroup before uncharging from
it, and before removing page_cgroup from one of its lru lists: isn't there a
danger that struct mem_cgroup memory could be freed and reused before
completing that, so corrupting something?  Never seen it, and for all I know
there may be other constraints which make it impossible; but let's be
defensive and reverse the ordering there.

mem_cgroup_force_empty_list is safe because there's an extra css_get around
all its works; but even so, change its ordering the same way round, to help
get in the habit of doing it like this.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-css_put-after-remove_list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-css_put-after-remove_list
+++ a/mm/memcontrol.c
@@ -665,15 +665,15 @@ void mem_cgroup_uncharge_page(struct pag
 		page_assign_page_cgroup(page, NULL);
 		unlock_page_cgroup(page);
 
-		mem = pc->mem_cgroup;
-		css_put(&mem->css);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
 		__mem_cgroup_remove_list(pc);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+		mem = pc->mem_cgroup;
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		css_put(&mem->css);
+
 		kfree(pc);
 		return;
 	}
@@ -774,9 +774,9 @@ retry:
 		if (page_get_page_cgroup(page) == pc) {
 			page_assign_page_cgroup(page, NULL);
 			unlock_page_cgroup(page);
-			css_put(&mem->css);
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			__mem_cgroup_remove_list(pc);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			css_put(&mem->css);
 			kfree(pc);
 		} else {
 			/* racing uncharge: let page go then retry */
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
