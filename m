Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172DF21B196
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755644761; cv=none; b=OUoS82DxKO65+OTrvEvzyJqf5nshJRFuPjpl41hw1oaHgChBc8VsHWKY89f9cRVRGIvh3ZUixNsg1wYkcUGz0M4MT0sMI+SXlGKh7SCKf4XBqv102gACn4cKvsH5bbiiKmLWUxSOw0P5rdl5rQ36NN5cKwITC90Q77r0TbwYJJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755644761; c=relaxed/simple;
	bh=xHbXpY28hIBX0Qt+MzJPKIr1NhQm4Hp08o1MKuzI2o8=;
	h=Date:To:From:Subject:Message-Id; b=LvKWC1HCZwWBuVjZ2x0JIEnnm25koZ3wq95JX7/pj8P1g0mE+j4PWpXkDVgHGPGVJ031eZFxFgjt7Ib1yNEdZLp1PDOUaZKT+WqSgJgBeTRCb1lOF+q6OcVIcKq/MqLSEPYYA7C0yeYLa8HnrUDpEtXvpQAJDuaTY9vGSbhMhec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQg/9lwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQg/9lwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A378C4CEF1;
	Tue, 19 Aug 2025 23:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755644760;
	bh=xHbXpY28hIBX0Qt+MzJPKIr1NhQm4Hp08o1MKuzI2o8=;
	h=Date:To:From:Subject:From;
	b=eQg/9lwjFyq9BFt8Pb3qD8G9/Om5q5E4elh2q1ANEDQhv5iMuHvfJmpPgjBajegyx
	 +ViTH4+CSNyBGg3/slZCTqyzoyMqUZofuF4aQcV04pm4vl1yUFhktJGcP7CZIE3qNG
	 YYPEl6zVCx5kQ8Av0HbfAVNoJrIY5mk4m7mhAvMc=
Date: Tue, 19 Aug 2025 16:05:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kent.overstreet@linux.dev,david@redhat.com,almaz.alexandrovich@paragon-software.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-write_cache_pages.patch added to mm-new branch
Message-Id: <20250819230600.7A378C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove write_cache_pages
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-write_cache_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove write_cache_pages
Date: Mon, 18 Aug 2025 08:10:10 +0200

No users left.

Link: https://lkml.kernel.org/r/20250818061017.1526853-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 ------
 mm/page-writeback.c       |   30 ------------------------------
 2 files changed, 36 deletions(-)

--- a/include/linux/writeback.h~mm-remove-write_cache_pages
+++ a/include/linux/writeback.h
@@ -360,12 +360,6 @@ bool wb_over_bg_thresh(struct bdi_writeb
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
 
-typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
-				void *data);
-
-int write_cache_pages(struct address_space *mapping,
-		      struct writeback_control *wbc, writepage_t writepage,
-		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
--- a/mm/page-writeback.c~mm-remove-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2590,36 +2590,6 @@ done:
 }
 EXPORT_SYMBOL_GPL(writeback_iter);
 
-/**
- * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- * @writepage: function called for each page
- * @data: data passed to writepage function
- *
- * Return: %0 on success, negative error code otherwise
- *
- * Note: please use writeback_iter() instead.
- */
-int write_cache_pages(struct address_space *mapping,
-		      struct writeback_control *wbc, writepage_t writepage,
-		      void *data)
-{
-	struct folio *folio = NULL;
-	int error;
-
-	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
-		error = writepage(folio, wbc, data);
-		if (error == AOP_WRITEPAGE_ACTIVATE) {
-			folio_unlock(folio);
-			error = 0;
-		}
-	}
-
-	return error;
-}
-EXPORT_SYMBOL(write_cache_pages);
-
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
_

Patches currently in -mm which might be from hch@lst.de are

mempool-rename-struct-mempool_s-to-struct-mempool.patch
ntfs3-stop-using-write_cache_pages.patch
bcachefs-stop-using-write_cache_pages.patch
mm-remove-write_cache_pages.patch

