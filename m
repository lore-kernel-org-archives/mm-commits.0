Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4A32207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957056; cv=none; b=cPl6L06WAWh9YuK5pD8LMMSiuKezO/pcFi+5lafAfTfQ8jCSRbjYTNX/RWiVcaFeoB38wJZd290MFhiX0SfnN9/QEh8m+B3BGvpor6EYGiYu/S8CNzIBxw+MxodH3Qm4JMo1b9htqw5GK/G3t7J03yR1Swpvu+7e9cr3pff6tlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957056; c=relaxed/simple;
	bh=iTgbutXZsrfC60RFcf9wdeFXVGJ7UFrDp2UAsbTeDJQ=;
	h=Date:To:From:Subject:Message-Id; b=MXKqDnh3ImPRuDYaq0IxHjdq8d+VKewSqyjz6YK4d5raTYEjxYuuyfz+61SnOpIW2KmvdE3WpyY4MRIpqU+mumv6dvaExzmkqrPkEp/FoVxAUr+lAbXbfpIMTRVi0mKeLJspNnLEok3VS7XVlZzojcwPukqa7eIxiqgQ4nlOdWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zaqvmQr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zaqvmQr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96C7C113CC;
	Mon,  6 May 2024 00:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957056;
	bh=iTgbutXZsrfC60RFcf9wdeFXVGJ7UFrDp2UAsbTeDJQ=;
	h=Date:To:From:Subject:From;
	b=zaqvmQr/OhZfp7K5zFhAXJg5MG0nv2ohpFdiWr6ure7SJc2nKw1UOdVAVP/whk1NJ
	 OWAl1ewEw0jWcJlPHEVGQJ+1t8tZIYdsYUtkzfx/gwqH511mptW4wFILgXje66Ey7A
	 7SqMTXGO33xjPTTv2GajKCxD5OU/BXMVfELyrCcE=
Date: Sun, 05 May 2024 17:57:35 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-improve-the-description-of-__folio_mark_dirty.patch removed from -mm tree
Message-Id: <20240506005735.E96C7C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: improve the description of __folio_mark_dirty
has been removed from the -mm tree.  Its filename was
     doc-improve-the-description-of-__folio_mark_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc: improve the description of __folio_mark_dirty
Date: Tue, 16 Apr 2024 04:17:45 +0100

Patch series "Improve buffer head documentation", v3.

Turn buffer head documentation into its own document, and make many
general improvements to the docs.  Obviously there is much more that could
be done.  Tested with make htmldocs.


This patch (of 8):

I've learned why it's safe to call __folio_mark_dirty() from
mark_buffer_dirty() without holding the folio lock, so update the
description to explain why.

Link: https://lkml.kernel.org/r/20240416031754.4076917-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240416031754.4076917-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c~doc-improve-the-description-of-__folio_mark_dirty
+++ a/mm/page-writeback.c
@@ -2705,11 +2705,15 @@ void folio_account_cleaned(struct folio
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
  *
- * The caller must hold folio_memcg_lock().  Most callers have the folio
- * locked.  A few have the folio blocked from truncation through other
- * means (eg zap_vma_pages() has it mapped and is holding the page table
- * lock).  This can also be called from mark_buffer_dirty(), which I
- * cannot prove is always protected against truncate.
+ * The caller must hold folio_memcg_lock().  It is the caller's
+ * responsibility to prevent the folio from being truncated while
+ * this function is in progress, although it may have been truncated
+ * before this function is called.  Most callers have the folio locked.
+ * A few have the folio blocked from truncation through other means (e.g.
+ * zap_vma_pages() has it mapped and is holding the page table lock).
+ * When called from mark_buffer_dirty(), the filesystem should hold a
+ * reference to the buffer_head that is being marked dirty, which causes
+ * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 			     int warn)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

