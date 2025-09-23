Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9473B1CAB3
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758598223; cv=none; b=DnFdtVa5iclMVogUprkm9F3vMEY1eMIv5/erFnmK5nHqglcjfBdJOgq6gYq0cvMx0FxTXz0/NggCNNwH62cof3LiG1Z+lYiYBiIuNASw82bQW2G/VszEzyDN1o2qg495SkTaxZxKHeYQcgbpT16XO/RTUN3p//IM2Sf+PTesv5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758598223; c=relaxed/simple;
	bh=eTsQsfbdLboIFItguqIWwH9k2aZP2XPHXz2BaYXFUlg=;
	h=Date:To:From:Subject:Message-Id; b=oXs6kPPeqpIKPQT/JaPKVgKnxHD2mNT+Y38f85T1WDMTYHAwSHju/A0TbTvNKSyvQ4S9q6Q1BKPuzmqrkXXuu1At8XP0C8WLMkZBHslKWgBReWsQo2UMmO/G5KY8IuyqhmWgI8i8Hklkp2Uop9VoESNA1zPxACDv0Gk1zd9rnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CvHdieig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CvHdieig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEEAC4CEF0;
	Tue, 23 Sep 2025 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758598223;
	bh=eTsQsfbdLboIFItguqIWwH9k2aZP2XPHXz2BaYXFUlg=;
	h=Date:To:From:Subject:From;
	b=CvHdieigJTaTijX7heX0Ozt5XqvDMxyYK6oK/Sh17IRC51KIvHo9r6pcpl/rnjZtw
	 btLzAVlCoXzPC1DvUsk7kHEuTppAeagks6ev351We7XhF05BBrDBu86wX6jzS4DV5W
	 YE3epUmv9IPb29VnRkQbRnN25O6pTrF3ahrr4ZRo=
Date: Mon, 22 Sep 2025 20:30:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,anshuman.khandual@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch added to mm-new branch
Message-Id: <20250923033023.0AEEAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix alignment for alloc_contig_pages_noprof()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch

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
Subject: mm/page_alloc: fix alignment for alloc_contig_pages_noprof()
Date: Tue, 23 Sep 2025 00:19:43 +0000

Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()") introduced
generic method for alloc_contig_pages().  But the alignment calculation
seems wrong.

Since ALIGN() only accepts power of two values, while nr_pages could be
any positive one, the result is not defined.

Use roundup() to calculate the correct alignment.

Link: https://lkml.kernel.org/r/20250923001943.2479-1-richard.weiyang@gmail.com
Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof
+++ a/mm/page_alloc.c
@@ -7098,7 +7098,7 @@ struct page *alloc_contig_pages_noprof(u
 					gfp_zone(gfp_mask), nodemask) {
 		spin_lock_irqsave(&zone->lock, flags);
 
-		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
+		pfn = roundup(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
 			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
 				/*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch
mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch

