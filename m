Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557A13A265
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712262701; cv=none; b=IJ9E7oeKxMs+XvWrmBMu0f8cLleceCtCyKb63XYEO4muN9QT9RjX6wlIV5YQluRWIokpC0J1Z8H0gxiXMhfg64C6QrbkCNaOnruY0kla8P73JBIDenY28bMVjsxMMCttnYkTmEQXA1rT7hxILLo5OP71XdLyP130eaKhKCiE4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712262701; c=relaxed/simple;
	bh=SrE7X5C2KgmUmrApIyRfVSVh+iqPr5hrTFChdQh3UMU=;
	h=Date:To:From:Subject:Message-Id; b=JXkK3gBwqc+S30jKOw2FnoV6whtXprxvj8oQYaoXhBVYxksYGt+UnDoR3QLuwZ5mqaPWD57OvBxGW3kLkRuuJ+kI8oglIF4m1z7tgVIqonI0x7KrX6LHZNM5Aa8Jvvsz8RsX9kbR0vKeRihM1YdBx2aho8qYj69x/zJxkKHOhJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YQJBXlW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YQJBXlW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1211FC43390;
	Thu,  4 Apr 2024 20:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712262701;
	bh=SrE7X5C2KgmUmrApIyRfVSVh+iqPr5hrTFChdQh3UMU=;
	h=Date:To:From:Subject:From;
	b=YQJBXlW6Y7/Ni4xwzVK5tZoBC2iCwuiO+gW2OmRsH4DQyCoFCiMi1XrKJ5qA6c8X6
	 Qslw9VkMYHiOpp4DDkf5HM3lCIU8u+Wv7LktEBgzY1C1tJ8Aa+Exf5gFXnCi0rz/Mw
	 w8XtYuwXsjpPBq4z/4BzOFrDgiws+7/gpxPyvjto=
Date: Thu, 04 Apr 2024 13:31:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,peterx@redhat.com,nathan@kernel.org,kernel@xen0n.name,jgg@nvidia.com,david@redhat.com,chenhuacai@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch added to mm-unstable branch
Message-Id: <20240404203141.1211FC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
Date: Thu Apr  4 01:27:47 PM PDT 2024

simplify PageAnonExclusive(), per Matthew

Link: https://lkml.kernel.org/r/Zg3u5Sh9EbbYPhaI@casper.infradead.org
Cc: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
+++ a/include/linux/page-flags.h
@@ -1096,11 +1096,10 @@ static __always_inline int PageAnonExclu
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	/*
-	 * Allow the anon-exclusive check to work on hugetlb tail pages.
-	 * Here hugetlb pages will always guarantee the anon-exclusiveness
-	 * of the head page represents the tail pages.
+	 * HugeTLB stores this information on the head page; THP keeps it per
+	 * page
 	 */
-	if (PageHuge(page) && !PageHead(page))
+	if (PageHuge(page))
 		page = compound_head(page);
 	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

