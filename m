Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C2B2BE653
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422484; cv=none; b=LvZbnKkDWdtmKuH/MBNJh6J95MxGWQ4wvAWihghXmrpaA3qZRIFfFqwNkhNw60sFj8dYz5/3VgbXl7pJ1QSblQIZ0aHeAHw+8ArZ+ONOaX/Cje4KuYhyYCBS0/Vdm9XJeJItByM3/yjvvBnN2M0xMQ8DkxtmoSQQuz9ZidcZnA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422484; c=relaxed/simple;
	bh=eSeUM7Rhlv7gjqTEwCemqYFmyrxtXGPO3Zo85CZGGP0=;
	h=Date:To:From:Subject:Message-Id; b=FRF6ktN3eZh5flUMWWlyNW+5GelsdcbKLkmwy9TpkwLJVLf+mLYlJ08+J6r2Rh1MVxoPUXCtzSIsis0QY82y0WbkTDLe6aqLmtx2fWS54ecA2xv73W19DgDbJieaJoYCZs8+8oZu4u6PizxrTNe5UEdxtCaSxN0cWoZesYy5YMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1t5Hy4G5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1t5Hy4G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DEDC4CEEB;
	Thu, 28 Aug 2025 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422483;
	bh=eSeUM7Rhlv7gjqTEwCemqYFmyrxtXGPO3Zo85CZGGP0=;
	h=Date:To:From:Subject:From;
	b=1t5Hy4G5Xu+zqx2UZ7DPGfqg51QNf3zmAe4K2LVgSdBAl6FBFqBLyeURf0L37fIUQ
	 oMd727HW6hrKCDpfWfv4xQyxvULEKZeQ6bEvkSBmCqQAjTXymn4HK1dMOs+u3zIoMb
	 kH2LrngLHLu2xSA8mTJ7uxGE1Hp5vjySNHWM9nKk=
Date: Thu, 28 Aug 2025 16:08:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch added to mm-new branch
Message-Id: <20250828230803.C1DEDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: find_large_buddy() from start_pfn aligned order
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch

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
Subject: mm/page_alloc: find_large_buddy() from start_pfn aligned order
Date: Thu, 28 Aug 2025 09:16:18 +0000

We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
While if the order is less than start_pfn aligned order, we would get the
same pfn and do the same check again.

Iterate from start_pfn aligned order to reduce duplicated work.

Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order
+++ a/mm/page_alloc.c
@@ -2033,7 +2033,7 @@ static int move_freepages_block(struct z
 /* Look for a buddy that straddles start_pfn */
 static unsigned long find_large_buddy(unsigned long start_pfn)
 {
-	int order = 0;
+	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
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

