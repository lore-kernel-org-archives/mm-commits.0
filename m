Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FF423D7FF
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780597307; cv=none; b=Gd2C2Qyu8DN+aoc8NLzLXykx4mSijMZIj23+rC+Rn+q8F+5arzvLch3MtiB004RYRCz2Shz5XZWoCZHPq/RO6cSP5yBwTmNXqHOJDsuFA6lWeND5S3QNPjehw10Tbi6x3J4H2HS9M2rBQsev0kOUS8LzVaX3HLMXnygzhacItuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780597307; c=relaxed/simple;
	bh=3ephE5eOVifnqS1b2SZWMlBKqcgZGJL2odHaIrggVrU=;
	h=Date:To:From:Subject:Message-Id; b=DaOkjxUzufMAKh3kAZ3RoS8xU4sOcCkPpZjWD7/HTC4B/EikWj5Vwmp0d0hCzBpSb1RMBd4hWaX5gO2iA8EOv9U1pQrThhBox930fYQybRWUF9JmViTyZq139BszfzGSruJN1MMxLJ+4q4D913MlWtbdPYU6fxzCG5jL9KyPBSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPbfmmJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPbfmmJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326E01F00893;
	Thu,  4 Jun 2026 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780597306;
	bh=mzgwBPhO6wrVrES5FdR/wUJr2k356s4Nz8OD9ODW910=;
	h=Date:To:From:Subject;
	b=pPbfmmJIPRTgMvPOnTdcozq30H0ulTtHc/N9RbhCCV3pmmWnD21OuRsR5nbiJnvXD
	 oh0kCaFBuZ67+xnfiijJxh7fkF+Ia0h7n02i51rDrVyXXW7EZMKUCjHJgS9TV4bnVt
	 5ecGRmAtF80G2mj6Qp8IrQIsqwSzf0oqcZtOBD20=
Date: Thu, 04 Jun 2026 11:21:45 -0700
To: mm-commits@vger.kernel.org,pchelkin@ispras.ru,hch@lst.de,axboe@kernel.dk,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch removed from -mm tree
Message-Id: <20260604182146.326E01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: free pagelist on error in iov_iter_extract_pages()
has been removed from the -mm tree.  Its filename was
     lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: free pagelist on error in iov_iter_extract_pages()
Date: Fri, 8 May 2026 14:13:29 +0300

Since 'iov_iter_extract_pages()' may allocate new pagelist if the passed
one isn't large enough, the worst-case scenario may be:

...
struct page *stack_pages[SMALL];
struct page **pages = stack_pages;
...
if (iov_iter_extract_pages(i..., &pages, ...) <= 0) {
        /* Even in case of error, new pagelist may be allocated */
        if (pages != stack_pages)
                kvfree(pages);                                  [1]
        /* The rest of error handling and return */
}
/* Regular flow */
...
if (pages != stack_pages)
        kvfree(pages);
...
return 0;

If you're unlucky so SMALL amount of pages wasn't enough and new pagelist
was allocated, missing [1] causes the memory leak similar to one I've
recently observed and fixed for 6.12 in [2].  So adjust
'iov_iter_extract_pages()' to make such a cleanup itself rather than rely
on caller's handling on error paths, thus making [1] not needed.

[2] https://lore.kernel.org/stable/20260505094529.406783-1-dmantipov@yandex.ru/T/#u

Link: https://lore.kernel.org/20260508111329.329943-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |   54 ++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

--- a/lib/iov_iter.c~lib-free-pagelist-on-error-in-iov_iter_extract_pages
+++ a/lib/iov_iter.c
@@ -1807,7 +1807,8 @@ static ssize_t iov_iter_extract_user_pag
  *  (*) Use with ITER_DISCARD is not supported as that has no content.
  *
  * On success, the function sets *@pages to the new pagelist, if allocated, and
- * sets *offset0 to the offset into the first page.
+ * sets *offset0 to the offset into the first page. On error, new pagelist
+ * is freed if was allocated, and *@pages sets back to its original value.
  *
  * It may also return -ENOMEM and -EFAULT.
  */
@@ -1818,31 +1819,42 @@ ssize_t iov_iter_extract_pages(struct io
 			       iov_iter_extraction_t extraction_flags,
 			       size_t *offset0)
 {
+	struct page **oldpages = *pages;
+	int ret;
+
 	maxsize = min_t(size_t, min_t(size_t, maxsize, i->count), MAX_RW_COUNT);
 	if (!maxsize)
 		return 0;
 
 	if (likely(user_backed_iter(i)))
-		return iov_iter_extract_user_pages(i, pages, maxsize,
-						   maxpages, extraction_flags,
-						   offset0);
-	if (iov_iter_is_kvec(i))
-		return iov_iter_extract_kvec_pages(i, pages, maxsize,
-						   maxpages, extraction_flags,
-						   offset0);
-	if (iov_iter_is_bvec(i))
-		return iov_iter_extract_bvec_pages(i, pages, maxsize,
-						   maxpages, extraction_flags,
-						   offset0);
-	if (iov_iter_is_folioq(i))
-		return iov_iter_extract_folioq_pages(i, pages, maxsize,
-						     maxpages, extraction_flags,
-						     offset0);
-	if (iov_iter_is_xarray(i))
-		return iov_iter_extract_xarray_pages(i, pages, maxsize,
-						     maxpages, extraction_flags,
-						     offset0);
-	return -EFAULT;
+		ret = iov_iter_extract_user_pages(i, pages, maxsize,
+						  maxpages, extraction_flags,
+						  offset0);
+	else if (iov_iter_is_kvec(i))
+		ret = iov_iter_extract_kvec_pages(i, pages, maxsize,
+						  maxpages, extraction_flags,
+						  offset0);
+	else if (iov_iter_is_bvec(i))
+		ret = iov_iter_extract_bvec_pages(i, pages, maxsize,
+						  maxpages, extraction_flags,
+						  offset0);
+	else if (iov_iter_is_folioq(i))
+		ret = iov_iter_extract_folioq_pages(i, pages, maxsize,
+						    maxpages, extraction_flags,
+						    offset0);
+	else if (iov_iter_is_xarray(i))
+		ret = iov_iter_extract_xarray_pages(i, pages, maxsize,
+						    maxpages, extraction_flags,
+						    offset0);
+	else
+		ret = -EFAULT;
+
+	if (unlikely(ret) && *pages && *pages != oldpages) {
+		kvfree(*pages);
+		*pages = oldpages;
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iov_iter_extract_pages);
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-fix-buffer-head-management-in-ocfs2_read_blocks.patch

