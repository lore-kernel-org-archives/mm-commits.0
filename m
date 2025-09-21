Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5CD28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489835; cv=none; b=WCDI6ltHqPUj/RdDhQxrJsYIIGoO1nw+snjaeHNZKkN5lPc9Z8szlp8aWiNiiWHxVwlzT4CSaPKHkNVIk4EzwI/etvsBFEewtLLnpnT/btio3g4JN680WDSBJu6zr5SyykLWfbzQqkJv/3SKk/0aOeu/GrrrxrcHi/zRUEse7ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489835; c=relaxed/simple;
	bh=0reDb/K8VQ0iPSHGmzpkaFfuSj+FWnJFFGxvxnaenlE=;
	h=Date:To:From:Subject:Message-Id; b=HmgiM0p0HCYLF22zTmRY+Ih0Sptqpx6EXSNdkGIp105PTTActfs0oxjV3EA570QIIl3lBaSTHUzP0CyYu54Qp5LVI0RNn+u9OJgPVd4GJdD75P8jSI4uljVbnoV4dH83AV7al8XopsCiyCyG+8ruH3Nrv6R+h1O2l20ZDPfyrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lP9VOYdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lP9VOYdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F420C4CEE7;
	Sun, 21 Sep 2025 21:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489835;
	bh=0reDb/K8VQ0iPSHGmzpkaFfuSj+FWnJFFGxvxnaenlE=;
	h=Date:To:From:Subject:From;
	b=lP9VOYdpTV2wothyzTQinyNXbka+s4vtepzSoutQ2CsgaKayVP005Ha6AM2nhDWa6
	 1Rn3sJv1zN7eCdx/PXwVwwxHVwjUqFOFOWDn2+mBERBBt/V5PhB92hYoBRintFemgk
	 PI9XO0VluqAhajkoL+bIUMCxpX79ezBpbNsM6Myg=
Date: Sun, 21 Sep 2025 14:23:55 -0700
To: mm-commits@vger.kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch removed from -mm tree
Message-Id: <20250921212355.8F420C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scatterlist: disallow non-contigous page ranges in a single SG entry
has been removed from the -mm tree.  Its filename was
     scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: scatterlist: disallow non-contigous page ranges in a single SG entry
Date: Mon, 1 Sep 2025 17:03:45 +0200

The expectation is that there is currently no user that would pass in
non-contigous page ranges: no allocator, not even VMA, will hand these
out.

The only problematic part would be if someone would provide a range
obtained directly from memblock, or manually merge problematic ranges.  If
we find such cases, we should fix them to create separate SG entries.

Let's check in sg_set_page() that this is really the case.  No need to
check in sg_set_folio(), as pages in a folio are guaranteed to be
contiguous.  As sg_set_page() gets inlined into modules, we have to export
the page_range_contiguous() helper -- use EXPORT_SYMBOL, there is nothing
special about this helper such that we would want to enforce GPL-only
modules.

We can now drop the nth_page() usage in sg_page_iter_page().

Link: https://lkml.kernel.org/r/20250901150359.867252-25-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    3 ++-
 mm/util.c                   |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/scatterlist.h~scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry
+++ a/include/linux/scatterlist.h
@@ -158,6 +158,7 @@ static inline void sg_assign_page(struct
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
 	sg_assign_page(sg, page);
 	sg->offset = offset;
 	sg->length = len;
@@ -600,7 +601,7 @@ void __sg_page_iter_start(struct sg_page
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return sg_page(piter->sg) + piter->sg_pgoffset;
 }
 
 /**
--- a/mm/util.c~scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry
+++ a/mm/util.c
@@ -1315,4 +1315,5 @@ bool page_range_contiguous(const struct
 			return false;
 	return true;
 }
+EXPORT_SYMBOL(page_range_contiguous);
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


