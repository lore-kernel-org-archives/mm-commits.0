Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB5C2C9A
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695807; cv=none; b=cwXz1WLXhSb1NRkMIGwd6BI5mlgskH8fmK9m7XFYeMQPKHeHmB1LT65/uLc4/lXtCJGyL49dpt+5Pi+8kvlSdHaersukRJ3Nup1tIWzSGC3xhW5nxBCbO3kOqmoNgRtU7eBSaxgHhiZ9LirmVGbmSdobpGL7IX27G8zN93z6JsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695807; c=relaxed/simple;
	bh=PJVR/8on3AqsnJ9UbONimcHTmGtlu5C17ujL4VnTqPA=;
	h=Date:To:From:Subject:Message-Id; b=seRMNgi0FfIGdohFYLaChSDvHGED7xdcYjxXqDwOAtGPoZS2hQV7G0HmxNPfS+dGnnDIy50Ef0+tQwtXU/U8aXBjcRtm9axGVYfpd2/i329mFlRFE08RsCaEfaSCQYlTVavX3uF5CA5ie78DLwyNGXBqUBVVfikg9l9KKKSnCX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rA/PMcKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rA/PMcKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F90C4CECE;
	Mon,  4 Nov 2024 04:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695806;
	bh=PJVR/8on3AqsnJ9UbONimcHTmGtlu5C17ujL4VnTqPA=;
	h=Date:To:From:Subject:From;
	b=rA/PMcKZXg/HDML2zQ7wZZAFiQQQy3cbv1UP1BNrAUtuiaidX6aBNfwvyo9mqfjn1
	 yb3LiEgJqWDSfjjPA+sXXGsO2HpX+pOlsRZTKxGjQsXd/HVN9e0/Un/7xmqkb2w3dR
	 VbHFGuG6pwK0IfVDQBOUeeTYxZ5qR0dFohg/x17E=
Date: Sun, 03 Nov 2024 20:50:06 -0800
To: mm-commits@vger.kernel.org,m.szyprowski@samsung.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-pageanonnotksm-fix.patch removed from -mm tree
Message-Id: <20241104045006.B7F90C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-pageanonnotksm-fix
has been removed from the -mm tree.  Its filename was
     mm-add-pageanonnotksm-fix.patch

This patch was dropped because it was folded into mm-add-pageanonnotksm.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-add-pageanonnotksm-fix
Date: Fri, 4 Oct 2024 18:43:52 +0100

fix assertions

Link: https://lkml.kernel.org/r/ZwApWPER7caIA_N3@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-add-pageanonnotksm-fix
+++ a/include/linux/page-flags.h
@@ -1144,14 +1144,14 @@ static __always_inline int PageAnonExclu
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

