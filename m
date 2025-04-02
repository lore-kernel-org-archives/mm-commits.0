Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F6A1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630660; cv=none; b=tFnObVY1GiJRZnPV4MdBZoX0RmS/ouQKETnuerNAd+psHkTw49rcvoa8BB8ciXgwKNx+mRSytO+ojxBGTE/7GMVP48w6sSRSz1A6hglKNw/3PCkUzGm9z8hVFoM3kT6bL7OUz9/KoQf96YVrIGP04HFwyjcKpstlo4vUc3+lp9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630660; c=relaxed/simple;
	bh=Afvh2ipPD40JLF2N6waPc8o0iH9+LzzaavcsNf9haxA=;
	h=Date:To:From:Subject:Message-Id; b=uweboMRALGJC0g7O9awYr4irf16x3bjkhTGYuY3USfvqMuCzx7S6+ozalPHBHRVSS528IHd+b1NlUUUpLUJSr3sidcLKTDXYcuxUGe0z/I/BfCMWDoXxIep3VuBWNRTqq0oCspw9o0MTKrZeUfX99WpptKIEmISsaurDXp45IN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NbEiTUxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NbEiTUxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A832C4CEDD;
	Wed,  2 Apr 2025 21:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630660;
	bh=Afvh2ipPD40JLF2N6waPc8o0iH9+LzzaavcsNf9haxA=;
	h=Date:To:From:Subject:From;
	b=NbEiTUxT70THpSfwASl1kcHXuekjCFplpIRNYtZsdXBY0Q7HVK/r4pqwaolqs+MxC
	 Di7EZhScRVIDlayq5a0cZ3Fnrpagzrt8DrPUbG+dS8aNeHijwnOS48G55qFS8vuf8m
	 /yqds58PtUDheAxCRJJPg4ZH+KpfTT/fqxGKCyVg=
Date: Wed, 02 Apr 2025 14:50:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-thp_nr_pages.patch added to mm-new branch
Message-Id: <20250402215100.7A832C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: delete thp_nr_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-delete-thp_nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-thp_nr_pages.patch

This patch will later appear in the mm-new branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: delete thp_nr_pages()
Date: Wed, 2 Apr 2025 22:06:10 +0100

All callers now use folio_nr_pages().  Delete this wrapper.

Link: https://lkml.kernel.org/r/20250402210612.2444135-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/mm.h~mm-delete-thp_nr_pages
+++ a/include/linux/mm.h
@@ -2168,15 +2168,6 @@ static inline long compound_nr(struct pa
 }
 
 /**
- * thp_nr_pages - The number of regular pages in this huge page.
- * @page: The head page of a huge page.
- */
-static inline long thp_nr_pages(struct page *page)
-{
-	return folio_nr_pages((struct folio *)page);
-}
-
-/**
  * folio_next - Move to the next physical folio.
  * @folio: The folio we're currently operating on.
  *
_

Patches currently in -mm which might be from willy@infradead.org are

filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

