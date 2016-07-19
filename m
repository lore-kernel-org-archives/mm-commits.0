From: akpm@linux-foundation.org
Subject: [merged] kasan-quarantine-fix-bugs-on-qlist_move_cache.patch
 removed from -mm tree
Date: Tue, 19 Jul 2016 11:10:21 -0700
Message-ID: <578e6d0d.5uZEoOnR0N3kw0l3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbcGSSKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, poll.stdin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan/quarantine: fix bugs on qlist_move_cache()
has been removed from the -mm tree.  Its filename was
     kasan-quarantine-fix-bugs-on-qlist_move_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: kasan/quarantine: fix bugs on qlist_move_cache()

There are two bugs on qlist_move_cache().  One is that qlist's tail isn't
set properly.  curr->next can be NULL since it is singly linked list and
NULL value on tail is invalid if there is one item on qlist.  Another one
is that if cache is matched, qlist_put() is called and it will set
curr->next to NULL.  It would cause to stop the loop prematurely.

These problems come from complicated implementation so I'd like to
re-implement it completely.  Implementation in this patch is really
simple.  Iterate all qlist_nodes and put them to appropriate list.

Unfortunately, I got this bug sometime ago and lose oops message.  But,
the bug looks trivial and no need to attach oops.

Fixes: 55834c59098d ("mm: kasan: initial memory quarantine implementation")
Link: http://lkml.kernel.org/r/1467766348-22419-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Kuthonuzo Luruo <poll.stdin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-quarantine-fix-bugs-on-qlist_move_cache mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-quarantine-fix-bugs-on-qlist_move_cache
+++ a/mm/kasan/quarantine.c
@@ -238,30 +238,23 @@ static void qlist_move_cache(struct qlis
 				   struct qlist_head *to,
 				   struct kmem_cache *cache)
 {
-	struct qlist_node *prev = NULL, *curr;
+	struct qlist_node *curr;
 
 	if (unlikely(qlist_empty(from)))
 		return;
 
 	curr = from->head;
+	qlist_init(from);
 	while (curr) {
-		struct qlist_node *qlink = curr;
-		struct kmem_cache *obj_cache = qlink_to_cache(qlink);
+		struct qlist_node *next = curr->next;
+		struct kmem_cache *obj_cache = qlink_to_cache(curr);
 
-		if (obj_cache == cache) {
-			if (unlikely(from->head == qlink)) {
-				from->head = curr->next;
-				prev = curr;
-			} else
-				prev->next = curr->next;
-			if (unlikely(from->tail == qlink))
-				from->tail = curr->next;
-			from->bytes -= cache->size;
-			qlist_put(to, qlink, cache->size);
-		} else {
-			prev = curr;
-		}
-		curr = curr->next;
+		if (obj_cache == cache)
+			qlist_put(to, curr, obj_cache->size);
+		else
+			qlist_put(from, curr, obj_cache->size);
+
+		curr = next;
 	}
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_owner-use-stackdepot-to-store-stacktrace-v3.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch
mm-page_isolation-clean-up-confused-code.patch

