From: akpm@linux-foundation.org
Subject: [merged]
 llists-move-llist_reverse_order-from-raid5-to-llistc.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:23 -0800
Message-ID: <52867f73.sCtYFUjQqc1dY1MH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3KOUJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: [merged] llists-move-llist_reverse_order-from-raid5-to-llistc.patch removed from -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:23 -0800


The patch titled
     Subject: llists: move llist_reverse_order from raid5 to llist.c
has been removed from the -mm tree.  Its filename was
     llists-move-llist_reverse_order-from-raid5-to-llistc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: llists: move llist_reverse_order from raid5 to llist.c

Make this useful helper available for other users.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c    |   14 --------------
 include/linux/llist.h |    2 ++
 lib/llist.c           |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 14 deletions(-)

diff -puN drivers/md/raid5.c~llists-move-llist_reverse_order-from-raid5-to-llistc drivers/md/raid5.c
--- a/drivers/md/raid5.c~llists-move-llist_reverse_order-from-raid5-to-llistc
+++ a/drivers/md/raid5.c
@@ -293,20 +293,6 @@ static void __release_stripe(struct r5co
 		do_release_stripe(conf, sh);
 }
 
-static struct llist_node *llist_reverse_order(struct llist_node *head)
-{
-	struct llist_node *new_head = NULL;
-
-	while (head) {
-		struct llist_node *tmp = head;
-		head = head->next;
-		tmp->next = new_head;
-		new_head = tmp;
-	}
-
-	return new_head;
-}
-
 /* should hold conf->device_lock already */
 static int release_stripe_list(struct r5conf *conf)
 {
diff -puN include/linux/llist.h~llists-move-llist_reverse_order-from-raid5-to-llistc include/linux/llist.h
--- a/include/linux/llist.h~llists-move-llist_reverse_order-from-raid5-to-llistc
+++ a/include/linux/llist.h
@@ -195,4 +195,6 @@ static inline struct llist_node *llist_d
 
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
+struct llist_node *llist_reverse_order(struct llist_node *head);
+
 #endif /* LLIST_H */
diff -puN lib/llist.c~llists-move-llist_reverse_order-from-raid5-to-llistc lib/llist.c
--- a/lib/llist.c~llists-move-llist_reverse_order-from-raid5-to-llistc
+++ a/lib/llist.c
@@ -81,3 +81,25 @@ struct llist_node *llist_del_first(struc
 	return entry;
 }
 EXPORT_SYMBOL_GPL(llist_del_first);
+
+/**
+ * llist_reverse_order - reverse order of a llist chain
+ * @head:	first item of the list to be reversed
+ *
+ * Reverse the oder of a chain of llist entries and return the
+ * new first entry.
+ */
+struct llist_node *llist_reverse_order(struct llist_node *head)
+{
+	struct llist_node *new_head = NULL;
+
+	while (head) {
+		struct llist_node *tmp = head;
+		head = head->next;
+		tmp->next = new_head;
+		new_head = tmp;
+	}
+
+	return new_head;
+}
+EXPORT_SYMBOL_GPL(llist_reverse_order);
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
linux-next.patch

