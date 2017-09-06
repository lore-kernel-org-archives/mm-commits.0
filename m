From: akpm@linux-foundation.org
Subject: [patch 053/119] ext4: use pagevec_lookup_range() in
 writeback code
Date: Wed, 06 Sep 2017 16:21:30 -0700
Message-ID: <20170906232130.RDdzJ29VS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdIFXVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, tytso@mit.edu

From: Jan Kara <jack@suse.cz>
Subject: ext4: use pagevec_lookup_range() in writeback code

Both occurences of pagevec_lookup() actually want only pages from a given
range.  Use pagevec_lookup_range() for the lookup.

Link: http://lkml.kernel.org/r/20170726114704.7626-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/ext4/inode.c~ext4-use-pagevec_lookup_range-in-writeback-code fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-use-pagevec_lookup_range-in-writeback-code
+++ a/fs/ext4/inode.c
@@ -1720,13 +1720,13 @@ static void mpage_release_unused_pages(s
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, &index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end,
+						PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			if (page->index > end)
-				break;
+
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 			if (invalidate) {
@@ -2347,15 +2347,13 @@ static int mpage_map_and_submit_buffers(
 
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &start,
-					  PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+						&start, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			bh = head = page_buffers(page);
 			do {
 				if (lblk < mpd->map.m_lblk)
_
