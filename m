Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34BC16F8F5
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272448; cv=none; b=KoEa98xEqsHS+1/jYYtBFFYpGX3RW+NJjeerVYBydKSQGblGV6tP/ULiHaNeUv5TKrh9bZFaWIGy7X0gS2C0oAcbXHfLJvgRv2BMUa3p7lJYbcslgTbwkAMumSEIRDuoVwgVDnPb+XGjZfg5piDHYL/LaO2FmwKM0vO99kcTP4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272448; c=relaxed/simple;
	bh=NMMrK5OXM1ewLQUxtmwxXjW/yPndvO+DVGq2Ftjzf4k=;
	h=Date:To:From:Subject:Message-Id; b=siUXVU7K3E360Ws0K0HoH7y22+1kSy40R1eUL9pRGaNk77yCa9AH0+4G2B3MnYHo1eXrk1vj+GLTyEtUOqVCriij6TQzie3tjhsqWgTpqvVps3kf9Q9y87nIG38kuA0AU1EdFFCjSGJXDrv7RS4mdYaZbNCBAhGMS7j8DrrR+po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J48+7fTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J48+7fTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2945CC32781;
	Wed, 21 Aug 2024 20:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272448;
	bh=NMMrK5OXM1ewLQUxtmwxXjW/yPndvO+DVGq2Ftjzf4k=;
	h=Date:To:From:Subject:From;
	b=J48+7fTgmxoQpFL18vVlf9mYR1ksyXCSTCApOEh/yQOzHtqlC8GjH8G+4SKVhuM4O
	 juOrtvNfLKHv/TmdOFwEwY0qBIam06acBKNp1ZI3yZnj8oExmOVDl8y08sFXvD4eKf
	 VbjyZOrQu7GBTvCOmzEiYbLflmrMFsJ0OJNFNQkg=
Date: Wed, 21 Aug 2024 13:34:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_has_private.patch added to mm-unstable branch
Message-Id: <20240821203408.2945CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_has_private()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_has_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_has_private.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_has_private()
Date: Wed, 21 Aug 2024 20:34:41 +0100

This function has no more callers, except folio_has_private().  Combine
the two functions.

Link: https://lkml.kernel.org/r/20240821193445.2294269-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-page_has_private
+++ a/include/linux/page-flags.h
@@ -1175,20 +1175,15 @@ static __always_inline void __ClearPageA
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
 /**
- * page_has_private - Determine if page has private stuff
- * @page: The page to be checked
+ * folio_has_private - Determine if folio has private stuff
+ * @folio: The folio to be checked
  *
- * Determine if a page has private stuff, indicating that release routines
+ * Determine if a folio has private stuff, indicating that release routines
  * should be invoked upon it.
  */
-static inline int page_has_private(const struct page *page)
+static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(page->flags & PAGE_FLAGS_PRIVATE);
-}
-
-static inline bool folio_has_private(const struct folio *folio)
-{
-	return page_has_private(&folio->page);
+	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
 }
 
 #undef PF_ANY
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch

