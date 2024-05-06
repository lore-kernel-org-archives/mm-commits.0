Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DDA19BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957046; cv=none; b=Jnh3eo0xZ/lWmO96UUcHyYnqMrLynILFgMF5u1AK6eJBr7kSKtqhrZfTWe0cQdz6ntIbsTy6y3uZ+myJ7KmuUIW+AxgD+ZDyecsgj+y/EtXTxPpEM3PibLefKVpLvEW2tU2ukHeK00sBydJpOPYvu/JYWjbEd1Bx6MZU8+J30Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957046; c=relaxed/simple;
	bh=lrZAH6gNhlrXnWqK+e/IEeiL2WLW190Rw0R1apMX97A=;
	h=Date:To:From:Subject:Message-Id; b=myR/ZVWLAbOg8LuCltuTq/A8mOe0B7A5ZJdRihUaGsicuhZzF1rHWFuba6z3HY9j7grvphqC9k0Sdr5rIhor+AX3PzlRfrnvkjGcysMnRSMJtLViEUdm3NDrzruP6z2yKjL10oaXvdgNEvHwkXfyYEv2XWl/KTIuG1V3OgwGwog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlpxyTyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlpxyTyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E9C113CC;
	Mon,  6 May 2024 00:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957046;
	bh=lrZAH6gNhlrXnWqK+e/IEeiL2WLW190Rw0R1apMX97A=;
	h=Date:To:From:Subject:From;
	b=NlpxyTyi2dxEwihiVFmHk8fXxu8p9grx2tUjsQywSFcObEnNdz2wxqMsLmyl3IYBe
	 E/uEHpA9RaHwCGmIh/IDfvdi/5b3DBad4j3wCi8BRbdJX2m+XSikI8+D7tKYJV0SIQ
	 jsV7ZkNM62GdQaXFMx1cyS/aUbsSEQQ/xIrdJE08=
Date: Sun, 05 May 2024 17:57:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,ryan.roberts@arm.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch removed from -mm tree
Message-Id: <20240506005726.0E9E9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: allowing mTHP compaction to capture the freed page directly
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


