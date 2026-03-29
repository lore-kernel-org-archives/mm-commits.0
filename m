Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384F279DCA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744971; cv=none; b=aESmGNYX6hha8IufnhHp2Pf+parzskLPKXHRG+mHc6sYJv3NtzVbKwU92SpWnVA83ozIHSUa5oe5xHEFBjd3F++De48cAGHJGsORPZg/lWuz8kNkFefW53cPR95f/K8jmS91m/L09pdcMvTNo+ReM1ITHTc6FHavY/nMccmWtCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744971; c=relaxed/simple;
	bh=70mwap4Zl0FRg1XnE25C1C0BRDpRmTxiYDlDFu27kGw=;
	h=Date:To:From:Subject:Message-Id; b=N7mrfK3qsYTGinKWLMXqmSHrhk9KYl7NoeJpEMgNFZtYsP80z4QJcoVEFV2KKeZbaZE98IEAiXHw1B2+gMoTswNBfOMQPeB5evZf3hlwCMOEnVoibohT1T4gCo+n+5dU3oKn7ACEYdkpw3ypsSRqfMem6PAH8jLtfpy7I5KAWAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/Ie9tWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/Ie9tWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBA3C4CEF7;
	Sun, 29 Mar 2026 00:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744971;
	bh=70mwap4Zl0FRg1XnE25C1C0BRDpRmTxiYDlDFu27kGw=;
	h=Date:To:From:Subject:From;
	b=X/Ie9tWyrLJ17HCUavb1QdfHcHOU6wwHkcVX9Mz7i+cNR66UUpVjebxT4fYQwEG9S
	 oD6L6HrT896LiESAAPyERgUhS3o/qKE+5uA3rrjCrbWzMnzg7FygY+iOZBxshfeTop
	 SdwtCgZj8DxELNg/ucwbJ4wdxo3c1q65m3l0hCO8=
Date: Sat, 28 Mar 2026 17:42:51 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-page_is_file_lru-function.patch removed from -mm tree
Message-Id: <20260329004251.9BBA3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused page_is_file_lru() function
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-page_is_file_lru-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: remove unused page_is_file_lru() function
Date: Mon, 23 Mar 2026 17:03:04 +0800

The page_is_file_lru() wrapper function is no longer used.  The kernel has
moved to folio-based APIs, and all callers should use folio_is_file_lru()
instead.

Remove the obsolete page-based wrapper function.

Link: https://lkml.kernel.org/r/20260323090305.798057-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/mm_inline.h~mm-remove-unused-page_is_file_lru-function
+++ a/include/linux/mm_inline.h
@@ -30,11 +30,6 @@ static inline int folio_is_file_lru(cons
 	return !folio_test_swapbacked(folio);
 }
 
-static inline int page_is_file_lru(struct page *page)
-{
-	return folio_is_file_lru(page_folio(page));
-}
-
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
_

Patches currently in -mm which might be from liuye@kylinos.cn are


