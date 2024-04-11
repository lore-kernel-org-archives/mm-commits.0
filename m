Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5317617BC9
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868463; cv=none; b=HtCoWUfv7W5MKjpW8JsH2qFDEEorIuyBddy440yyqBCLmhGvvGgnmyWZMxRNr5pE1rqK2hjs25Ny1VZcnuBjvUzRz5Pj0YKcFz7T8GWmiduBeeo6res50TghQR9MGVTjwT7nPicICoLc1Xq6nl255Ks5kxsDcsts3tnLTnWfYiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868463; c=relaxed/simple;
	bh=gISWbHZxT03ooWPOLGzAqPy9bVJuCW0YdaXfhpRXtWE=;
	h=Date:To:From:Subject:Message-Id; b=QQefx3ikj6ESixwwYwJGtdJAT+Phy8eO2g0M8N25u0rDzeLB+78oywaO0kX2FXUGbz/QxDRXPEfKbRBdYcUyX6N1fnbEQWNCcYynazi006wYw4YyZTtETyw/0xNSx05soSKSnDe1TG/3uq5iE82ukKGQv6tvVo/edMjduKR0J/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K637YAvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K637YAvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0A5C072AA;
	Thu, 11 Apr 2024 20:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868462;
	bh=gISWbHZxT03ooWPOLGzAqPy9bVJuCW0YdaXfhpRXtWE=;
	h=Date:To:From:Subject:From;
	b=K637YAvD0DYR3LXZQID4IZGWTvT6SIlR62TVP+j3doM3uuZvSGRgy77KrGu7yILtV
	 d4+eL5f9YFYP5wK/+yuCqttcCljJxfeYl4APyINtDupV/BuctFNrK9Tz8jYiWMyPZV
	 y9IdNWNbaazB3gX4cWEeJWFOejGr0qlJuctg8UMA=
Date: Thu, 11 Apr 2024 13:47:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch added to mm-unstable branch
Message-Id: <20240411204742.BA0A5C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: replace set_page_stable_node by folio_set_stable_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: replace set_page_stable_node by folio_set_stable_node
Date: Thu, 11 Apr 2024 14:17:11 +0800

Only single page could be reached where we set stable node after write
protect, so use folio converted func to replace page's.  And remove the
unused func set_page_stable_node().

Link: https://lkml.kernel.org/r/20240411061713.1847574-11-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node
+++ a/mm/ksm.c
@@ -1094,17 +1094,11 @@ static inline struct ksm_stable_node *pa
 	return folio_stable_node(page_folio(page));
 }
 
-static inline void set_page_stable_node(struct page *page,
-					struct ksm_stable_node *stable_node)
-{
-	VM_BUG_ON_PAGE(PageAnon(page) && PageAnonExclusive(page), page);
-	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
-}
-
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
-	set_page_stable_node(&folio->page, stable_node);
+	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
+	folio->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
 #ifdef CONFIG_SYSFS
@@ -1519,7 +1513,7 @@ static int try_to_merge_one_page(struct
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
 			 * stable_tree_insert() will update stable_node.
 			 */
-			set_page_stable_node(page, NULL);
+			folio_set_stable_node(page_folio(page), NULL);
 			mark_page_accessed(page);
 			/*
 			 * Page reclaim just frees a clean page with no dirty
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

