Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C641802E
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628301; cv=none; b=ID94dCVRmMI7RggXdLD1OLlElvScSgmmitkRHQjlBexsuvTaZOx14uUMJFkJeXnXXEtGrMAfnnrkKry40kVGQPlBSKFjBIySWF6akO2N5Qjnzd68sypOrWt6KjZgPj4Y7oSph6+BDrLqqZUaVaVlYsHCU0Vg4CkgC1GcAy65AJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628301; c=relaxed/simple;
	bh=0uYnNVJ9vZ/kBTDjuh0Q4By33ahUYS45HF1iOrChhC0=;
	h=Date:To:From:Subject:Message-Id; b=F4AuQU+l8sY2f0LYMC4AAdefydrAtAbC75nubsG080XTkITqARwYkUjBb2GdWtd559PI+wWMEZ4rp/+Zv3I9cTYx9N1qeBHjSZXk/o1GCVlsN9pBkQMRefmeiHgWfNCjbsMXplG06iq5BHqQ14mSgKIEMhY7cFhnTk3BfdB7HQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PfwFcNws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PfwFcNws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B03C32781;
	Sat, 29 Jun 2024 02:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628300;
	bh=0uYnNVJ9vZ/kBTDjuh0Q4By33ahUYS45HF1iOrChhC0=;
	h=Date:To:From:Subject:From;
	b=PfwFcNws6huJzcCQhivqTCq2KIHEd0zUCd62+LruDELixxlgD2z/wVUYj9RwWhFAv
	 50zpZmVABNKHUlI6Up9omidDzwYLTU1ZdRShrKiThJkPs35SBVe2awuYUSEbuxiGCu
	 oWjyN4DZSXOGrdREj2wSiTrWXRKXfkMhvmwJHnGo=
Date: Fri, 28 Jun 2024 19:31:40 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-drop-dead-code-in-ondemand_readahead.patch removed from -mm tree
Message-Id: <20240629023140.D6B03C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: drop dead code in ondemand_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-drop-dead-code-in-ondemand_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop dead code in ondemand_readahead()
Date: Tue, 25 Jun 2024 12:18:57 +0200

ondemand_readahead() scales up the readahead window if the current read
would hit the readahead mark placed by itself.  However the condition is
mostly dead code because:

a) In case of async readahead we always increase ra->start so ra->start
   == index is never true.

b) In case of sync readahead we either go through
   try_context_readahead() in which case ra->async_size == 1 < ra->size or
   we go through initial_readahead where ra->async_size == ra->size iff
   ra->size == max_pages.

So the only practical effect is reducing async_size for large initial
reads.  Make the code more obvious.

Link: https://lkml.kernel.org/r/20240625101909.12234-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/mm/readahead.c~readahead-drop-dead-code-in-ondemand_readahead
+++ a/mm/readahead.c
@@ -549,7 +549,6 @@ static void ondemand_readahead(struct re
 	struct backing_dev_info *bdi = inode_to_bdi(ractl->mapping->host);
 	struct file_ra_state *ra = ractl->ra;
 	unsigned long max_pages = ra->ra_pages;
-	unsigned long add_pages;
 	pgoff_t index = readahead_index(ractl);
 	pgoff_t expected, prev_index;
 	unsigned int order = folio ? folio_order(folio) : 0;
@@ -638,26 +637,10 @@ static void ondemand_readahead(struct re
 initial_readahead:
 	ra->start = index;
 	ra->size = get_init_ra_size(req_size, max_pages);
-	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
+	ra->async_size = ra->size > req_size ? ra->size - req_size :
+					       ra->size >> 1;
 
 readit:
-	/*
-	 * Will this read hit the readahead marker made by itself?
-	 * If so, trigger the readahead marker hit now, and merge
-	 * the resulted next readahead window into the current one.
-	 * Take care of maximum IO pages as above.
-	 */
-	if (index == ra->start && ra->size == ra->async_size) {
-		add_pages = get_next_ra_size(ra, max_pages);
-		if (ra->size + add_pages <= max_pages) {
-			ra->async_size = add_pages;
-			ra->size += add_pages;
-		} else {
-			ra->size = max_pages;
-			ra->async_size = max_pages >> 1;
-		}
-	}
-
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra, order);
 }
_

Patches currently in -mm which might be from jack@suse.cz are


