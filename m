Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553EB13B7BC
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719290019; cv=none; b=IZ31ajLIozB/lgLuIgEHfk/BRVio9+ah5kvDQNbOqXhdjat6F9A/HTT7gTr/X7aGzxiR4OzYZc4ZDHbBEFUZjxDYHUyazFgUEC0uTLBVUQ3hkLxHIculwAKsmPl5Lf4FQ1lZI1zTwgrKzTvheteY3phULszeVd/sO/ZbTIHm2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719290019; c=relaxed/simple;
	bh=YBlvYbhr1udKd7WIr+mYehD24FbshxG6ILApZc1G9Js=;
	h=Date:To:From:Subject:Message-Id; b=NselWrCvrH0AncaALxV9RT8maPYcBmTmMHRFBmO3OPbVuYS79/cF8MURMl4YfbBsx4l2z3nqU+Sg+/ZuHyXnvITbtEvl3BA+/CgCE9Grttk5btmEm3VIknQjqXST9hy9h8nhGsEOuEpW1jb5V+nZsayvMH5aA+aIpqP4EeAUrzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqP8KTwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqP8KTwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72C5C4AF09;
	Tue, 25 Jun 2024 04:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719290018;
	bh=YBlvYbhr1udKd7WIr+mYehD24FbshxG6ILApZc1G9Js=;
	h=Date:To:From:Subject:From;
	b=rqP8KTwaXh4oPWhOymt/UbAteLK2pLNe3V++B33fWIadcwqyVFgFJv4L4C2hGQG+Q
	 1a60H53Beac1SUiyCRrpujDXpi9AKbk+YfXA94uqFx/KI56bvxe1dh/VMPljotdJu6
	 96V988GIDZyQEUFhl6G3J7N2EinXtfArJLQ15Zkw=
Date: Mon, 24 Jun 2024 21:33:38 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch removed from -mm tree
Message-Id: <20240625043338.C72C5C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch

This patch was dropped because it was folded into mm-mm_initc-simplify-logic-of-deferred__pages.patch

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
mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

