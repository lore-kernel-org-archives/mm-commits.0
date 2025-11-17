Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93162135C5
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343141; cv=none; b=uvixPkH0Qrj9o/q47YZZz00UYWoI1BX1qg0T/BSz1qaJzjKWmVG4mLhskT+9ro5e1uBUjzX2CUGb5k25edzU5+FvHIgbUjDb7/07FWzqDSbDfFn2vwX3Kd0VwsfyYaEVabCcLYVyVRmGxAA+E9hOpxqeJtR8bivrPBtPws1biaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343141; c=relaxed/simple;
	bh=mJBLK80fHn6nw86hLkJjWMXonPTFLSw/RmPHxm+QMz0=;
	h=Date:To:From:Subject:Message-Id; b=AVdcYk6tBgEgEkNFo6j/s36GpwDpjGbLVmdeBKbKJhnxg+3NcFFFDHbPLv5pQyYYWGiUgj5Bq5RzTHLbtUSiFFtYVAxpgw4z065BbkRv6lm2xDmxYQaw+IKkwGJGUAS1PnD9aR8SBxAUlbLRD9wmTa1tq3LeEQmGTog5tKOubZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1zYl4uCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1zYl4uCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4D5C4CEF1;
	Mon, 17 Nov 2025 01:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343141;
	bh=mJBLK80fHn6nw86hLkJjWMXonPTFLSw/RmPHxm+QMz0=;
	h=Date:To:From:Subject:From;
	b=1zYl4uCJhZapiyDlVFe3DlmKHPgHHovyO54CzrSatxsAVbsDoQxKbvQrpyjCAnTvi
	 h+Y6lBnhUznv7agnNLxh0aEQ7J6nG+Wd9UbbP056ouVHsMaJGhUmFHE1msrKNu0YHw
	 NFyc4RQh9sbRnpu+lfuaHZQVVY17tLshelqQzerQ=
Date: Sun, 16 Nov 2025 17:32:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,mhocko@suse.com,kirill@shutemov.name,jackmanb@google.com,hannes@cmpxchg.org,clm@fb.com,akpm@linux-foundation.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch removed from -mm tree
Message-Id: <20251117013221.AD4D5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: batch page freeing in decay_pcp_high
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: batch page freeing in decay_pcp_high
Date: Tue, 14 Oct 2025 07:50:09 -0700

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot. 
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp or zone lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Link: https://lkml.kernel.org/r/20251014145011.3427205-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-page-freeing-in-decay_pcp_high
+++ a/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zon
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, s
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


