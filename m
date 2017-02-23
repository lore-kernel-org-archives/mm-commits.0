From: akpm@linux-foundation.org
Subject: [merged]
 z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:17:45 -0800
Message-ID: <58af5179.SvcQ8Xj5fe7wze+n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBWVRq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, ddstreet@ieee.org, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: limit first_num to the actual range of possible buddy indexes
has been removed from the -mm tree.  Its filename was
     z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/z3fold.c: limit first_num to the actual range of possible buddy indexes

At present, Tying the first_num size to NCHUNKS_ORDER is confusing.  the
number of chunks is completely unrelated to the number of buddies.

The patch limits the first_num to actual range of possible buddy indexes. 
and that is more reasonable and obvious without functional change.

Link: http://lkml.kernel.org/r/1476776569-29504-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/z3fold.c~z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes mm/z3fold.c
--- a/mm/z3fold.c~z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes
+++ a/mm/z3fold.c
@@ -50,7 +50,7 @@
 #define ZHDR_SIZE_ALIGNED CHUNK_SIZE
 #define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
-#define BUDDY_MASK	((1 << NCHUNKS_ORDER) - 1)
+#define BUDDY_MASK	(0x3)
 
 struct z3fold_pool;
 struct z3fold_ops {
@@ -109,7 +109,7 @@ struct z3fold_header {
 	unsigned short middle_chunks;
 	unsigned short last_chunks;
 	unsigned short start_middle;
-	unsigned short first_num:NCHUNKS_ORDER;
+	unsigned short first_num:2;
 };
 
 /*
@@ -179,7 +179,11 @@ static struct z3fold_header *handle_to_z
 	return (struct z3fold_header *)(handle & PAGE_MASK);
 }
 
-/* Returns buddy number */
+/*
+ * (handle & BUDDY_MASK) < zhdr->first_num is possible in encode_handle
+ *  but that doesn't matter. because the masking will result in the
+ *  correct buddy number.
+ */
 static enum buddy handle_to_buddy(unsigned long handle)
 {
 	struct z3fold_header *zhdr = handle_to_z3fold_header(handle);
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-fix-a-overflow-in-test_pages_in_a_zone.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

