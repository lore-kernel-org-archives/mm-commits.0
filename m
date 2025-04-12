Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DCADDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417704; cv=none; b=Z8C3LO8k1tUIxaaCsTr5PMTv42yedGZaGga/KyyU7fWfKbrxVT+CYERGXQTTtkQNNmZ+/AJbKF1/EZ8C6AnGkylfaIqW6gZusdAp1E53Oe9P428GG8qn7lNNnLq973nbrb/YDGlcDX8bg27KHgjlL7UDsHzPNuIdOGxuwSBHBsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417704; c=relaxed/simple;
	bh=bqIOAibhJKyw9l8omgSZiQLGYQiJnWC+ciuzVnT3dbs=;
	h=Date:To:From:Subject:Message-Id; b=i4zmlvISkGmf+sOiLNe6ay6DeSbfHhNSTCZBL6yce4gDnWSKrrgHETj42E+DUIUr87WiwJ6CrQUBNr4qgX0lQZVoNSVVz+Rlt9cCbh4REbOhFM2DcG6dlDVheuZws9gEIg3T8oa8mwj2Kq8SZqMWMX3sFNSt6xEQ5dj1UCW52QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CYrvoFKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CYrvoFKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1770FC4CEE9;
	Sat, 12 Apr 2025 00:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417704;
	bh=bqIOAibhJKyw9l8omgSZiQLGYQiJnWC+ciuzVnT3dbs=;
	h=Date:To:From:Subject:From;
	b=CYrvoFKgT+xttri41sOBrKlXTpiFhAiD6r8CqGKU3RcXpsp9fcoMUpbxUpeHXHnHI
	 mjUghKAisSqoyIwJ2CQo660oCxmMPyRmBj9BygBjd6ktuwI6bHoxMC2ldd8ecX3GY8
	 63sIEnrSv4l6qEGmqjgSCK//rqyzA8mhZ/kRhv/k=
Date: Fri, 11 Apr 2025 17:28:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,linyunsheng@huawei.com,jackmanb@google.com,carlos.song@nxp.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch removed from -mm tree
Message-Id: <20250412002824.1770FC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk() fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch

This patch was dropped because it was folded into mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk() fix
Date: Wed, 9 Apr 2025 09:56:52 -0400

reset rmqueue_mode in rmqueue_buddy() error loop, per Yunsheng Lin

Link: https://lkml.kernel.org/r/20250409140023.GA2313@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Carlos Song <carlos.song@nxp.com>
Cc: linyunsheng <linyunsheng@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2
+++ a/mm/page_alloc.c
@@ -2979,7 +2979,6 @@ struct page *rmqueue_buddy(struct zone *
 {
 	struct page *page;
 	unsigned long flags;
-	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
 	do {
 		page = NULL;
@@ -2992,6 +2991,8 @@ struct page *rmqueue_buddy(struct zone *
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
+			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
+
 			page = __rmqueue(zone, order, migratetype, alloc_flags, &rmqm);
 
 			/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch
mm-page_alloc-tighten-up-find_suitable_fallback.patch

