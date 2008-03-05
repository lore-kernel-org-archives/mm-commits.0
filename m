From: akpm@linux-foundation.org
Subject: - memcg-page_cache_release-not-__free_page.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:12 -0800
Message-ID: <200803050745.m257jCDs021574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757839AbYCEHv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: page_cache_release not __free_page
has been removed from the -mm tree.  Its filename was
     memcg-page_cache_release-not-__free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: page_cache_release not __free_page
From: Hugh Dickins <hugh@veritas.com>

There's nothing wrong with mem_cgroup_charge failure in do_wp_page and
do_anonymous page using __free_page, but it does look odd when nearby code
uses page_cache_release: use that instead (while turning a blind eye to
ancient inconsistencies of page_cache_release versus put_page).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~memcg-page_cache_release-not-__free_page mm/memory.c
--- a/mm/memory.c~memcg-page_cache_release-not-__free_page
+++ a/mm/memory.c
@@ -1711,7 +1711,7 @@ unlock:
 	}
 	return ret;
 oom_free_new:
-	__free_page(new_page);
+	page_cache_release(new_page);
 oom:
 	if (old_page)
 		page_cache_release(old_page);
@@ -2163,7 +2163,7 @@ release:
 	page_cache_release(page);
 	goto unlock;
 oom_free_page:
-	__free_page(page);
+	page_cache_release(page);
 oom:
 	return VM_FAULT_OOM;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

