From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-thp-grab-the-lock-before-manipulation-defer-list.patch removed from -mm
 tree
Date: Sat, 18 Jan 2020 14:54:54 -0800
Message-ID: <20200118225454.KSxMJ%akpm__8057.04490501142$1579388098$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgARWy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Jan 2020 17:54:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, stable@vger.kernel.org, rientjes@google.com, mhocko@suse.com, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm: thp: grab the lock before manipulating defer list
has been removed from the -mm tree.  Its filename was
     mm-thp-grab-the-lock-before-manipulation-defer-list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm: thp: grab the lock before manipulating defer list

As all the other places, we grab the lock before manipulate the defer
list.  Current implementation may face a race condition.

For example, the potential race would be:

    CPU1                      CPU2
    mem_cgroup_move_account   deferred_split_huge_page
      list_empty
                                lock
                                list_empty
                                list_add_tail
                                unlock
      lock
      # list_empty might not hold anymore
      list_add_tail
      unlock

When this sequence happens, the list_add_tail() in
mem_cgroup_move_account() corrupt the list since which is already been
added to some split_queue in split_huge_page_to_list().

Besides this, David Rientjes points out the split_queue_len would be in a
wrong state, which would be a significant issue for shrinkers.

Link: http://lkml.kernel.org/r/20200109143054.13203-1-richardw.yang@linux.intel.com
Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-thp-grab-the-lock-before-manipulation-defer-list
+++ a/mm/memcontrol.c
@@ -5341,10 +5341,12 @@ static int mem_cgroup_move_account(struc
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
+		if (!list_empty(page_deferred_list(page))) {
+			list_del_init(page_deferred_list(page));
+			from->deferred_split_queue.split_queue_len--;
+		}
 		spin_unlock(&from->deferred_split_queue.split_queue_lock);
 	}
 #endif
@@ -5358,11 +5360,13 @@ static int mem_cgroup_move_account(struc
 	page->mem_cgroup = to;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
+		if (list_empty(page_deferred_list(page))) {
+			list_add_tail(page_deferred_list(page),
+				      &to->deferred_split_queue.split_queue);
+			to->deferred_split_queue.split_queue_len++;
+		}
 		spin_unlock(&to->deferred_split_queue.split_queue_lock);
 	}
 #endif
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
