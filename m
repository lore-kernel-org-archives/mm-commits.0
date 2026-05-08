Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CEA3CFF40
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264263; cv=none; b=lJZfWHJm8ttMYBoiY/zxqvBPWynzVzN0/+Zxjj45JtH7fwmTe2wrUNCfLwLr1IlUTNCFEul/y4qFBy9iJzdIL6vtesmPfgjcx84d1+rSlx0BTgF+b8FMKyOe/1eQ/TehnfDNPLX+Inxw9dnAQ/BU2fgiPEML5aF170y87v4a/cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264263; c=relaxed/simple;
	bh=G6qDNhf3uVPIouix++FH4tFZa8QDMen+vQstv16Hv+k=;
	h=Date:To:From:Subject:Message-Id; b=Z+pZO8jsMK7vRn4Lgcoh+fxM9RIZuG1XoYJpwxgjnha0n1p/5DQkejQfgZh0wMpURfmmuOkf+L33g7ULTywTHGELhLHLnJT/j9ziKTlJ5V+cpwAkK1+e6NaXdCsnZ1HafQFShrMstr4P3iUViKlVL8TR4Ts6My5o8LpLVo0dpHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+Vmst3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+Vmst3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC37C2BCB0;
	Fri,  8 May 2026 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778264261;
	bh=G6qDNhf3uVPIouix++FH4tFZa8QDMen+vQstv16Hv+k=;
	h=Date:To:From:Subject:From;
	b=f+Vmst3BIpRGtNfkFLZY2hZx0/TFkna8UEBMmfb+TxVXXlzo+i8tP3ykGkfOnqa/I
	 hiHKOYv0Svk0FXZqNAoDpAc3NkB/hW8XgCdPCXKQG8Tj3mx9MNZSqiTCXTMtJZYc8E
	 d5Bgplakv6fd3eBUq5tCipVXHgF+AcaWYtjbKoCM=
Date: Fri, 08 May 2026 11:17:41 -0700
To: mm-commits@vger.kernel.org,pchelkin@ispras.ru,hch@lst.de,axboe@kernel.dk,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch added to mm-nonmm-unstable branch
Message-Id: <20260508181741.ABC37C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: free pagelist on error in iov_iter_extract_pages()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-export-symbols-needed-for-riscv32-efi-stub.patch

