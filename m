Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DCC181324
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009570; cv=none; b=YMed+qt25GcWfstQqmuVIkkLoVtFR7cbbl/ysbWSUhwXQEM7cvOjmY6XfGchYPmv6IB6vLRhotCfc/14JZimdlR1gDLehUkreVfza5ZuHb3i9PpYk5PG0AJYBIeSP1Hd8VPV9HegDu+T54rQNSBCfb3O+gxyNm9dv7cqY/X0yjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009570; c=relaxed/simple;
	bh=Usq9sCSCikBPQhUUTGcQOf4Os2jnn00XF0prtJQSl6o=;
	h=Date:To:From:Subject:Message-Id; b=RsrbI1kZfnmkqrz9sTBjKBdbnIDFkxw3HJ9Rzm1FHwdf2tbWRCKlJedO5jTcCFxlc5AAuAcGJYAtUCYteSEE9feStRLb8e0tnozZDPy9Jl4zbKvAWQSOb+1aWvcG2XsVwSfF1IbYjhXmu/YmsZ6sG1Ml4h6rxCB/kRtYEvB+o9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfyodeSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfyodeSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CC3C113CC;
	Wed, 29 May 2024 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009570;
	bh=Usq9sCSCikBPQhUUTGcQOf4Os2jnn00XF0prtJQSl6o=;
	h=Date:To:From:Subject:From;
	b=bfyodeSKLYhPu4HlPyN+hvBdSM8SLJjDsd1hE3eecsXYuOKnTgbt92r1uh07I5Q1P
	 50rvoOWUitEirLoq7PWNQhLvGca+/Zyg/xv9ls52osQBKeRvqB2in1wYL7vOCZEKCf
	 vXfRVToP4DO5LxtEs63uH9qifhnBEmutvMk8d0xI=
Date: Wed, 29 May 2024 12:06:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch added to mm-unstable branch
Message-Id: <20240529190610.27CC3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: initialize page->_mapcount directly in __init_single_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/mm_init: initialize page->_mapcount directly in __init_single_page()
Date: Wed, 29 May 2024 13:19:04 +0200

Let's simply reinitialize the page->_mapcount directly.  We can now get
rid of page_mapcount_reset().

Link: https://lkml.kernel.org/r/20240529111904.2069608-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 -----
 mm/mm_init.c       |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page
+++ a/include/linux/mm.h
@@ -1206,11 +1206,6 @@ static inline int folio_entire_mapcount(
 	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
-static inline void page_mapcount_reset(struct page *page)
-{
-	atomic_set(&(page)->_mapcount, -1);
-}
-
 /**
  * page_mapcount() - Number of times this precise page is mapped.
  * @page: The page.
--- a/mm/mm_init.c~mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page
+++ a/mm/mm_init.c
@@ -568,7 +568,7 @@ void __meminit __init_single_page(struct
 	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
-	page_mapcount_reset(page);
+	atomic_set(&page->_mapcount, -1);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

