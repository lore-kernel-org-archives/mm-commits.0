Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B583BA5E
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847372; cv=none; b=AEmWnaxcQga6qxyJLnpI/v1W+1Re5qnSHNp3sXRAwrgJ9+eut8Q8Ty9/V8Sw6PvO1khLTy9WXQvcvfC9jEuTvGndtrx8TXTap8SdHKlbdS5h0yTPEW4lUfwU48om/FpcO+isbu2SzzpHHGLGhcEOYKmNRiCuyJVzzIrGhJxTf5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847372; c=relaxed/simple;
	bh=ECwkilF22FTdOxIHDYxSE3SekBPv+y9D5QrqjANBO+s=;
	h=Date:To:From:Subject:Message-Id; b=rQFnglJgCjDGIvjBwx9W18o+8nb3pr+BS+Sy3RRLLKRfLirqPoMuM6idtwGqfpnTtVgPWN32GM7gUwV8iOlo+E9DVZu3JDiAgbRip2BBA6vAQaEE22dXe2mBR8a6HCpZZnuGUmShTJmpznX582SvH3NWvXQugT5j12anwNJO7rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NsxwyqjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NsxwyqjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C02FC32786;
	Thu, 20 Jun 2024 01:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718847371;
	bh=ECwkilF22FTdOxIHDYxSE3SekBPv+y9D5QrqjANBO+s=;
	h=Date:To:From:Subject:From;
	b=NsxwyqjSZA34nmbnfL5m4WiG+jQdWJuJuzCPD2uEWAqsOIMPanTz/reaZKVBUaCKE
	 JBgh7Uz2jAtfDe04Pzy2wnNuTvD+5J6xLjvwk2pDtYAE0bbhMT/nkeqIvtjKlZXJ26
	 F4pOTddWy3pueaMzv/M1SFjBRqim+sK++TxQUN9c=
Date: Wed, 19 Jun 2024 18:36:10 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-nr_pages-wont-be-0.patch added to mm-unstable branch
Message-Id: <20240620013611.6C02FC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: nr_pages won't be 0
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-nr_pages-wont-be-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-nr_pages-wont-be-0.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/sparse: nr_pages won't be 0
Date: Wed, 19 Jun 2024 01:06:09 +0000

Function subsection_map_init() is only used in free_area_init() in the
loop of for_each_mem_pfn_range().  And we are sure in each iteration of
for_each_mem_pfn_range(), start_pfn < end_pfn.

So nr_pages is not possible to be 0 and we can remove the check.

Link: https://lkml.kernel.org/r/20240619010612.20740-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/sparse.c~mm-sparse-nr_pages-wont-be-0
+++ a/mm/sparse.c
@@ -195,9 +195,6 @@ void __init subsection_map_init(unsigned
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
 
-	if (!nr_pages)
-		return;
-
 	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
 		struct mem_section *ms;
 		unsigned long pfns;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch
mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch
mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

