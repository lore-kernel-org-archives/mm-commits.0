Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75C2BB0A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957101; cv=none; b=UAdF2aG7y/qvgPk52HJZvd1E+OjcfHMsSZXN1rKm2n/S9kJW3cAWFc6ys4s7FoaAaBAtsq8Oyng6+T2drnjfo3v87FyAFe2MLOHSMMB4wuKpq0zOGGbzaITp2BuZYTkeF2DDDj838vl88np4pXBxZ9aznKyJBdvtLIikxSw97L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957101; c=relaxed/simple;
	bh=KWPtgYlJa7SUovF1sTThq2nI8R3ugfX+PZCi3lhUkVI=;
	h=Date:To:From:Subject:Message-Id; b=YXd3jO8f9RGsk/KtIUVLT5AYAw+hluJid1g64JI3xEvAbIXf3163i8CcNg7Ie5j9UbWn/e4jY+MlB06w8wxZt7Ufa14Slr1fbYy+jMgBT+h7qPbecMvevHqo5XIhsu9feXVcAY9DVp6b1Sel1Z8hHAEmvrMVzh2aUXyKOcqN5z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0YILyfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0YILyfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E0C113CC;
	Mon,  6 May 2024 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957101;
	bh=KWPtgYlJa7SUovF1sTThq2nI8R3ugfX+PZCi3lhUkVI=;
	h=Date:To:From:Subject:From;
	b=b0YILyfGG8CSrWug+xKzucMfrnqAkhDpNxvfkU8PKImPBI1B5tlktxTG4VnD+OUhh
	 ZojjeFXgTspMASGALrKv8/PJkZ9qSEHvueIJnnFY+pfVPKiETIvsJyFNsgEn4f71JT
	 4SkYJyKFnw8a5yZFh60kQSvuAiYRUOYKuYR3NAgg=
Date: Sun, 05 May 2024 17:58:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-put_devmap_managed_page.patch removed from -mm tree
Message-Id: <20240506005821.7E3E0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove put_devmap_managed_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-put_devmap_managed_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove put_devmap_managed_page()
Date: Wed, 24 Apr 2024 20:19:07 +0100

It only has one caller; convert that caller to use
put_devmap_managed_page_refs() instead.

Link: https://lkml.kernel.org/r/20240424191914.361554-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-remove-put_devmap_managed_page
+++ a/include/linux/mm.h
@@ -1457,11 +1457,6 @@ static inline bool put_devmap_managed_pa
 }
 #endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 
-static inline bool put_devmap_managed_page(struct page *page)
-{
-	return put_devmap_managed_page_refs(page, 1);
-}
-
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
@@ -1580,7 +1575,7 @@ static inline void put_page(struct page
 	 * For some devmap managed pages we need to catch refcount transition
 	 * from 2 to 1:
 	 */
-	if (put_devmap_managed_page(&folio->page))
+	if (put_devmap_managed_page_refs(&folio->page, 1))
 		return;
 	folio_put(folio);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

