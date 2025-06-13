Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C631DF258
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 23:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857764; cv=none; b=h4+wPdQxZCFPWE4f3sE1+1xoprcBJ6sxXcaYby+78+YQArCSK+kLVu+F+anaGBJN/FN1l4arNjLgetdPh7pZNwboZBbJzJxH0goezQ5xDfgyHwqTq3BmbwOjk1Jex0g2RRStLSk54WNmNx8SNEVZh6AcrOEDtmNFVhnoQZZqBeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857764; c=relaxed/simple;
	bh=HyjTMKW19xI+EWvb/3DCP3pTLaFavpf9jnymPrm0fWY=;
	h=Date:To:From:Subject:Message-Id; b=WnXbNUyg6zmg59e/n144CIoadmc7rD0FaAnsNyF3Rn61/WSJSzsU3tHXvxCIsmFmy2LczeA60tU+rxjmNcyC/zfCgKAXnTIBEh6zhJc9Lq9zTwo78pioreqz6MW7uC8a/u5T+J29PK966Dn694N4G/dt7IPctAhjOrOs9LodTJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KWxXOAdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KWxXOAdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6492EC4CEE3;
	Fri, 13 Jun 2025 23:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749857763;
	bh=HyjTMKW19xI+EWvb/3DCP3pTLaFavpf9jnymPrm0fWY=;
	h=Date:To:From:Subject:From;
	b=KWxXOAdL/W4Wbc+Um4VvHFTlpvqLmeGjo+fYle6WCfDx/JsUYqVBQccRUZ4IDudaU
	 m7NdCoLx1d9Z5GAiHiUW6KFSW5GW0ATEbnt0q3l7bN8HA31LClH6a26zgni/3p4WJ9
	 sOa09o758DuUkm5YRm0dy0fTSWKSac8LIMF5f3cg=
Date: Fri, 13 Jun 2025 16:36:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-remove-a-use-of-folio-page.patch added to mm-new branch
Message-Id: <20250613233603.6492EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: remove a use of folio->page
has been added to the -mm mm-new branch.  Its filename is
     highmem-remove-a-use-of-folio-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-remove-a-use-of-folio-page.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: remove a use of folio->page
Date: Fri, 13 Jun 2025 20:48:23 +0100

Call folio_address() instead of page_address().

Link: https://lkml.kernel.org/r/20250613194825.3175276-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem-internal.h~highmem-remove-a-use-of-folio-page
+++ a/include/linux/highmem-internal.h
@@ -195,7 +195,7 @@ static inline void *kmap_local_page_try_
 
 static inline void *kmap_local_folio(struct folio *folio, size_t offset)
 {
-	return page_address(&folio->page) + offset;
+	return folio_address(folio) + offset;
 }
 
 static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
secretmem-remove-uses-of-struct-page.patch
highmem-remove-a-use-of-folio-page.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

