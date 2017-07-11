From: akpm@linux-foundation.org
Subject: [merged]
 fs-bufferc-make-bh_lru_install-more-efficient.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:22:56 -0700
Message-ID: <20170711192256.Kdi-DqBt1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, ebiggers@google.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/buffer.c: make bh_lru_install() more efficient
has been removed from the -mm tree.  Its filename was
     fs-bufferc-make-bh_lru_install-more-efficient.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/buffer.c: make bh_lru_install() more efficient

To install a buffer_head into the cpu's LRU queue, bh_lru_install() would
construct a new copy of the queue and then memcpy it over the real queue. 
But it's easily possible to do the update in-place, which is faster and
simpler.  Some work can also be skipped if the buffer_head was already in
the queue.

As a microbenchmark I timed how long it takes to run sb_getblk()
10,000,000 times alternating between BH_LRU_SIZE + 1 blocks.  Effectively,
this benchmarks looking up buffer_heads that are in the page cache but not
in the LRU:

	Before this patch: 1.758s
	After this patch: 1.653s

This patch also removes about 350 bytes of compiled code (on x86_64),
partly due to removal of the memcpy() which was being inlined+unrolled.

Link: http://lkml.kernel.org/r/20161229193445.1913-1-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-make-bh_lru_install-more-efficient fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-make-bh_lru_install-more-efficient
+++ a/fs/buffer.c
@@ -1281,44 +1281,31 @@ static inline void check_irqs_on(void)
 }
 
 /*
- * The LRU management algorithm is dopey-but-simple.  Sorry.
+ * Install a buffer_head into this cpu's LRU.  If not already in the LRU, it is
+ * inserted at the front, and the buffer_head at the back if any is evicted.
+ * Or, if already in the LRU it is moved to the front.
  */
 static void bh_lru_install(struct buffer_head *bh)
 {
-	struct buffer_head *evictee = NULL;
+	struct buffer_head *evictee = bh;
+	struct bh_lru *b;
+	int i;
 
 	check_irqs_on();
 	bh_lru_lock();
-	if (__this_cpu_read(bh_lrus.bhs[0]) != bh) {
-		struct buffer_head *bhs[BH_LRU_SIZE];
-		int in;
-		int out = 0;
 
-		get_bh(bh);
-		bhs[out++] = bh;
-		for (in = 0; in < BH_LRU_SIZE; in++) {
-			struct buffer_head *bh2 =
-				__this_cpu_read(bh_lrus.bhs[in]);
-
-			if (bh2 == bh) {
-				__brelse(bh2);
-			} else {
-				if (out >= BH_LRU_SIZE) {
-					BUG_ON(evictee != NULL);
-					evictee = bh2;
-				} else {
-					bhs[out++] = bh2;
-				}
-			}
+	b = this_cpu_ptr(&bh_lrus);
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		swap(evictee, b->bhs[i]);
+		if (evictee == bh) {
+			bh_lru_unlock();
+			return;
 		}
-		while (out < BH_LRU_SIZE)
-			bhs[out++] = NULL;
-		memcpy(this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
 	}
-	bh_lru_unlock();
 
-	if (evictee)
-		__brelse(evictee);
+	get_bh(bh);
+	bh_lru_unlock();
+	brelse(evictee);
 }
 
 /*
_

Patches currently in -mm which might be from ebiggers@google.com are


