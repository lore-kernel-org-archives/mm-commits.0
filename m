Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1531BA2D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739468; cv=none; b=GIR7jblrGBPBVLFpsSul8lj93Kpue9QEkmUQVJax3uZYkDsFasOidCimGob/EKaIR9URRE4AO8PR9sW72Yr3KPwjg2eT3usIvRLp42PXmPhyBBe9X++77m/O0LE7bfQdl2JcWhQM/1WKIbYZs9nhyEbs6k6BMTXf8TTv5fUlYtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739468; c=relaxed/simple;
	bh=JOUoTDx+2+896x5T24ISWMk48USJTze1pNHe63hAFrc=;
	h=Date:To:From:Subject:Message-Id; b=WuS4cW+twnJ46y+AKSXWBnTJ75BEWk3nhu7ZYCW3253heHbI+VFYZNA3VjLLVc+rFwuHLd90AUzgZhw8jpnhYsUp0+2usycRo7V//3RejcArmdcsJTkkSCY5xMND6E4ZRFDTfin3v4U3mfTi/rIXjhpYaM4r/umChEapE9PyEnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W51+n9XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W51+n9XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E8C433F1;
	Sat, 24 Feb 2024 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739467;
	bh=JOUoTDx+2+896x5T24ISWMk48USJTze1pNHe63hAFrc=;
	h=Date:To:From:Subject:From;
	b=W51+n9XOCG6JMRUzxpGhCoElo1uDVjvyqirWo0wABTTidIwerNGePQLTAxvlK1a5H
	 A+5uiBJhWrUOKCs9GB+0xYH/N/vD6mag8PenE7cB4QlgHZb3ssXB8NXjbMOqLK9P6T
	 3gIfQpqnTo+0UQxW62TmDT6FUc0rUhNUnCX/txdQ=
Date: Fri, 23 Feb 2024 17:51:07 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-use-the-folio_batch-queue-iterator.patch removed from -mm tree
Message-Id: <20240224015107.B94E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: use the folio_batch queue iterator
has been removed from the -mm tree.  Its filename was
     writeback-use-the-folio_batch-queue-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: use the folio_batch queue iterator
Date: Thu, 15 Feb 2024 07:36:46 +0100

Instead of keeping our own local iterator variable, use the one just added
to folio_batch.

Link: https://lkml.kernel.org/r/20240215063649.2164017-12-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c~writeback-use-the-folio_batch-queue-iterator
+++ a/mm/page-writeback.c
@@ -2406,13 +2406,21 @@ static pgoff_t wbc_end(struct writeback_
 	return wbc->range_end >> PAGE_SHIFT;
 }
 
-static void writeback_get_batch(struct address_space *mapping,
+static struct folio *writeback_get_folio(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
-	folio_batch_release(&wbc->fbatch);
-	cond_resched();
-	filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
-			wbc_to_tag(wbc), &wbc->fbatch);
+	struct folio *folio;
+
+	folio = folio_batch_next(&wbc->fbatch);
+	if (!folio) {
+		folio_batch_release(&wbc->fbatch);
+		cond_resched();
+		filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
+				wbc_to_tag(wbc), &wbc->fbatch);
+		folio = folio_batch_next(&wbc->fbatch);
+	}
+
+	return folio;
 }
 
 /**
@@ -2454,7 +2462,6 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct folio *folio;
 	pgoff_t end;		/* Inclusive */
-	int i = 0;
 
 	if (wbc->range_cyclic) {
 		wbc->index = mapping->writeback_index; /* prev offset */
@@ -2469,15 +2476,10 @@ int write_cache_pages(struct address_spa
 	folio_batch_init(&wbc->fbatch);
 
 	for (;;) {
-		if (i == wbc->fbatch.nr) {
-			writeback_get_batch(mapping, wbc);
-			i = 0;
-		}
-		if (wbc->fbatch.nr == 0)
+		folio = writeback_get_folio(mapping, wbc);
+		if (!folio)
 			break;
 
-		folio = wbc->fbatch.folios[i++];
-
 		folio_lock(folio);
 		if (!folio_prepare_writeback(mapping, wbc, folio)) {
 			folio_unlock(folio);
_

Patches currently in -mm which might be from willy@infradead.org are


