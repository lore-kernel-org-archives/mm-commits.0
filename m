Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D940B673
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956148; cv=none; b=V807T2bzTxAqYvP7csM25JV62zfBXNr+O620cX/4iFubMMS/5t1QmjAf0meypd4dqlPHXrUFS0keL1LJ8qdeQtFg/b6OLyBE5BOJtqi9DUm5jh+kqDS2CxodwXiv8ApXKO3paPuWJzzKG0qPYupGzZrZj54neDrqbaIO7SuQ58Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956148; c=relaxed/simple;
	bh=t0N0U37PI5CYk+RNrVN0opS1i4Vb0oDN2jQiBCsvz7k=;
	h=Date:To:From:Subject:Message-Id; b=Kv1TFMX8Ff2R6+Up8Z+F0oclMYBnF37RFzlp7z2PUEdSwu1GXxZJtUmA6aZREf5hsl7twgyrYZawg+lF2JY8vjluAuL59A7pxk1lzY/9PFkeyG+EZOsArjIt5mLVwvcl7E91hUAbx7PU3gdsByPKTwq7o1CmLHva96vik7QCK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X5OX63h5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X5OX63h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B236C113CC;
	Mon,  6 May 2024 00:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956148;
	bh=t0N0U37PI5CYk+RNrVN0opS1i4Vb0oDN2jQiBCsvz7k=;
	h=Date:To:From:Subject:From;
	b=X5OX63h5f0kOlIntDMJEgYSD+A7iRQVWi9He91IJEVePQOzs4dNw6N0X27NtOC3Ca
	 XUMBg3WqffY3ZuppdG8x4rMpPRiL+X22mwsMDlN6NP6rsvYsICOC44Ua7+PUSfqIai
	 k27OR326CBz0zsasutg7h7WUbZwVeDHhWyLOK2Bc=
Date: Sun, 05 May 2024 17:42:27 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch removed from -mm tree
Message-Id: <20240506004228.2B236C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch

This patch was dropped because it was folded into mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
Date: Mon, 15 Apr 2024 12:14:09 -0700

remove unneeded `extern'

Link: https://lkml.kernel.org/r/71760ed4-e80d-493a-95ea-2545414b1aba@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
+++ a/include/linux/hugetlb.h
@@ -861,7 +861,7 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-extern int dissolve_free_hugetlb_folio(struct folio *folio);
+int dissolve_free_hugetlb_folio(struct folio *folio);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

