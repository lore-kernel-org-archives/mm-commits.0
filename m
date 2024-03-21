Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F71350FD
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055013; cv=none; b=Tf3aCyqlfkqf5Y7zeGoMuIoxbXZHQzH7fXmtFK5CsnD682PeHqb7thhfP+Dg52LcWzt22bkVoRKJSmUsP28KBFRkbOIDuXUr6FTQ3t+lZfUQPjO9lRgCjYx8T3PGm4/1Wq1p/zhRJD+NZgyBA8j2rizXjk0n+DpLLFjRuUel+O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055013; c=relaxed/simple;
	bh=/HdnGsfcM4VsTDGYwHJcavnREe9A0M+iFDMHZ0mDOn4=;
	h=Date:To:From:Subject:Message-Id; b=MzZ9RFhRSORNcay0iD1A2l9FRFMoQReWv4YCdu77BHIpoVOqLnhvDndf09Ytp4QNcCAoid8F8Ujm5Br6m4vwKGq0HaJMdGU+RooCv+7REmvmcykGqte5uZ8jFHk6tRy70X2j2w7vvl3LIV3CyK7gfnXGZgLOwnb7WJBHd83PUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krlmUQZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krlmUQZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145EAC43390;
	Thu, 21 Mar 2024 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055013;
	bh=/HdnGsfcM4VsTDGYwHJcavnREe9A0M+iFDMHZ0mDOn4=;
	h=Date:To:From:Subject:From;
	b=krlmUQZwS/ICW+UaNPcKOzC0X++2J74n8CbP13YjB0lWtAUUhhGobbyVu2vYbguSs
	 eXz1qop6zmQx8FhJABf21QGR6cZIy4jtsrt5Mpr4ep7pMms9FaiDE6cBW8qPfjrp5N
	 /UZ3NaaABQ97di5PkgDy0HP4PTdpjPDtx9byEugo=
Date: Thu, 21 Mar 2024 14:03:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch added to mm-unstable branch
Message-Id: <20240321210333.145EAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove a call to compound_head() from is_page_hwpoison()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch

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
Subject: mm: remove a call to compound_head() from is_page_hwpoison()
Date: Thu, 21 Mar 2024 14:24:44 +0000

We can call it only once instead of twice.

Link: https://lkml.kernel.org/r/20240321142448.1645400-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-a-call-to-compound_head-from-is_page_hwpoison
+++ a/include/linux/page-flags.h
@@ -1065,11 +1065,14 @@ static inline bool PageHuge(const struct
  * best effort only and inherently racy: there is no way to synchronize with
  * failing hardware.
  */
-static inline bool is_page_hwpoison(struct page *page)
+static inline bool is_page_hwpoison(const struct page *page)
 {
+	const struct folio *folio;
+
 	if (PageHWPoison(page))
 		return true;
-	return PageHuge(page) && PageHWPoison(compound_head(page));
+	folio = page_folio(page);
+	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
 extern bool is_free_buddy_page(struct page *page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

