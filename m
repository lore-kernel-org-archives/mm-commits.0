Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8B82E11B6
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 04:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756786357; cv=none; b=Ykgf4SqoDSDq4WWjyFd9+unZasPbHG98yutyddxeNd8UdyN73jo+Ll6kbSDo0xyGok3k9G/93/6xXk3rlCCDTMiOMl8FSDkduIphvCz3LiNwUz3EAzRfsxoLudglQqlznTNYvIUeZPwwnjKcdJga1yo8cKqhCVTSKJGhk0Tmdkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756786357; c=relaxed/simple;
	bh=bxAZ/lgSSXTkNceNtY2CtBkGosotgbQe03nnuOcoqVg=;
	h=Date:To:From:Subject:Message-Id; b=D6uzuCFU870MOwljEA1zXN4wdbubd/LbojVIMvAmh1B5SZL36awnZ37HfTxNqy2lnKNHzZvZEwTFuyiBiIO8kXJWEsJyUEvaUWaTct+jZVPpxLDAKwTn7pjTBmTtRwBCeTk5e1VEWZTXhTiZX4keD3iFA4+cNW4MczEwViEr87k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e9DXBTK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e9DXBTK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DEAC4CEED;
	Tue,  2 Sep 2025 04:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756786357;
	bh=bxAZ/lgSSXTkNceNtY2CtBkGosotgbQe03nnuOcoqVg=;
	h=Date:To:From:Subject:From;
	b=e9DXBTK8WTivFADVp045Nevay63VrvAJV4RPZEbbmTdVjSsZgmSdHFRyEYzCo7KlQ
	 cYvgVjATbix86MYFaLJrWizbQAocPxE7a825DOMhOPGo+VGJQdoC6cfIA98AodEyvW
	 EI21SiHNRXAJNnC+uryZNYa8DivMNA0V1YWXBhsU=
Date: Mon, 01 Sep 2025 21:12:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch added to mm-new branch
Message-Id: <20250902041237.62DEAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
Date: Tue, 2 Sep 2025 02:58:07 +0000

add comment on assignment of order

Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250902025807.11467-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
+++ a/mm/page_alloc.c
@@ -2033,6 +2033,12 @@ static int move_freepages_block(struct z
 /* Look for a buddy that straddles start_pfn */
 static unsigned long find_large_buddy(unsigned long start_pfn)
 {
+	/*
+	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
+	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
+	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
+	 * the starting order does not matter.
+	 */
 	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
 	struct page *page;
 	unsigned long pfn = start_pfn;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch
selftests-mm-check-content-to-see-whether-mremap-corrupt-data.patch

