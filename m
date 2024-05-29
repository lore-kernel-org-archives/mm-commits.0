Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACA815D5B9
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009567; cv=none; b=Wjh6XSUh0RFeejE+dY6jkmzuHp7GakGef/cifxpUulfe/XwkJyGcZOeKfKLAyPqCWIzfl23fDdkgCWpURVp8xRJxnTKxJuA0DIQyjoEDAojLigWMZIQr47b45hPCrXNofynBHqBFLU73RZIzXr+Ntfny/cR5FfRcDlf7okX+SDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009567; c=relaxed/simple;
	bh=sVTdmF9QsAJ7N0BrC9Z2S4TZhGadq4RErrIIF7Wrqs8=;
	h=Date:To:From:Subject:Message-Id; b=MdcDdWdHn7scLaUU07088dVBqtkfGyW2Daiv1fJvQuDGnbSX5HLfFKErEK768uiYUepamIGnhQwW/gj3nIA2WHPshhcrfmFkI2nv0bEpuTdcHzRxu38//jbufEMPb5/H8kuzeQCX2WtGQll0/8Q/W4DjlqXyGUD47DFZ2AiXngU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jPO3imaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jPO3imaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22205C113CC;
	Wed, 29 May 2024 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009567;
	bh=sVTdmF9QsAJ7N0BrC9Z2S4TZhGadq4RErrIIF7Wrqs8=;
	h=Date:To:From:Subject:From;
	b=jPO3imaID4inGFdLX9VlDtIlK2rqRijfB2kSKZhtpQE0Tt8ln8CkOK113oBz4HrJK
	 7L3eV1//xu2imvPZsthedPODovWFFqCzMW3L0c9U1Sr3LhnBiIS+ZQ5XT7/vXtAemb
	 BQCao5KxjshOeaSmE6nM5awY3vejY5J7lkTa84G8=
Date: Wed, 29 May 2024 12:06:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch added to mm-unstable branch
Message-Id: <20240529190607.22205C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clear PageBuddy using __ClearPageBuddy() for bad pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch

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
Subject: mm/page_alloc: clear PageBuddy using __ClearPageBuddy() for bad pages
Date: Wed, 29 May 2024 13:19:02 +0200

Let's stop using page_mapcount_reset() and clear PageBuddy using
__ClearPageBuddy() instead.

Link: https://lkml.kernel.org/r/20240529111904.2069608-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages
+++ a/mm/page_alloc.c
@@ -498,7 +498,8 @@ static void bad_page(struct page *page,
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
-	page_mapcount_reset(page); /* remove PageBuddy */
+	if (PageBuddy(page))
+		__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
@@ -1346,7 +1347,8 @@ static void check_new_page_bad(struct pa
 {
 	if (unlikely(page->flags & __PG_HWPOISON)) {
 		/* Don't complain about hwpoisoned pages */
-		page_mapcount_reset(page); /* remove PageBuddy */
+		if (PageBuddy(page))
+			__ClearPageBuddy(page);
 		return;
 	}
 
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

