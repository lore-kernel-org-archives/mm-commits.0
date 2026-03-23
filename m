Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573003AF649
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286065; cv=none; b=WdEn8Nw5m3zIf2s401YToPP83TAXbBL2qsplOb3rlYnV7ZHbftzBmOQw8wuogCQOGETzYIL49BTNLNNSebbqSeyedQrXolZxlqRaDufvaa/rsUemsIYL6YMKVoYL4F4YaZ8hJF4OWeQocQxgBMqLHJmHsYfdoBxJHglpiS6o1tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286065; c=relaxed/simple;
	bh=Qc+XFLFNoFc20aWRdhKotyHp/mZJBaVmJy2CK9+d/iA=;
	h=Date:To:From:Subject:Message-Id; b=nZVrautmv8Njh0pPeUACe8701jOqNMLs9prNl8XbkoCvcuSRJBxghcO0eKOAyi3sECjANM0uN+1IzyLhNs0pMOc7BAM7qq71roDGJXkKZCgqELQIFmfGOHmt9SsOPQ6RYWykeFphOG/IeHojQIHPlo7r3cxHS8raMcZM+QqNkUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iIAU9QDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iIAU9QDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65169C2BC9E;
	Mon, 23 Mar 2026 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774286064;
	bh=Qc+XFLFNoFc20aWRdhKotyHp/mZJBaVmJy2CK9+d/iA=;
	h=Date:To:From:Subject:From;
	b=iIAU9QDlNNIt6strsXn/+oQfY6XsoBhdJlvrKYDa66+0SdNWB4tVa9zbeeBm7o949
	 ZzLRM8W5BnnKj3+hEinyMj1iIknpoOZw+3shWRo3Mj4CeevyIReo2OfbDDWvxNwfZU
	 +v79v6BfR1Nl3txsWY/6RT2sb415sfM6QssUsgxg=
Date: Mon, 23 Mar 2026 10:14:23 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-page_is_file_lru-function.patch added to mm-new branch
Message-Id: <20260323171424.65169C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused page_is_file_lru() function
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-page_is_file_lru-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-page_is_file_lru-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-remove-unused-page_is_file_lru-function.patch

