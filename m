From: akpm@linux-foundation.org
Subject: +
 z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
 added to -mm tree
Date: Tue, 18 Oct 2016 13:50:31 -0700
Message-ID: <58068b17.xQ0YjyGyvgf6fUdX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56493 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932619AbcJRUuc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, ddstreet@ieee.org, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: limit first_num to the actual range of possible buddy indexes
has been added to the -mm tree.  Its filename is
     z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -51,7 +51,7 @@
 #define ZHDR_SIZE_ALIGNED CHUNK_SIZE
 #define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
-#define BUDDY_MASK	((1 << NCHUNKS_ORDER) - 1)
+#define BUDDY_MASK	(0x3)
 
 struct z3fold_pool;
 struct z3fold_ops {
@@ -114,7 +114,7 @@ struct z3fold_header {
 	unsigned short middle_chunks;
 	unsigned short last_chunks;
 	unsigned short start_middle;
-	unsigned short first_num:NCHUNKS_ORDER;
+	unsigned short first_num:2;
 };
 
 /*
@@ -187,7 +187,11 @@ static struct z3fold_header *handle_to_z
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

z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

