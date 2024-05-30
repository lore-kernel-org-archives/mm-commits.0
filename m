Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB9F46433
	for <mm-commits@vger.kernel.org>; Thu, 30 May 2024 19:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717097619; cv=none; b=LpBuNG2EhekPW5Rw8hqdfAJI0V/XX719g1CrFYGEXKDjeRXbzQ3Yz1O0ORuD9AV1CuVnXbKO590yFDErrt/5IGDvPiL2LwexC3DhY3skGaFlHclbXrLz1XOjFiR6p+1VIDg4EtGgeRPz+BnER5U4Jo3/kTJevYdfm8gxqI7oz1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717097619; c=relaxed/simple;
	bh=O44a3zNefkljqxwyX5/EzFABQ+axfdRC7BEASXXajU0=;
	h=Date:To:From:Subject:Message-Id; b=LiLMs/f9GwPVtGEExMdiRdjBkIHs4t6HYzwIpu+ADxNR5j0LkHMknuIm8eiwcqH3+9bTf4ahYMXPPXvKe67gSGrXuW8zTqcDRTu9p+4IqaWrTjAWWG3saLWaMUk1uxzsNSM6eeSdf+I2WqfoPj/MoW5Fi5rRkOcwkLPpjRufgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TmALGrAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TmALGrAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E50C2BBFC;
	Thu, 30 May 2024 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717097619;
	bh=O44a3zNefkljqxwyX5/EzFABQ+axfdRC7BEASXXajU0=;
	h=Date:To:From:Subject:From;
	b=TmALGrARMs64d+tclxE1hITCkZsZswTMyj6BsHOYWipPVoq/iVNqFYb2HH7FHY+R3
	 8dkuEbR6VJFXk7PxdGL9fEKiPikFkly/MNf4RDeGfYtHL1e1BSPAVSfNfp+/KiXKe9
	 6Pmg0/02Idus+wV5Ty4ODDExloB4591/kJ9UWdWg=
Date: Thu, 30 May 2024 12:33:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch added to mm-unstable branch
Message-Id: <20240530193339.46E50C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()
Date: Thu, 30 May 2024 10:14:27 -0700

By using a folio in scan_movable_pages() we convert the last user of the
page-based hugetlb information macro functions to the folio version. 
After this conversion, we can safely remove the page-based definitions
from include/linux/hugetlb.h.

Link: https://lkml.kernel.org/r/20240530171427.242018-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +-----
 mm/memory_hotplug.c     |   11 +++++------
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages
+++ a/include/linux/hugetlb.h
@@ -616,9 +616,7 @@ static __always_inline						\
 bool folio_test_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		return test_bit(HPG_##flname, private);		\
-	}							\
-static inline int HPage##uname(struct page *page)		\
-	{ return test_bit(HPG_##flname, &(page->private)); }
+	}
 
 #define SETHPAGEFLAG(uname, flname)				\
 static __always_inline						\
@@ -637,8 +635,6 @@ void folio_clear_hugetlb_##flname(struct
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
 folio_test_hugetlb_##flname(struct folio *folio)		\
-	{ return 0; }						\
-static inline int HPage##uname(struct page *page)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
--- a/mm/memory_hotplug.c~mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages
+++ a/mm/memory_hotplug.c
@@ -1731,8 +1731,8 @@ static int scan_movable_pages(unsigned l
 	unsigned long pfn;
 
 	for (pfn = start; pfn < end; pfn++) {
-		struct page *page, *head;
-		unsigned long skip;
+		struct page *page;
+		struct folio *folio;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1753,7 +1753,7 @@ static int scan_movable_pages(unsigned l
 
 		if (!PageHuge(page))
 			continue;
-		head = compound_head(page);
+		folio = page_folio(page);
 		/*
 		 * This test is racy as we hold no reference or lock.  The
 		 * hugetlb page could have been free'ed and head is no longer
@@ -1761,10 +1761,9 @@ static int scan_movable_pages(unsigned l
 		 * cases false positives and negatives are possible.  Calling
 		 * code must deal with these scenarios.
 		 */
-		if (HPageMigratable(head))
+		if (folio_test_hugetlb_migratable(folio))
 			goto found;
-		skip = compound_nr(head) - (pfn - page_to_pfn(head));
-		pfn += skip - 1;
+		pfn |= folio_nr_pages(folio) - 1;
 	}
 	return -ENOENT;
 found:
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-remove-setclearhpage-macros.patch
mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch

