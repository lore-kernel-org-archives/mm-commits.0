Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BCD18D647
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925256; cv=none; b=SQ8hwjCdFFPR/a0LqCJhNCGjcdFJr6Na4Qdy49vJE+G5aC56pNFV+I6oNNp+wFTj/7tWUBJqXCMdxHyTU8CX7AWhhGtXKznjKlNsUCaN7ltyeYtFTnv3ZIGe5jvW8bNK6m/JEZBmLg5/iLsT3USOPlURV1sqiwsBmn24BXjM8js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925256; c=relaxed/simple;
	bh=b0FTKDDY6dz8hk2dJQVqKeYYkyXoqcPY83H38ZftaVc=;
	h=Date:To:From:Subject:Message-Id; b=te5CRirsQmrMDl1Q81T2+MUgngtdk5fb5BIJ3d0NKPU+gqqQZuKZW8km9U6HFv5LYcG7uMaMAwlW50oOh/YTTCvskYqk8ADKrZfKj2gNZHjPU8hbWvKz30oLEOmL6oZL0eKq+Vt9gJtwIwBRbWxZg/sblFemUcX3KL+fGBqYdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LhF/qmf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LhF/qmf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E218C4CEC5;
	Mon,  9 Sep 2024 23:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925256;
	bh=b0FTKDDY6dz8hk2dJQVqKeYYkyXoqcPY83H38ZftaVc=;
	h=Date:To:From:Subject:From;
	b=LhF/qmf9JNYyNhY0aAqCthmGB44mDuBJqXfDK4bjWQg1WcN2//QN+kTXXbH4ucWFi
	 Yag86U/WrTF1SoJhjZxZyqoV6z6cBkHpvuYeS/+uXrJlTBkgZWiCkSR8ATU+PuOjvR
	 a7+bnF2CiCtrGh/sJz6zsNKNVYDmDGeKGSdRBMRM=
Date: Mon, 09 Sep 2024 16:40:56 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-folio_alloc_noprof.patch removed from -mm tree
Message-Id: <20240909234056.8E218C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix folio_alloc_noprof()
has been removed from the -mm tree.  Its filename was
     mm-fix-folio_alloc_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm: fix folio_alloc_noprof()
Date: Sun, 1 Sep 2024 16:24:59 -0400

folio_alloc_noprof) wasn't calling the _noprof version, causing
allocations to be accounted here instead of to the caller

Link: https://lkml.kernel.org/r/20240901202459.4867-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-fix-folio_alloc_noprof
+++ a/include/linux/gfp.h
@@ -319,7 +319,7 @@ static inline struct page *alloc_pages_m
 }
 static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	return __folio_alloc_node(gfp, order, numa_node_id());
+	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
 }
 static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid)
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

mm-show_memc-report-alloc-tags-in-human-readable-units.patch

