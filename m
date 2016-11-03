From: akpm@linux-foundation.org
Subject: + z3fold-extend-compaction-function.patch added to -mm tree
Date: Thu, 03 Nov 2016 14:16:20 -0700
Message-ID: <581ba924.HqoUXvfFDhrhT5bH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759608AbcKCVQV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 17:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: extend compaction function
has been added to the -mm tree.  Its filename is
     z3fold-extend-compaction-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-extend-compaction-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-extend-compaction-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: extend compaction function

z3fold_compact_page() currently only handles the situation where there's a
single middle chunk within the z3fold page.  However it may be worth it to
move middle chunk closer to either first or last chunk, whichever is
there, if the gap between them is big enough.

This patch adds the relevant code, using BIG_CHUNK_GAP define as a
threshold for middle chunk to be worth moving.

Link: http://lkml.kernel.org/r/20161103220428.984a8d09d0c9569e6bc6b8cc@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   60 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 13 deletions(-)

diff -puN mm/z3fold.c~z3fold-extend-compaction-function mm/z3fold.c
--- a/mm/z3fold.c~z3fold-extend-compaction-function
+++ a/mm/z3fold.c
@@ -254,26 +254,60 @@ static void z3fold_destroy_pool(struct z
 	kfree(pool);
 }
 
+static inline void *mchunk_memmove(struct z3fold_header *zhdr,
+				unsigned short dst_chunk)
+{
+	void *beg = zhdr;
+	return memmove(beg + (dst_chunk << CHUNK_SHIFT),
+		       beg + (zhdr->start_middle << CHUNK_SHIFT),
+		       zhdr->middle_chunks << CHUNK_SHIFT);
+}
+
+#define BIG_CHUNK_GAP	3
 /* Has to be called with lock held */
 static int z3fold_compact_page(struct z3fold_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
-	void *beg = zhdr;
+	int ret = 0;
+
+	if (test_bit(MIDDLE_CHUNK_MAPPED, &page->private))
+		goto out;
 
+	if (zhdr->middle_chunks != 0) {
+		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+			mchunk_memmove(zhdr, 1); /* move to the beginning */
+			zhdr->first_chunks = zhdr->middle_chunks;
+			zhdr->middle_chunks = 0;
+			zhdr->start_middle = 0;
+			zhdr->first_num++;
+			ret = 1;
+			goto out;
+		}
 
-	if (!test_bit(MIDDLE_CHUNK_MAPPED, &page->private) &&
-	    zhdr->middle_chunks != 0 &&
-	    zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-		memmove(beg + ZHDR_SIZE_ALIGNED,
-			beg + (zhdr->start_middle << CHUNK_SHIFT),
-			zhdr->middle_chunks << CHUNK_SHIFT);
-		zhdr->first_chunks = zhdr->middle_chunks;
-		zhdr->middle_chunks = 0;
-		zhdr->start_middle = 0;
-		zhdr->first_num++;
-		return 1;
+		/*
+		 * moving data is expensive, so let's only do that if
+		 * there's substantial gain (at least BIG_CHUNK_GAP chunks)
+		 */
+		if (zhdr->first_chunks != 0 && zhdr->last_chunks == 0 &&
+		    zhdr->start_middle > zhdr->first_chunks + BIG_CHUNK_GAP) {
+			mchunk_memmove(zhdr, zhdr->first_chunks + 1);
+			zhdr->start_middle = zhdr->first_chunks + 1;
+			ret = 1;
+			goto out;
+		}
+		if (zhdr->last_chunks != 0 && zhdr->first_chunks == 0 &&
+		    zhdr->middle_chunks + zhdr->last_chunks <=
+		    NCHUNKS - zhdr->start_middle - BIG_CHUNK_GAP) {
+			unsigned short new_start = NCHUNKS - zhdr->last_chunks -
+				zhdr->middle_chunks;
+			mchunk_memmove(zhdr, new_start);
+			zhdr->start_middle = new_start;
+			ret = 1;
+			goto out;
+		}
 	}
-	return 0;
+out:
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-make-pages_nr-atomic.patch
z3fold-extend-compaction-function.patch

