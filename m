From: akpm@linux-foundation.org
Subject: +
 mm-thp-grab-the-lock-before-manipulation-defer-list.patch added to -mm tree
Date: Thu, 09 Jan 2020 11:49:12 -0800
Message-ID: <20200109194912.DlvZQGDBD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgAITtO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 14:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, rientjes@google.com, stable@vger.kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: thp: grab the lock before manipulation defer list
has been added to the -mm tree.  Its filename is
     mm-thp-grab-the-lock-before-manipulation-defer-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-grab-the-lock-before-manipulation-defer-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-grab-the-lock-before-manipulation-defer-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm: thp: grab the lock before manipulation defer list

As in all the other places, we grab the lock before manipulating the defer
list.  Current implementation may face a race condition.

For example, the potential race would be:

    CPU1                      CPU2
    mem_cgroup_move_account   split_huge_page_to_list
      !list_empty
                                lock
                                !list_empty
                                list_del
                                unlock
      lock
      # !list_empty might not hold anymore
      list_del_init
      unlock

When this sequence happens, the list_del_init() in
mem_cgroup_move_account() would crash if CONFIG_DEBUG_LIST since the page
is already been removed by list_del in split_huge_page_to_list().

Link: http://lkml.kernel.org/r/20200109143054.13203-1-richardw.yang@linux.intel.com
Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4+]
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

mm-thp-grab-the-lock-before-manipulation-defer-list.patch
mm-remove-dead-code-totalram_pages_set.patch
