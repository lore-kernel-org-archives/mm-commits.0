Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9F18CC13
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600465; cv=none; b=N94W1MIffpDrQVC/nOLBwKO1YVkPfDyAXeTeXm2xLACuAIj1uVch0fyZMaL619n6UkNyL1Ayl8wDOhXDTJjPjFKNVYI9wjF8Qm9uCTEYMrlyfACjSTjfI3K3FbNMDFkVUqwsiE/I0avGCrhkd7jyCIyJrp4PLGP+4DtfCc0vdEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600465; c=relaxed/simple;
	bh=mmsV2Z/9L5pYnzJqJp80Fzu/3bEVrEJEc2F10VL/+ts=;
	h=Date:To:From:Subject:Message-Id; b=YqhdWsJmVaujanSAwsfkThR4wlksaCZvcQp57yx/TZbZsk9uuK0dCKVPkrlqJQrRf2PY5wSD2S4733JwWo2V+MrlSRQopldsotK+kL4xzD+1uNi0RVDQCvi/i9hgg1YU/TkL4+IYJlnXvEIRO3NRBbLUD7trNS0KZTt2doOGKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jwi7dsKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jwi7dsKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5891F00893;
	Thu,  4 Jun 2026 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600463;
	bh=PrpEsMJnO/KtaHsBeLEdfBmqDLTbpeZbAhdLorOYrlU=;
	h=Date:To:From:Subject;
	b=jwi7dsKh6yd0Y9rI+XBorMtx54R6RYGX4vgiOg3MV/rVu2Ihpw8peXQxcTBxk6T5z
	 ptqRVPc8Ais9yomGO893CjvLGv8QwHh8hp10ehK9ZJkAXtqffws9doR2bPMwXElMRe
	 4k6V2v8Fsrhrf1KpqtjFwZ/YrAn0QGcQhwXEcppc=
Date: Thu, 04 Jun 2026 12:14:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-cap-compact_gap-at-compact_cluster_max.patch removed from -mm tree
Message-Id: <20260604191423.9D5891F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
has been removed from the -mm tree.  Its filename was
     mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Subject: mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Date: Tue, 19 May 2026 13:08:51 -0700

compact_gap() returns 2 << order, which is used as watermark headroom in
__compaction_suitable() and as a reclaim target in kswapd.  The computed
value scales exponentially by order.  For order-9 THP allocations this
evaluates to 1024 pages, but the compaction free scanner's working set is
bounded by COMPACT_CLUSTER_MAX (32 pages).  The scanner stops isolating
free pages once it matches the migration batch.  The current gap
over-reserves by 32x.

On fragmented production hosts, kswapd will try and reclaim up to the gap,
but it only reaches that threshold 18% of the time, causing reclaim to
continue a majority of the time.  The over-sized gap also causes 46% of
order-9 compaction suitability checks to fail unnecessarily - the zone has
sufficient free pages for the scanner to operate, but not enough to clear
the inflated threshold.

Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
with the scanner's actual capacity.  Orders 0-4 are unaffected since their
gap is <= 32.

A/B test on ~100 instagram production hosts (64GB, 60s measurement):

Unpatched (43 hosts)
pgscan_kswapd (mean/host): ~1.6M
reclaim efficiency (steal/scan): 83.8%
compaction success (success/stall): 2.1%
THP success (alloc/alloc+fallback): 4.9%
forced lru_add_drain (mean/host): ~107K

Patched (59 hosts)
pgscan_kswapd (mean/host): ~449K
reclaim efficiency (steal/scan): 91.0%
compaction success (success/stall): 28.3%
THP success (alloc/alloc+fallback): 17.2%
forced lru_add_drain (mean/host): ~64K

Link: https://lore.kernel.org/20260519200851.141955-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-cap-compact_gap-at-compact_cluster_max
+++ a/include/linux/compaction.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
+#include <linux/swap.h>
+
 /*
  * Determines how hard direct compaction should try to succeed.
  * Lower value means higher priority, analogically to reclaim priority.
@@ -73,11 +75,9 @@ static inline unsigned long compact_gap(
 	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
 	 * that the migrate scanner can have isolated on migrate list, and free
 	 * scanner is only invoked when the number of isolated free pages is
-	 * lower than that. But it's not worth to complicate the formula here
-	 * as a bigger gap for higher orders than strictly necessary can also
-	 * improve chances of compaction success.
+	 * lower than that.
 	 */
-	return 2UL << order;
+	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
 static inline int current_is_kcompactd(void)
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are


