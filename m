Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B11F25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742230; cv=none; b=P5VG28tY/X3VmuBFcmXW2PRgoDwJEwinwKUBmd612Mf/sgTRV8r/pjDkV8Nt4UwU9W4wh9WE8UwLnQkJitRrT54QKlzqV/XMLBhQnufYvRdIE47GmRxwJcxinq61KwfwoJYHmQEb23xnnU7iehFh13i6Sop0p2pUJaBaghWgaOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742230; c=relaxed/simple;
	bh=e5SxrDsGoAiHcmfv2rTDDI8FxdCg1jlolSoyjG4UxfY=;
	h=Date:To:From:Subject:Message-Id; b=NBaRmwaskS4/ADsW8TeXFf5oaE24ELubtdUJ4mMGgSOYkdcz5wliH69ugwijb8kZa6y2IOQl1szRig8we+aaGTn8IbhoQ5HarZXR4D/DSk7uzU3P/dw793W3SdFAKVF9wFou9FKrjh3+Uisvco3wtMxPmriwf5ZkjaQJlr8onzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sUo5H0Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sUo5H0Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E5C4CED6;
	Mon, 13 Jan 2025 04:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742230;
	bh=e5SxrDsGoAiHcmfv2rTDDI8FxdCg1jlolSoyjG4UxfY=;
	h=Date:To:From:Subject:From;
	b=sUo5H0Yx1u87t+WVIYnRdt+kY/qw82L6B+klEIdFvDiF4YjnPAXDkUHvWTofAXK3x
	 TvriyVWQdrqw+81tIrTqJ68Q19gWI4s6xHZuEKncJisfTLDLvW+7u0//MEAuvfMz6n
	 1RdrPw2Mni2Pb8PcvgwXzcU9WMZ1lwbpQnj2LyBo=
Date: Sun, 12 Jan 2025 20:23:49 -0800
To: mm-commits@vger.kernel.org,dhowells@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] iov_iter-remove-setting-of-page-index.patch removed from -mm tree
Message-Id: <20250113042350.313E5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: remove setting of page->index
has been removed from the -mm tree.  Its filename was
     iov_iter-remove-setting-of-page-index.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iov_iter: remove setting of page->index
Date: Mon, 16 Dec 2024 16:12:50 +0000

Nothing actually checks page->index, so just remove it.

Link: https://lkml.kernel.org/r/20241216161253.37687-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit_iov_iter.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/kunit_iov_iter.c~iov_iter-remove-setting-of-page-index
+++ a/lib/kunit_iov_iter.c
@@ -63,9 +63,6 @@ static void *__init iov_kunit_create_buf
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
 
-	for (int i = 0; i < npages; i++)
-		pages[i]->index = i;
-
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
mm-remove-pagetranstail.patch

