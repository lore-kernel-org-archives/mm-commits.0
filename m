Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77A8827
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712963632; cv=none; b=gmX+QUz4laSVq02dUbW55//uhYfTivL/vAi5d8JicmYHTp2f4G2np8d0ZitR6HpzM+Ls0/xCfP5Mpm8etGvo8R/AzNoSxk/eBbGDAhSB4BKef2V5d0PMjoQHR9m+11CKoAJO9oWIfUeVBeblso/W5OEMC0qDeTRzg7G16t3g1d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712963632; c=relaxed/simple;
	bh=NjrKEp9zHhgYAHFj3IrhMdfMu+sxuHHq8wRwIPIHmw4=;
	h=Date:To:From:Subject:Message-Id; b=NVoLMCYdz8OjqJ2+hKT8j3W05paRrqIvAFpxk9+DSytTyGJYTBB/NzSyZn3F94kheub36uGmJV8V4fHBewhNEzO3w463YFr/MF8mltG0ozhBp83Hmr8zTo1woM1fFBx/nMALboJuHdjklhzLw0idDwVzYgDujfrWkWh7V49E4Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ExmElTbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ExmElTbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C077BC113CC;
	Fri, 12 Apr 2024 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712963631;
	bh=NjrKEp9zHhgYAHFj3IrhMdfMu+sxuHHq8wRwIPIHmw4=;
	h=Date:To:From:Subject:From;
	b=ExmElTbRaTjMarGQKu140tLHGjU1vqCDqQtm2L35WprouZ5kkHeKISaV+4cLS/+yI
	 qYHWc3e1b6U/Rm6+/I28r7zpCt2hxuSLZZGcMapMobDBJPg/T8wi2Nc4YRXflqTrCN
	 QZpEl1vB5dAsHPxbyAJAIc4b3ufecRzzt6Ht7dvY=
Date: Fri, 12 Apr 2024 16:13:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,ryan.roberts@arm.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch added to mm-unstable branch
Message-Id: <20240412231351.C077BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: allowing mTHP compaction to capture the freed page directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: page_alloc: allowing mTHP compaction to capture the freed page directly
Date: Fri, 12 Apr 2024 11:27:04 +0800

Currently, compaction_capture() does not allow lower-order allocations to
directly capture the movable free pages, even though lower-order
allocations might also be requesting movable pages, that can lead to more
compaction scanning.  And, with the enablement of mTHP, such situations
will become more common.

Thus allowing lower-order (mTHP) allocations of movable page types
directly capture the movable free pages can avoid unnecessary compaction
scanning, meanwhile that won't pollute the movable pageblock.  With
testing 1M mTHP compaction, it can be seen that compaction scanning is
significantly reduced.

                                   mm-unstable       patched
Ops Compaction pages isolated      116598741.00   120946702.00
Ops Compaction migrate scanned    1764870054.00  1488621550.00
Ops Compaction free scanned       7707879039.00  4986299318.00
Ops Compact scan efficiency               22.90          29.85
Ops Compaction cost                    73797.69       72933.48

Link: https://lkml.kernel.org/r/8118a5d66a034736a48433beddaca60ed78577c4.1712892329.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly
+++ a/mm/page_alloc.c
@@ -595,12 +595,14 @@ compaction_capture(struct capture_contro
 		return false;
 
 	/*
-	 * Do not let lower order allocations pollute a movable pageblock.
+	 * Do not let lower order allocations pollute a movable pageblock
+	 * unless compaction is also requesting movable pages.
 	 * This might let an unmovable request use a reclaimable pageblock
 	 * and vice-versa but no more than normal fallback logic which can
 	 * have trouble finding a high-order free page.
 	 */
-	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE)
+	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE &&
+	    capc->cc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
 	capc->page = page;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-3.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch
mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

