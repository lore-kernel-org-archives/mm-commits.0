From: akpm@linux-foundation.org
Subject: + mm-memcontrol-clarify-the-uncharge_list-loop.patch added to -mm tree
Date: Thu, 10 Mar 2016 13:30:46 -0800
Message-ID: <56e1e786.F+aJa9RiNiUY4YUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbcCJVar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 16:30:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clarify the uncharge_list() loop
has been added to the -mm tree.  Its filename is
     mm-memcontrol-clarify-the-uncharge_list-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-clarify-the-uncharge_list-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-clarify-the-uncharge_list-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clarify the uncharge_list() loop

uncharge_list() does an unusual list walk because the function can take
regular lists with dedicated list_heads as well as singleton lists where a
single page is passed via the page->lru list node.

This can sometimes lead to confusion as well as suggestions to replace the
loop with a list_for_each_entry(), which wouldn't work.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-clarify-the-uncharge_list-loop mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clarify-the-uncharge_list-loop
+++ a/mm/memcontrol.c
@@ -5420,6 +5420,10 @@ static void uncharge_list(struct list_he
 	struct list_head *next;
 	struct page *page;
 
+	/*
+	 * Note that the list can be a single page->lru; hence the
+	 * do-while loop instead of a simple list_for_each_entry().
+	 */
 	next = page_list->next;
 	do {
 		unsigned int nr_pages = 1;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

