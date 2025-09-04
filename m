Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E02F6565
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 23:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028460; cv=none; b=aHEH5Fa7JCpDgiodD1qA+bW2uSTheaTgjHjamJxVeXjRy71aVUixTc7EMNjGxa2x4Yig678MGot6P92XPPqYuvx2lGkjVNiiDqTykV1fEa1q8y9i/NIvMJo/xerHH8S32ZTRdnS/7RS4sv7xKS6zs2CVBzxZyH+BaSz0x1F3n8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028460; c=relaxed/simple;
	bh=LhWaDFE78UN+xKYpu2d31nQuMkqwb5GXihpglwDIabk=;
	h=Date:To:From:Subject:Message-Id; b=hArHmH2HmtLT0/uiO7iexbJ2ScJJZ29GHVQCVtV0lpu5LOzrUMAI5SQl7jFk4ZFDKGy8fUOnz9sMu4wxLNqgZ0uwRF4kGDZX5ojSM5QqowQTJ3IRlxaum66x+er0zYO0yfPWQMTq5UMCqMC1k5zWFLy1ZN1Xfgbt9bhkkCd2FTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SokJaamx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SokJaamx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF61C4CEF0;
	Thu,  4 Sep 2025 23:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757028460;
	bh=LhWaDFE78UN+xKYpu2d31nQuMkqwb5GXihpglwDIabk=;
	h=Date:To:From:Subject:From;
	b=SokJaamxObfdFdp75X3jPNf1Uaf9hl/Z66ochx0HZTQf7MLOShjUyYTVGTbEx/JjO
	 9QVeoJBuxcnrdmWNLTCElx5JA7GQbqAWFOuURzID46bRDPrFQ+Hg2w3AW32OEGSIUq
	 1fxiawt5l6VM3dN7RgD5K+TBcExTHTqClNHTI/DE=
Date: Thu, 04 Sep 2025 16:27:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch added to mm-new branch
Message-Id: <20250904232740.1BF61C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
has been added to the -mm mm-new branch.  Its filename is
     huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Thu, 4 Sep 2025 11:51:29 +0200

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

This issue was discovered while experimenting with enabling large folios
without THP and it was found that returning 0 from these functions is
resulting in undefined behavior in truncate operations.

Make all these functions return -EINVAL to indicate failure instead of 0. 
As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Link: https://lkml.kernel.org/r/20250904095129.222316-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled
+++ a/include/linux/huge_mm.h
@@ -588,22 +588,30 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch
huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

