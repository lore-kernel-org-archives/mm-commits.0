Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC95276058
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752579; cv=none; b=uZ1BLtofDUGvnMYcH/7f5bmwVn/u9RVxZBSW3pWFzkxsZLF3RYFoFk+AxhDaEb18L1XdVLw7WUdGrpsk0wneArmlBoqgHo014joI+huh4UO4J7BnvWTxKheFVXt9V5kAjgtrjn90ZzGKINlxbRtTiNjRiCdRYALbSh1EoNp/jC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752579; c=relaxed/simple;
	bh=EjurXETFboT5dhRhiRdWcBqiVOlVFkkoIezRESyGKYQ=;
	h=Date:To:From:Subject:Message-Id; b=FjihSlFLQFYWVxK9EKCRtClypvW55gRNXFcHxRI0ILXeOk2uxaYkxRPMlV9eJUuZIWas9qtcKvfoSMkhIb1N5qH9aNheM7ody3nu/4rXnjnJKbbYUhbU3IqN+2C/LFJWwB68nK5odO4jIEyJIy97e2/Gmd9J9ydQ6cIus0QZZK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JlidQPVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JlidQPVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A083C4CEE7;
	Wed, 24 Sep 2025 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758752578;
	bh=EjurXETFboT5dhRhiRdWcBqiVOlVFkkoIezRESyGKYQ=;
	h=Date:To:From:Subject:From;
	b=JlidQPVhg5flvGkdvdUdYp2G3IvenNg2E3TZ1Xbm+/crxpwAXyPHGdyCDWHE6wUP3
	 5fg63ae1ZCZLlUgcf81usUHbg8WAwiDmNjWJDLhTvaC//PUtAFqYTMqf1Yu4XjfBld
	 n/pbaJl+O+ptqvw+IRXWuYKrOp1i9vX6iPqdx5Ds=
Date: Wed, 24 Sep 2025 15:22:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,anshuman.khandual@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch removed from -mm tree
Message-Id: <20250924222258.6A083C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix alignment for alloc_contig_pages_noprof()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-alignment-for-alloc_contig_pages_noprof.patch

This patch was dropped because it is obsolete

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

