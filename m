Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C8538FA6
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273422; cv=none; b=WmUx14c+Z9y2llA7NifD5y5Ya0jhKn3ncE1ZrJAVDFmsMs2JP9wpZ6agBwSEZQJiEYFfP4j9AkNwInbKpmJl1+1P+7ukhsqJb0TuKPckYnjxtmYGBwHMyJ6ldYNvANMmpGm39ICu0djEZRhoKehV42Dr1fyozRFvXFqBIf5kdH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273422; c=relaxed/simple;
	bh=fLTK2ScFr1wY/ccpOdmz1FwK0isgiPCVqhmN605Jcy0=;
	h=Date:To:From:Subject:Message-Id; b=esMgalu1O63n3BaELaxK0NFxU+npzlItmN4aA6QR0hpQrnfGF3zLiT0ClGPDb8zlrHP2Rd8bzEPg38TxgZfSs/GNE0FaarH27IOa1gvgzHsAEJjtzpiafgNodNymooMCq1CN+Kcw8UX/f/jE0EFk1Tasc4ge33BRWROH/NIZqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QUl5eytW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QUl5eytW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E15C4CEDD;
	Tue, 18 Mar 2025 04:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273421;
	bh=fLTK2ScFr1wY/ccpOdmz1FwK0isgiPCVqhmN605Jcy0=;
	h=Date:To:From:Subject:From;
	b=QUl5eytWOcn2E9WG3g4staZPkBHqWhXwcqRVCWYIIa1KjLqoug0k2zKDzJ4ezkWiX
	 iMKzYkG+mFjALK5rK5ESLQ0FRxbaxx4M34YIBjJV8C8pCUk153gTe+O/FNl1JC15U+
	 GGAOqv6onZ6J1iartVhfAySY/2ojnt/NTFJyNz6Q=
Date: Mon, 17 Mar 2025 21:50:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch removed from -mm tree
Message-Id: <20250318045021.C8E15C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: push watermark into compaction_suitable() callers fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch

This patch was dropped because it was folded into mm-compaction-push-watermark-into-compaction_suitable-callers.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: compaction: push watermark into compaction_suitable() callers fix
Date: Sat, 15 Mar 2025 21:28:16 -0700 (PDT)

Stop oops on out-of-range highest_zoneidx: compaction_suitable() pass
args to __compaction_suitable() in the order which it is expecting.

Link: https://lkml.kernel.org/r/005ace8b-07fa-01d4-b54b-394a3e029c07@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-push-watermark-into-compaction_suitable-callers-fix
+++ a/mm/compaction.c
@@ -2416,7 +2416,7 @@ bool compaction_suitable(struct zone *zo
 	enum compact_result compact_result;
 	bool suitable;
 
-	suitable = __compaction_suitable(zone, order, highest_zoneidx, watermark,
+	suitable = __compaction_suitable(zone, order, watermark, highest_zoneidx,
 					 zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
_

Patches currently in -mm which might be from hughd@google.com are

mm-compaction-push-watermark-into-compaction_suitable-callers.patch

