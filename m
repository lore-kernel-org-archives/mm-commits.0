From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-clarify-the-uncharge_list-loop.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:27 -0700
Message-ID: <56f0401b.6qGDDruEWu3Q3ZVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbcCUT4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clarify the uncharge_list() loop
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clarify-the-uncharge_list-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clarify the uncharge_list() loop

uncharge_list() does an unusual list walk because the function can take
regular lists with dedicated list_heads as well as singleton lists where a
single page is passed via the page->lru list node.

This can sometimes lead to confusion as well as suggestions to replace the
loop with a list_for_each_entry(), which wouldn't work.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
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


