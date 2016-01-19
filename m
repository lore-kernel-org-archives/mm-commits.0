From: akpm@linux-foundation.org
Subject: [merged]
 mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:00:36 -0800
Message-ID: <569e95e4.8vPjRZBCa88fbmIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbcASUAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud.c: use list_last_entry() instead of list_tail_entry()
has been removed from the -mm tree.  Its filename was
     mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/zbud.c: use list_last_entry() instead of list_tail_entry()

list_last_entry*( has been defined in list.h, so replace list_tail_entry()
with it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/zbud.c~mm-zbud-use-list_last_entry-instead-of-list_tail_entry mm/zbud.c
--- a/mm/zbud.c~mm-zbud-use-list_last_entry-instead-of-list_tail_entry
+++ a/mm/zbud.c
@@ -463,9 +463,6 @@ void zbud_free(struct zbud_pool *pool, u
 	spin_unlock(&pool->lock);
 }
 
-#define list_tail_entry(ptr, type, member) \
-	list_entry((ptr)->prev, type, member)
