From: akpm@linux-foundation.org
Subject: [patch 063/131] mm: use pagevec_lookup_range_tag() in
 __filemap_fdatawait_range()
Date: Wed, 15 Nov 2017 17:35:05 -0800
Message-ID: <20171116013505.qE7G_JyOJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932317AbdKPBfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: mm: use pagevec_lookup_range_tag() in __filemap_fdatawait_range()

Use pagevec_lookup_range_tag() in __filemap_fdatawait_range() as it is
interested only in pages from given range.  Remove unnecessary code
resulting from this.

Link: http://lkml.kernel.org/r/20171009151359.31984-11-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/filemap.c~mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range mm/filemap.c
--- a/mm/filemap.c~mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range
+++ a/mm/filemap.c
@@ -420,19 +420,17 @@ static void __filemap_fdatawait_range(st
 		return;
 
 	pagevec_init(&pvec, 0);
-	while ((index <= end) &&
-			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			PAGECACHE_TAG_WRITEBACK,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
+	while (index <= end) {
 		unsigned i;
 
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
+				end, PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE);
+		if (!nr_pages)
+			break;
+
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/* until radix tree lookup accepts end_index */
-			if (page->index > end)
-				continue;
