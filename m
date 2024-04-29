Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3633484D09
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408870; cv=none; b=k7B61f2tJksZ0k7T4fWWLKDC4ycFdZ7ZbjZjhUR27m/cKI2/NVq144PLLoNNAbhaMcukVWuxWYySu34gLlbvNqRh+711qmbJ9ZG5UGHEeyFlB0fJaBRvGcVLuXKFyr5VsXILlABrfNGwrQHu5aKwhhmirsKEeNDqNEsdbCEuVzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408870; c=relaxed/simple;
	bh=xIfr39eJXTtrusasuv2gkeeG1ktwkateTlFu4sWEFeA=;
	h=Date:To:From:Subject:Message-Id; b=thUZ0dI2k8tvTrsvPj3DZCtpE6M/PQ/R9DBoiU+26LpqIxPTbj21e7bCss8fhIQa3jQdnvGfQfWT/bWCFQplQZJdIDZBIo1bN+rdLvtQ9GstZPF2px9tIZZDNNQqqjrKy+6FMLWar8YbIOm48CNM/o5MVb6mCDdEvQzFTSuZhLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eRPrEjof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eRPrEjof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7913DC113CD;
	Mon, 29 Apr 2024 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408869;
	bh=xIfr39eJXTtrusasuv2gkeeG1ktwkateTlFu4sWEFeA=;
	h=Date:To:From:Subject:From;
	b=eRPrEjofxFK2huE0YOjHyg2CYOvrFmjzVkcv2u0HVgViUKRWk6kdTHSroP1/mBK/I
	 Z5S30E1WfUlsGJBqXMkZipXnJPY/aI+RDdAQFoPsvIWMttlrlrNe1TKxnzOdGNY0Md
	 gj8H9G/iHwsa+8OuTc7gZ2a7OVV6VQr+ZfTMD6+w=
Date: Mon, 29 Apr 2024 09:41:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagemap-make-trylock_page-return-bool.patch added to mm-unstable branch
Message-Id: <20240429164109.7913DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagemap: make trylock_page return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagemap-make-trylock_page-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagemap-make-trylock_page-return-bool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/pagemap: make trylock_page return bool
Date: Sun, 28 Apr 2024 09:47:11 +0800

Make trylock_page return bool to align the return values of folio_trylock
function and it also corresponds to its comment.

Link: https://lkml.kernel.org/r/20240428014711.11169-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-pagemap-make-trylock_page-return-bool
+++ a/include/linux/pagemap.h
@@ -1011,7 +1011,7 @@ static inline bool folio_trylock(struct
 /*
  * Return true if the page was successfully locked
  */
-static inline int trylock_page(struct page *page)
+static inline bool trylock_page(struct page *page)
 {
 	return folio_trylock(page_folio(page));
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch
mm-page-flags-make-pageuptodate-return-bool.patch
mm-pagemap-make-trylock_page-return-bool.patch
mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch

