Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEC8134D3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mysd8RL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C049C433C7;
	Fri, 29 Dec 2023 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880021;
	bh=TcVBpIr0Tw1gTXwqCt4I8qD78NEow/ChkwvOsfQnEZA=;
	h=Date:To:From:Subject:From;
	b=Mysd8RL90e/OxBSbu9dCIVSJMXsBMSCz4nLQ97AoEn/6ncEPIr0QD/s2pP3GlNKnb
	 9faHdPsP+f+hOraA7Ky3H+ms7obytNiO8muYV7vpQhnJ72/+Y+Zge531KAueOaMZ+O
	 lPhqKGSbmsZ2Q590Zu0IvSEViZkWEmXjB+POjH6k=
Date: Fri, 29 Dec 2023 12:00:20 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-convert-clean_buffers-to-take-a-folio.patch removed from -mm tree
Message-Id: <20231229200021.3C049C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: convert clean_buffers() to take a folio
has been removed from the -mm tree.  Its filename was
     fs-convert-clean_buffers-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: convert clean_buffers() to take a folio
Date: Fri, 15 Dec 2023 20:02:33 +0000

The only caller already has a folio, so pass it in and use it throughout. 
Saves two calls to compound_head().

Link: https://lkml.kernel.org/r/20231215200245.748418-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/mpage.c~fs-convert-clean_buffers-to-take-a-folio
+++ a/fs/mpage.c
@@ -430,13 +430,13 @@ struct mpage_data {
  * We have our BIO, so we can now mark the buffers clean.  Make
  * sure to only clean buffers which we know we'll be writing.
  */
-static void clean_buffers(struct page *page, unsigned first_unmapped)
+static void clean_buffers(struct folio *folio, unsigned first_unmapped)
 {
 	unsigned buffer_counter = 0;
-	struct buffer_head *bh, *head;
-	if (!page_has_buffers(page))
+	struct buffer_head *bh, *head = folio_buffers(folio);
+
+	if (!head)
 		return;
-	head = page_buffers(page);
 	bh = head;
 
 	do {
@@ -451,8 +451,8 @@ static void clean_buffers(struct page *p
 	 * read_folio would fail to serialize with the bh and it would read from
 	 * disk before we reach the platter.
 	 */
-	if (buffer_heads_over_limit && PageUptodate(page))
-		try_to_free_buffers(page_folio(page));
+	if (buffer_heads_over_limit && folio_test_uptodate(folio))
+		try_to_free_buffers(folio);
 }
 
 static int __mpage_writepage(struct folio *folio, struct writeback_control *wbc,
@@ -615,7 +615,7 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	clean_buffers(&folio->page, first_unmapped);
+	clean_buffers(folio, first_unmapped);
 
 	BUG_ON(folio_test_writeback(folio));
 	folio_start_writeback(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

