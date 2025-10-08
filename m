Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B16A286413
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 01:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759887594; cv=none; b=q94S6XmxMj3pDCASAFO/gZmUESTD+Rkp5ng62EO3tY/e1hYy1xYu7e7ABxhAww3CCRJsgm8QJlzxSA9sanlBxoClh/mq+5d+otk2uMxQbDCdxi/tG3t+6UEafWLdB6u55FREUEAag8JISLXC4YZaSrL/7IS7MG17XUiFBdcm/68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759887594; c=relaxed/simple;
	bh=xmiXKLH+b5jMDGuUVleP/o+girdxzKMZim7qoHbprXU=;
	h=Date:To:From:Subject:Message-Id; b=M4AsflRBBcHQr6Pd/LE1AtIMzdgV2sJHDH9pZtFCSb9KhpBRK9irMH4YBsVcSNQToMnoyXk9G3ygbfNTUUaNGgKAnmu7i5zau+0Y0AiDoXpt8ZfX0SzRFdfe+IsNWpife5t8MKsDW3xTpi7vsmm/EiS92e4+LcRjhjOKC4gDT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UcjJY5gH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UcjJY5gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ED4C4CEF1;
	Wed,  8 Oct 2025 01:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759887593;
	bh=xmiXKLH+b5jMDGuUVleP/o+girdxzKMZim7qoHbprXU=;
	h=Date:To:From:Subject:From;
	b=UcjJY5gHgI/v6+uZxpfbb9VX1luZAd2L4wjWdPAIFT4pty+bP3ZbjBQWdDhKvxG7j
	 HDC91hSSY/Y87YlU+ocr7cfuihQlWuVSeAI0xRv4DoR9KJX0pV383ThNIjH89X7tqW
	 RtGJMpPDcz8dHhJSai4losL3gq9rOoiyi15eKOLo=
Date: Tue, 07 Oct 2025 18:39:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch added to mm-new branch
Message-Id: <20251008013953.95ED4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: check the range to pageblock_pfn_to_page() is within the zone first
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch

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

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch

