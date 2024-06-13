Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CDA13959B
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 20:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311311; cv=none; b=DmFNKX+fW4o67oI8zwLPoM1KiZM+ny1meK31vPb7hFubyjlLqE0T9BbyvH/TjUsHEGdY7JjZmcGMPRjLXnxXyI3qiBrdJ7XPy870f0n5X+Yw6n5Jnir/4PuCHvJYnvQX2nf49vSx0zFCqTmysrLfOymbnRQSv7b1u0NYgxB5qMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311311; c=relaxed/simple;
	bh=Apj6S8kEm3hVxZ+Q+tmEjs+kcEh1Zjsfw1rP4eMtWqE=;
	h=Date:To:From:Subject:Message-Id; b=FpqzjBWCCeV9S/5bZV3XPu6GasF4DacuI3TKJ+Zse2nEa+sFjraoCDJXCM0k56OpF/NCP6SdNPFwYvdosbpkwHeGr3vKSVK5TSB/5hkAYZLZkZhaxqqGm2AG3vF7MJ04C9JLqPsPUVrZP1+ORS73e92vI2cQXVjCqohDktg9+9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDn0JUBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDn0JUBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D623C2BBFC;
	Thu, 13 Jun 2024 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718311311;
	bh=Apj6S8kEm3hVxZ+Q+tmEjs+kcEh1Zjsfw1rP4eMtWqE=;
	h=Date:To:From:Subject:From;
	b=RDn0JUBJt4LjFv2GgDiPF1845VHoe2QLnY2dM5U6fgwc/KHekZJZ6+JBwP5BHVbvv
	 ZfuhJqVYLutHkafob8ULyEulpt3NCA3ovmTk2m9t+wLGBASzfjBPQNh9m2bdgXsGoY
	 KB0968p4d8ebEOv6g49Y2J0b1NHJxAj0iMwB1yjo=
Date: Thu, 13 Jun 2024 13:41:50 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch added to mm-unstable branch
Message-Id: <20240613204151.3D623C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch

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
Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
Date: Thu, 13 Jun 2024 11:45:25 +0000

adjust function declaration indention per David

Link: https://lkml.kernel.org/r/20240613114525.27528-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-simplify-logic-of-deferred__pages-v2
+++ a/mm/mm_init.c
@@ -1923,7 +1923,7 @@ unsigned long __init node_map_pfn_alignm
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-				       unsigned long nr_pages)
+		unsigned long nr_pages)
 {
 	struct page *page;
 	unsigned long i;
@@ -1967,8 +1967,7 @@ static inline void __init pgdat_init_rep
  * Return number of pages initialized.
  */
 static unsigned long __init deferred_init_pages(struct zone *zone,
-						unsigned long pfn,
-						unsigned long end_pfn)
+		unsigned long pfn, unsigned long end_pfn)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = end_pfn - pfn;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch
mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch

