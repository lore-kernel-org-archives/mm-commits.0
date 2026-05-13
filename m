Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CDE3EDE72
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638571; cv=none; b=gNY0+8NjgzywdwWnxe++xwZm05poSpA6F3MgjVXlZ4I9YkDjph0t1A7rLwfDZWVpFO/J7kH8tFN+fN5mX84SBKQ4ZSVM+qavqZ4qrlYQr9pzUE+HRyhnbSMs+0NyyrlsYDdNESVCbCJBZHGHA6GFftVdqRA0cD6UyXTWvz7TqhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638571; c=relaxed/simple;
	bh=bSDaBs+FEi3owZnm8YgOeV0Q4q5yotGfEs7NhHIAbVU=;
	h=Date:To:From:Subject:Message-Id; b=oD1ysQ1vWCxwBKTNkyfh/WJxgqtaNIEvNFkw4vk32YnLPLx+J787o7u9TY/IHlkrWXnHEEVSj9S3Sj+Q937SluPDtj2v0LYAaBUvxeLBkH14Zn74fDPgWdgjrV5JSyenITPBKqVD7CHEXonJkdAY5LyRpeX/VRCT06B0AqLRcFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdeIcl/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdeIcl/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D36AC2BCB0;
	Wed, 13 May 2026 02:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638570;
	bh=bSDaBs+FEi3owZnm8YgOeV0Q4q5yotGfEs7NhHIAbVU=;
	h=Date:To:From:Subject:From;
	b=sdeIcl/umEpb6yTY9ZLr4gjQpJIt5w/1I0PSS84td2PeIriowuQt6JyfGP9WqIq2z
	 QCQwsNY9H5RE3ZzTXrJXGtKeZUVRP+VywT9YvKnYebww/k/h0wowE3rvflpCvxTJ5D
	 m0QUs5qEmK3XH7gKXyCR5gczyJEPguO2K3ffthQ4=
Date: Tue, 12 May 2026 19:16:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-add-kerneldoc-for-read_pages.patch added to mm-new branch
Message-Id: <20260513021610.6D36AC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: add kerneldoc for read_pages
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-add-kerneldoc-for-read_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-add-kerneldoc-for-read_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Frederick Mayle <fmayle@google.com>
Subject: mm/readahead: add kerneldoc for read_pages
Date: Tue, 12 May 2026 13:31:35 -0700

Patch series "mm: document read_pages and simplify usage".

Add a kerneldoc for read_pages() to formalize an invariant and then use
it to simplify the callers in page_cache_ra_unbounded().


This patch (of 2):

Formalize one of the invariants provided by the current implementation so
that callers can depend on it, as discussed in [1].

Link: https://lore.kernel.org/all/20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org/ [1]
Link: https://lore.kernel.org/20260512203154.754075-2-fmayle@google.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/readahead.c~mm-readahead-add-kerneldoc-for-read_pages
+++ a/mm/readahead.c
@@ -146,6 +146,17 @@ file_ra_state_init(struct file_ra_state
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
+/**
+ * read_pages() - Start IO for a contiguous range of allocated folios in the
+ *                page cache.
+ * @rac: Readahead control.
+ *
+ * When read_pages() returns, it is guaranteed that all of the folios will have
+ * been processed or removed so that ``readahead_count(rac) == 0``. However,
+ * that does not imply that ``readahead_index(rac)`` will be updated to point
+ * to the end of the originally requested range because, for example, the
+ * filesystem may expand the range upwards.
+ */
 static void read_pages(struct readahead_control *rac)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
_

Patches currently in -mm which might be from fmayle@google.com are

mm-limit-filemap_fault-readahead-to-vma-boundaries.patch
mm-readahead-add-kerneldoc-for-read_pages.patch
mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch

