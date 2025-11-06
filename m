Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FA62D6E53
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472597; cv=none; b=HGyh5pIv90nPyuGupaHBL7eEPWo9QTVaKfl6MT68C5Cq52uysVy0uKg8qwtwXdD7VBp8uT0sj3eEjZXphAEV/GIeHJYzueRrDvsDYyLFZZUWuet5fv14ITXR0AymP1r4cBfdsjH7FyGfk3JSHcBaprZ7VCLvD+bWgKQdS3AI33I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472597; c=relaxed/simple;
	bh=f0upZb2ba9OiqHyXuVqmx74H+2XYT6gvMyEFmhAES6M=;
	h=Date:To:From:Subject:Message-Id; b=Qq0uDY/OQKoyeESe0nzobNl0YWA6IqXyscO4AvacUnIc/mLwwtF4oqTR4ymtw0va0HWWuCDyDHrHrkGp76weRrZRF61L2984us1bHNjntGHanF2A6NZkorJ+IZFUM10ZXHLVw2w21O1soOh5unZrF3uEkzURSVI5BKOUqdzjkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxmZvTzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxmZvTzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAEFC116D0;
	Thu,  6 Nov 2025 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762472597;
	bh=f0upZb2ba9OiqHyXuVqmx74H+2XYT6gvMyEFmhAES6M=;
	h=Date:To:From:Subject:From;
	b=HxmZvTzBoK9uwdd8FU7uijGgdNFShtEtBhktCamWATwdHNZU4Te1PZ/Tcmyn2Zg+m
	 Ym3PZNOYLEcjfjNN0eP9G5Jo9XGlbJi32UCeyBPYIX5OsGcZBBAZpjGVYN/2uzqHqW
	 /LoF07SZl3kbM2typcCRw9JUTaop+9Am9JFY0WAE=
Date: Thu, 06 Nov 2025 15:43:16 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-__dump_folio-arguments.patch added to mm-new branch
Message-Id: <20251106234317.0EAEFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify __dump_folio() arguments
has been added to the -mm mm-new branch.  Its filename is
     mm-constify-__dump_folio-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-__dump_folio-arguments.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify __dump_folio() arguments
Date: Thu, 6 Nov 2025 20:35:25 +0000

These arguments aren't modified by the function; mark them as const to
help the compiler.

Link: https://lkml.kernel.org/r/20251106203526.2368275-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-constify-__dump_folio-arguments
+++ a/mm/debug.c
@@ -67,7 +67,7 @@ static const char *page_type_name(unsign
 	return page_type_names[i];
 }
 
-static void __dump_folio(struct folio *folio, struct page *page,
+static void __dump_folio(const struct folio *folio, const struct page *page,
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch
mm-constify-__dump_folio-arguments.patch

