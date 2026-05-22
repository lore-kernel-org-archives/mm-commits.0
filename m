Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA9B1E5B9A
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411669; cv=none; b=uUKPOti0Ooh/CytHFo2i1mfqOngmQAMKpgcClWHIlUGDE0ErwO5vDAd63rfQTwtw5HzI1AT3yJ3AsU6/el2A5NchV6CDofeLo7P8ONfXAQAl7DAPANm9JXoSfL260+qe0B9yyVSyBiR5osbstPoo6FM8kOtPYP+5sF0i0nD/We8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411669; c=relaxed/simple;
	bh=UaVmCdsCuJJ+qnSAsHPdujPUA9CvV7UEtlHOZ/QUcOI=;
	h=Date:To:From:Subject:Message-Id; b=euj2pYljgIP4YUZYIuva2uglR7FmAHZaGSRqvZrFAVHUx4Jn3uIcQfEWDxihfNGrDv9rWs/3loLS/x5wVoZgCC66jpJNhRC2DdaG+r8+lO9Z6YR8pgYJeQebTwo/14kKoJeI0gEAl5ysxTNy41uf752sng8coQ/aCTIE4h26u+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gvoWiNh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gvoWiNh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB2C1F000E9;
	Fri, 22 May 2026 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779411667;
	bh=6NTA4JvZ9U8g3ixpMq1mNy0CT00hcI9waJ1io8otA3k=;
	h=Date:To:From:Subject;
	b=gvoWiNh6jgkVrP/rygu+Ctw2LgwFDQTRorJqhLNJAPKVxBYFPWtroOXobIwrcBftY
	 sLd6J+Q6y+clE6k8iFqth+a4Q62hiQaPKw9hJau0qlTM5CrGeECCQh6A+xV4u9WcHn
	 /CrYc5mWBVQKjckEk0PdQt4/Ei3IOb/ZZx7vUFic=
Date: Thu, 21 May 2026 18:01:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-cap-compact_gap-at-compact_cluster_max.patch added to mm-new branch
Message-Id: <20260522010107.2AB2C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch
mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain.patch
mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

