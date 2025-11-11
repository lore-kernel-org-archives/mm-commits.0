Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEFE2F532C
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762903948; cv=none; b=OJ4s1pNxG+tmkfU0PYbKUtF0Beap+i/zu8IKjZXE1MucYdyXjMIjV5bZip+yieg2do4n9j/bCetmi45q1P+GPLu+ARJzaS90+LWNE23LY68bg/7QQQ2DC40uajM9nJ8Ki6emgjC+d/KKo1T9yisyW3LZsb9Io/KS2Oo7fD+a5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762903948; c=relaxed/simple;
	bh=qThd/XtumR8rd0anOMU0Er+EQANdShvO0o4ShOpLg48=;
	h=Date:To:From:Subject:Message-Id; b=jh9KTQGKqDEaF3vQeS4TCobTRcwGyXX0t3IG0xEjgDLLGKyYv4HM9hjzpQ0CP42h+iAFs4RrIGK5+3hELvoeBdrUVaTxjd+d2TcM4Pkk2ICfKVrnlifp7RvS3JDtPTM3bReYZmZH3YrLK/p7Hfj/CKVFLSSkyw8H17WedKDUXm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SgztZDfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SgztZDfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8BFC4CEF5;
	Tue, 11 Nov 2025 23:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762903948;
	bh=qThd/XtumR8rd0anOMU0Er+EQANdShvO0o4ShOpLg48=;
	h=Date:To:From:Subject:From;
	b=SgztZDfClZ8v53bvBNVH4E8VNbd2CA36EKA3tzenlTluTD7r60H7fmHViSy/gT7K0
	 56oT5gyKUPvuo1xD5XOM4uGqVxMYH7PhXA+QjoF5C6sSRsxoazRRZM5FS0+3DvS/Oi
	 E+/D3sCY1oDaUPmrXOqclDLaMnpNhJCgYrj5vs8o=
Date: Tue, 11 Nov 2025 15:32:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch removed from -mm tree
Message-Id: <20251111233228.3E8BFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: check the range to pageblock_pfn_to_page() is within the zone first
has been removed from the -mm tree.  Its filename was
     mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/compaction: check the range to pageblock_pfn_to_page() is within the zone first
Date: Thu, 2 Oct 2025 03:31:39 +0000

While reviewing isolate_migratepages_range(), I noticed a discrepancy: the
page range passed to pageblock_pfn_to_page() is different from the range
passed to isolate_migratepages_block().

This difference creates a potential issue: pageblock_pfn_to_page() might
incorrectly confirm that the range is entirely within the same zone, but
isolate_migratepages_block() could then proceed to isolate pages that span
two different zones.  This is unexpected behavior.

Further investigation revealed that pageblock_pfn_to_page() contains an
optimization for zones marked as contiguous.  This optimization is buggy,
as it causes the function to assume a range is within the same zone even
if the PFNs actually cross a zone boundary.

To resolve these issues, two patches are introduced:

Patch 1: Check the range belongs to the zone first.

Patch 2: Pass the correct range to pageblock_pfn_to_page() to ensure
consistency between the check and the isolation steps.


This patch (of 2):

The function pageblock_pfn_to_page() was introduced by commit 7d49d8868336
("mm, compaction: reduce zone checking frequency in the migration
scanner").  At that time, it had no requirement that start_pfn and end_pfn
had to be contained within the zone boundary; the only requirement was
that they were in the same pageblock.  Therefore, pageblock_pfn_to_page()
would be called with a PFN (Page Frame Number) that wasn't checked against
the zone boundary.

However, after commit 7cf91a98e607 ("mm/compaction: speed up
pageblock_pfn_to_page() when zone is contiguous"), pageblock_pfn_to_page()
may incorrectly assume a range is valid and belongs to a contiguous zone,
even if the range is outside that zone's actual boundaries.

For instance, in fast_isolate_freepages(), min_pfn is assigned using
pageblock_start_pfn() and passed to pageblock_pfn_to_page() without
checking it against zone_start_pfn.  Similarly, end_pfn is often not
checked against zone_end_pfn().

To make this function robust, the range must be checked to ensure it is
within the zone boundary first.

Link: https://lkml.kernel.org/r/20251002033140.24462-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251002033140.24462-2-richard.weiyang@gmail.com
Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/internal.h~mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first
+++ a/mm/internal.h
@@ -724,6 +724,9 @@ extern struct page *__pageblock_pfn_to_p
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
+	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
+		return NULL;
+
 	if (zone->contiguous)
 		return pfn_to_page(start_pfn);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch

