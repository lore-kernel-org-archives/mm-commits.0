Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9368405C20
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779136526; cv=none; b=YADMGFqODxXYiOkNYkV5WxLHw83RSTLwGkbZ7iFo2c6a9AHWSD2B7yaEE+Xpd3AsizOMxGnf4Whsw/zQ1YjvJKjd5+QpQSab9wWBwOwQY/z6Omr6bmqBkwUR5CKAyPkQhmiGbZ8YUpwnAzh9+QbJ7yeQvzZiK+tO3OktA57GF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779136526; c=relaxed/simple;
	bh=4wGzRvlxGAS3u+4cqicIwrpW/iwVqgEQqZ3h5+QyEHo=;
	h=Date:To:From:Subject:Message-Id; b=GQIIO7dNiSYvPgbPmfYONlU06z7W5bhlc7Xa8/BvKiX4z3pyt2erDOdiEbjpeH/+Sz7EsX3Tp8SxnKRoTkdnoWOtl5qiU+l+gyNOTWoewtgL8IXlRo29JMI4qGx5v0ka+kdsn+0IhXtodOnykf/GA+A/LZ0ZeE2O1W8gVUG4EJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXuC+tbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXuC+tbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C8EC2BCB7;
	Mon, 18 May 2026 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779136526;
	bh=4wGzRvlxGAS3u+4cqicIwrpW/iwVqgEQqZ3h5+QyEHo=;
	h=Date:To:From:Subject:From;
	b=bXuC+tbdY6upBHcMhdy7IU7PDNgGJAtyOW5NB775iJMmpq1SrpT3DadGDsVuWhl0e
	 ug4jYitn/iGXb33xiOAZFea3WD3YrJIh9VwzpjrL68Mbf9+V9n4JuLFk0wYTtkN2it
	 jj13SnuJhyNRPan9UHwkJ5rTyxl2+rklth0XRGJM=
Date: Mon, 18 May 2026 13:35:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-drop-a-misleading-__always_inline.patch added to mm-new branch
Message-Id: <20260518203526.66C8EC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: drop a misleading __always_inline
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-drop-a-misleading-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-drop-a-misleading-__always_inline.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: drop a misleading __always_inline
Date: Sun, 17 May 2026 23:37:05 +0000

get_pfnblock_migratetype() is called from outside page_alloc.c, so it
cannot always be inlined.  Remove the annotation to avoid misleading
readers.

At least in my minimal config, with GCC, this doesn't change
mm/page_alloc.o at all.

Link: https://lore.kernel.org/all/20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-a-misleading-__always_inline
+++ a/mm/page_alloc.c
@@ -434,7 +434,7 @@ bool get_pfnblock_bit(const struct page
  * Use get_pfnblock_migratetype() if caller already has both @page and @pfn
  * to save a call to page_to_pfn().
  */
-__always_inline enum migratetype
+enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
 	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch

