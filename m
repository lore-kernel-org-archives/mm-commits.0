From: akpm@linux-foundation.org
Subject: - memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:25:22 -0700
Message-ID: <200807250025.m6P0PM6e014009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbYGYAZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@val


The patch titled
     From: Hugh Dickins <hugh@veritas.com>
has been removed from the -mm tree.  Its filename was
     memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch

This patch was dropped because it was folded into memcg-helper-function-for-relcaim-from-shmem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Hugh Dickins <hugh@veritas.com>


No big deal, but since mem_cgroup_shrink_usage doesn't require a page to
operate upon, page_cache_release the swappage before calling it, so it's
not pinned across the reclaim.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner mm/shmem.c
--- a/mm/shmem.c~memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner
+++ a/mm/shmem.c
@@ -1315,16 +1315,14 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
+			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
 				error = mem_cgroup_shrink_usage(current->mm,
-					gfp & ~__GFP_HIGHMEM);
-				if (error) {
-					page_cache_release(swappage);
+								gfp);
+				if (error)
 					goto failed;
-				}
 			}
-			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

