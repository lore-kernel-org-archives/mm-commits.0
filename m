From: akpm@linux-foundation.org
Subject: [merged]
 list_lru-dont-call-list_lru_from_kmem-if-the-list_head-is-empty.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:20 -0700
Message-ID: <55f08e30.NzB3YTWKygf/ucre%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIITxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, jeff.layton@primarydata.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru: don't call list_lru_from_kmem if the list_head is empty
has been removed from the -mm tree.  Its filename was
     list_lru-dont-call-list_lru_from_kmem-if-the-list_head-is-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@poochiereds.net>
Subject: list_lru: don't call list_lru_from_kmem if the list_head is empty

If the list_head is empty then we'll have called list_lru_from_kmem for
nothing.  Move that call inside of the list_empty if block.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/list_lru.c~list_lru-dont-call-list_lru_from_kmem-if-the-list_head-is-empty mm/list_lru.c
--- a/mm/list_lru.c~list_lru-dont-call-list_lru_from_kmem-if-the-list_head-is-empty
+++ a/mm/list_lru.c
@@ -99,8 +99,8 @@ bool list_lru_add(struct list_lru *lru,
 	struct list_lru_one *l;
 
 	spin_lock(&nlru->lock);
-	l = list_lru_from_kmem(nlru, item);
 	if (list_empty(item)) {
+		l = list_lru_from_kmem(nlru, item);
 		list_add_tail(item, &l->list);
 		l->nr_items++;
 		spin_unlock(&nlru->lock);
@@ -118,8 +118,8 @@ bool list_lru_del(struct list_lru *lru,
 	struct list_lru_one *l;
 
 	spin_lock(&nlru->lock);
-	l = list_lru_from_kmem(nlru, item);
 	if (!list_empty(item)) {
+		l = list_lru_from_kmem(nlru, item);
 		list_del_init(item);
 		l->nr_items--;
 		spin_unlock(&nlru->lock);
_

Patches currently in -mm which might be from jlayton@poochiereds.net are


