From: akpm@linux-foundation.org
Subject: +
 mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
 added to -mm tree
Date: Sat, 18 Jan 2020 14:56:05 -0800
Message-ID: <20200118225605.Nvg0D%akpm__33879.5763252833$1579388169$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgARW4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Jan 2020 17:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, vdavydov.dev@gmail.com, stable@vger.kernel.org, rientjes@google.com, mhocko@suse.com, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm: thp: don't need care deferred split queue in memcg charge move path
has been added to the -mm tree.  Its filename is
     mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch

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
Subject: mm: thp: don't need care deferred split queue in memcg charge move path

If compound is true, this means it is a PMD mapped THP. Which implies
the page is not linked to any defer list. So the first code chunk will
not be executed.

Also with this reason, it would not be proper to add this page to a
defer list. So the second code chunk is not correct.

Based on this, we should remove the defer list related code.

[yang.shi@linux.alibaba.com: better patch title]
Link: http://lkml.kernel.org/r/20200117233836.3434-1-richardw.yang@linux.intel.com
Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/mm/memcontrol.c~mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen
+++ a/mm/memcontrol.c
@@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struc
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
-	}
-#endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
@@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struc
 	/* caller should have done css_get */
 	page->mem_cgroup = to;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
-	}
-#endif
