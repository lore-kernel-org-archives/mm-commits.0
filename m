Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDF118B47D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006309; cv=none; b=C36PQl/dyfok+XujH11ZzM0DR0eu81G2nH5gxKX1k9m7ZzorAtPxFpPSNkoVVHJbSD8XJysQ+Q5cUCDggqProNrhsvFlQmsLYAwa+ck43Pge2khN/YPmRcCSJMecTXz1AXf5cqs/KSM5d+9SbyI7BcR8BPpxUW+o/oALo23N7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006309; c=relaxed/simple;
	bh=rrjdxiAW0ucss8E5hw5ppWOxH4aRNbm5xNOlbB6sJiY=;
	h=Date:To:From:Subject:Message-Id; b=i1C2He6TJsUYtGlJp0nusPqnTwnv0noJKItdsv9OA7CntUiolEVdoCw0IyhXB8JelR3ffcU2UaXNDywJD4wQUKjPqj/d4VRYqCmxGy0j2g2PneDDwMm0o3S9I8u1OSgX5A/vVHRcsUu1kVMPlejpUNtAWUDoVrGwH9w9oS2vF5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W604ebjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W604ebjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076D7C4CED6;
	Thu, 16 Jan 2025 05:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006309;
	bh=rrjdxiAW0ucss8E5hw5ppWOxH4aRNbm5xNOlbB6sJiY=;
	h=Date:To:From:Subject:From;
	b=W604ebjQnoljVJGMUfHH719khpRCzVFCGuAMnDipTUoKzsxfmsYpbAoVMZRRiEIjf
	 Js7I8khJBYWiJGAB4qqSSnsb2ZNixX1Mn+FDcxH2OfGUAFDvIVmpL0VXSkWvmqrcHk
	 6hUiBsWZPwusWCuNsmNLQBra/QUUrl4LMp+xMp/0=
Date: Wed, 15 Jan 2025 21:45:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch removed from -mm tree
Message-Id: <20250116054509.076D7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: convert has_hwpoisoned into a pure folio flag
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: convert has_hwpoisoned into a pure folio flag
Date: Mon, 13 Jan 2025 14:16:06 +0100

Patch series "mm: hugetlb+THP folio and migration cleanups", v2.

Some cleanups around more folio conversion and migration handling that I
collected working on random stuff.


This patch (of 6):

Let's stop setting it on pages, there is no need to anymore.

Link: https://lkml.kernel.org/r/20250113131611.2554758-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++----
 mm/huge_memory.c           |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag
+++ a/include/linux/page-flags.h
@@ -906,11 +906,9 @@ TESTPAGEFLAG_FALSE(TransCompound, transc
  *
  * This flag is set by hwpoison handler.  Cleared by THP split or free page.
  */
-PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
-	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
 #else
-PAGEFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
-	TESTSCFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
+FOLIO_FLAG_FALSE(has_hwpoisoned)
 #endif
 
 /*
--- a/mm/huge_memory.c~mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag
+++ a/mm/huge_memory.c
@@ -3290,7 +3290,7 @@ static void __split_huge_page(struct pag
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
 
-	ClearPageHasHWPoisoned(head);
+	folio_clear_has_hwpoisoned(folio);
 
 	for (i = nr - new_nr; i >= new_nr; i -= new_nr) {
 		struct folio *tail;
_

Patches currently in -mm which might be from david@redhat.com are


