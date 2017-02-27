From: akpm@linux-foundation.org
Subject: [merged] z3fold-extend-compaction-function.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:25:38 -0800
Message-ID: <58b48b42.jOM7Wjlspk6uf+zV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdB1Aky (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 19:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: extend compaction function
has been removed from the -mm tree.  Its filename was
     z3fold-extend-compaction-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: extend compaction function

z3fold_compact_page() currently only handles the situation when there's a
single middle chunk within the z3fold page.  However it may be worth it to
move middle chunk closer to either first or last chunk, whichever is
there, if the gap between them is big enough.

This patch adds the relevant code, using BIG_CHUNK_GAP define as a
threshold for middle chunk to be worth moving.

Link: http://lkml.kernel.org/r/20170131214334.c4f3eac9a477af0fa9a22c46@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN mm/z3fold.c~z3fold-extend-compaction-function mm/z3fold.c
--- a/mm/z3fold.c~z3fold-extend-compaction-function
+++ a/mm/z3fold.c
@@ -268,6 +268,7 @@ static inline void *mchunk_memmove(struc
 		       zhdr->middle_chunks << CHUNK_SHIFT);
 }
 
+#define BIG_CHUNK_GAP	3
 /* Has to be called with lock held */
 static int z3fold_compact_page(struct z3fold_header *zhdr)
 {
@@ -286,8 +287,31 @@ static int z3fold_compact_page(struct z3
 		zhdr->middle_chunks = 0;
 		zhdr->start_middle = 0;
 		zhdr->first_num++;
+		return 1;
 	}
-	return 1;
+
+	/*
+	 * moving data is expensive, so let's only do that if
+	 * there's substantial gain (at least BIG_CHUNK_GAP chunks)
+	 */
+	if (zhdr->first_chunks != 0 && zhdr->last_chunks == 0 &&
+	    zhdr->start_middle - (zhdr->first_chunks + ZHDR_CHUNKS) >=
+			BIG_CHUNK_GAP) {
+		mchunk_memmove(zhdr, zhdr->first_chunks + ZHDR_CHUNKS);
+		zhdr->start_middle = zhdr->first_chunks + ZHDR_CHUNKS;
+		return 1;
+	} else if (zhdr->last_chunks != 0 && zhdr->first_chunks == 0 &&
+		   TOTAL_CHUNKS - (zhdr->last_chunks + zhdr->start_middle
+					+ zhdr->middle_chunks) >=
+			BIG_CHUNK_GAP) {
+		unsigned short new_start = TOTAL_CHUNKS - zhdr->last_chunks -
+			zhdr->middle_chunks;
+		mchunk_memmove(zhdr, new_start);
+		zhdr->start_middle = new_start;
+		return 1;
+	}
+
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from vitalywool@gmail.com are


