Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE891E496
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596243; cv=none; b=iqXZRZQz0wma6PYbcmvp9QcLGvXOvBTZ7q3WnwTQDq2X+5k2bj6j7IsQpOIrkl+79lHmf1KPnmv2TMkH6XnXFk+5aVPjPQ3vF6yzIdvGhhApkOQ/ALDimaHi5dyxVjoNN8ZZGcmfXF2jRh6kSS1n8efbM1W3ElTuWMHRzmsXsRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596243; c=relaxed/simple;
	bh=MkvuLBby8gRCWu1WO982+5AQYWwtxp6KNmQplojR9wI=;
	h=Date:To:From:Subject:Message-Id; b=AS5ebwgWTLW2SVN8ODtLvSoqvQjgHGnWanZDLjZsCgh3EtpCZwarjIlnRWaaXBM9Qer3TFg1aWpZmpaDNvArv8MAfq0RdOYckQOQ8xmR62OZpST/Zwws4YpmFxTcSO6IMOUEji73WxRm9TSjFIQziPPPGVNAGf6BaEaVN9OXnKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl0bhaHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl0bhaHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04824C433F1;
	Tue, 30 Jan 2024 06:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596243;
	bh=MkvuLBby8gRCWu1WO982+5AQYWwtxp6KNmQplojR9wI=;
	h=Date:To:From:Subject:From;
	b=hl0bhaHBIejPKRdofdvU8BIfNhSC304gaqs/pajpKpJGS74DIna3LE+Vuh6eJiZjT
	 8wCrYYEUYZC5QZCH+UUN5XZPjkZEwb97BgJ2Og3zuKad+f/74BhRZyecXxHjt8/e3z
	 priNZSFnQkZEZL0OBLzWdDwo2fbkcI8R6gJEfM7Q=
Date: Mon, 29 Jan 2024 22:30:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch added to mm-unstable branch
Message-Id: <20240130063042.04824C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: limit the suitable target page order to be less than cc->order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch

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
Subject: mm: compaction: limit the suitable target page order to be less than cc->order
Date: Mon, 22 Jan 2024 21:01:53 +0800

It can not improve the fragmentation if we isolate the target free pages
exceeding cc->order, especially when the cc->order is less than
pageblock_order.  For example, suppose the pageblock_order is MAX_ORDER
(size is 4M) and cc->order is 2M THP size, we should not isolate other 2M
free pages to be the migration target, which can not improve the
fragmentation.

Moreover this is also applicable for large folio compaction.

Link: https://lkml.kernel.org/r/afcd9377351c259df7a25a388a4a0d5862b986f4.1705928395.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order
+++ a/mm/compaction.c
@@ -1415,12 +1415,14 @@ static bool suitable_migration_target(st
 {
 	/* If the page is a large free page, then disallow migration */
 	if (PageBuddy(page)) {
+		int order = cc->order > 0 ? cc->order : pageblock_order;
+
 		/*
 		 * We are checking page_order without zone->lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
-		if (buddy_order_unsafe(page) >= pageblock_order)
+		if (buddy_order_unsafe(page) >= order)
 			return false;
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

