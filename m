Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70AB146A68
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756817; cv=none; b=GymjI+BQAoZj0hnfywxIr67V9naGt+S76d5qqo0H2cH6wEiMunVFS1KE8crAZAxHnb1ipPGUmgsd5DXbq71eY0HkZw7HyoM0EbuAdJIYLL5il7wwqWpTN2sLDklsCAokuTRduv63JGA9o3aJQB+xyrEG7TUxqfS5os69JjjVQvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756817; c=relaxed/simple;
	bh=ClsJb1uRn/EufHyfilSEmynmAOZXhVGwDOW5CyKTRzo=;
	h=Date:To:From:Subject:Message-Id; b=XB+WqmTKkehFVP9hOVN06wDuvHPeWvdOR9VI0E+qpgmwpXla7uE9dvKH9sTJd+/y/wmF3i1Dw7sC7UUtq3Uf5VXOQD9dTbVDiLHCJ+nfMmVes6EbOK13sRu/jOLzhISFZ1xI58dIzrnO0W/ygTzP2YSKJbeSt6UoSl05xAIoYGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r/rHXqHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r/rHXqHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528F8C4CEED;
	Sun,  1 Jun 2025 05:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756816;
	bh=ClsJb1uRn/EufHyfilSEmynmAOZXhVGwDOW5CyKTRzo=;
	h=Date:To:From:Subject:From;
	b=r/rHXqHkCje4rnBkZre00v5gcxHyRDsdhiKlO2+HcJwnE3KLDzwqDNomALDlNwuOZ
	 sNMSXJG1FOUD1oSGE3LubQ6xsvc6j3oaLK+weiSo/jwqPnGL+piLGlyNArYhE6t6l6
	 xSnl5wE+eJsiVlC4Ivip0ODIfwoEqJRHl61m0cGU=
Date: Sat, 31 May 2025 22:46:55 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,hughd@google.com,almaz.alexandrovich@paragon-software.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iov-remove-copy_page_from_iter_atomic.patch removed from -mm tree
Message-Id: <20250601054656.528F8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov: remove copy_page_from_iter_atomic()
has been removed from the -mm tree.  Its filename was
     iov-remove-copy_page_from_iter_atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iov: remove copy_page_from_iter_atomic()
Date: Wed, 14 May 2025 18:06:04 +0100

All callers now use copy_folio_from_iter_atomic(), so convert
copy_page_from_iter_atomic().  While I'm in there, use kmap_local_folio()
and pagefault_disable() instead of kmap_atomic().  That allows preemption
and/or task migration to happen during the copy_from_user().  Also use the
new folio_test_partial_kmap() predicate instead of open-coding it.

Link: https://lkml.kernel.org/r/20250514170607.3000994-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |   10 ++--------
 lib/iov_iter.c      |   29 +++++++++++++----------------
 2 files changed, 15 insertions(+), 24 deletions(-)

--- a/include/linux/uio.h~iov-remove-copy_page_from_iter_atomic
+++ a/include/linux/uio.h
@@ -176,8 +176,6 @@ static inline size_t iov_length(const st
 	return ret;
 }
 
-size_t copy_page_from_iter_atomic(struct page *page, size_t offset,
-				  size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
@@ -187,6 +185,8 @@ size_t copy_page_to_iter(struct page *pa
 			 struct iov_iter *i);
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
+size_t copy_folio_from_iter_atomic(struct folio *folio, size_t offset,
+		size_t bytes, struct iov_iter *i);
 
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
@@ -204,12 +204,6 @@ static inline size_t copy_folio_from_ite
 	return copy_page_from_iter(&folio->page, offset, bytes, i);
 }
 
-static inline size_t copy_folio_from_iter_atomic(struct folio *folio,
-		size_t offset, size_t bytes, struct iov_iter *i)
-{
-	return copy_page_from_iter_atomic(&folio->page, offset, bytes, i);
-}
-
 size_t copy_page_to_iter_nofault(struct page *page, unsigned offset,
 				 size_t bytes, struct iov_iter *i);
 
--- a/lib/iov_iter.c~iov-remove-copy_page_from_iter_atomic
+++ a/lib/iov_iter.c
@@ -457,38 +457,35 @@ size_t iov_iter_zero(size_t bytes, struc
 }
 EXPORT_SYMBOL(iov_iter_zero);
 
-size_t copy_page_from_iter_atomic(struct page *page, size_t offset,
+size_t copy_folio_from_iter_atomic(struct folio *folio, size_t offset,
 		size_t bytes, struct iov_iter *i)
 {
 	size_t n, copied = 0;
-	bool uses_kmap = IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) ||
-			 PageHighMem(page);
 
-	if (!page_copy_sane(page, offset, bytes))
+	if (!page_copy_sane(&folio->page, offset, bytes))
 		return 0;
 	if (WARN_ON_ONCE(!i->data_source))
 		return 0;
 
 	do {
-		char *p;
+		char *to = kmap_local_folio(folio, offset);
 
 		n = bytes - copied;
-		if (uses_kmap) {
-			page += offset / PAGE_SIZE;
-			offset %= PAGE_SIZE;
-			n = min_t(size_t, n, PAGE_SIZE - offset);
-		}
-
-		p = kmap_atomic(page) + offset;
-		n = __copy_from_iter(p, n, i);
-		kunmap_atomic(p);
+		if (folio_test_partial_kmap(folio) &&
+		    n > PAGE_SIZE - offset_in_page(offset))
+			n = PAGE_SIZE - offset_in_page(offset);
+
+		pagefault_disable();
+		n = __copy_from_iter(to, n, i);
+		pagefault_enable();
+		kunmap_local(to);
 		copied += n;
 		offset += n;
-	} while (uses_kmap && copied != bytes && n > 0);
+	} while (copied != bytes && n > 0);
 
 	return copied;
 }
-EXPORT_SYMBOL(copy_page_from_iter_atomic);
+EXPORT_SYMBOL(copy_folio_from_iter_atomic);
 
 static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


