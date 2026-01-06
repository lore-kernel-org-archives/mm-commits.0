Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454428541A
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 19:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727018; cv=none; b=laUeVbcDNLo1wqQpQpRT73QeOds3iA4f4ZiDqMAVbvABaRGcucKf/c4KebmAdGX31NxHriw0vlsCb8BvRFfzyT1GYZ8gX1TS23IATrKY0K46seVm7l1Cw7EOaY1RMTI/EUOOT2Ef8UCwUl6iwp6KJ8jINvSVIDGUflz8PxYp2Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727018; c=relaxed/simple;
	bh=ysbcTjTCw70mY98dpb3MwIi5SjrKtazsvNh0cIqm79w=;
	h=Date:To:From:Subject:Message-Id; b=eqPAw0MjL/j/+iT9xdC0a1c0p5mOnWxMiMZis5ny1dA5rxbBZjocpYGd39wFZs7fBmemY1JcFD8DfqFX/JRlrc8PqWlHIr5APNORRml+6/RatsMQ7geY/oHjOJHMJef5Oc2ZumO8hMqwGLvd8vW8CAetCZYsccaPX7vvqxFrJ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDmI+LI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDmI+LI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D49C116C6;
	Tue,  6 Jan 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767727018;
	bh=ysbcTjTCw70mY98dpb3MwIi5SjrKtazsvNh0cIqm79w=;
	h=Date:To:From:Subject:From;
	b=wDmI+LI4qOlLWVxaQcCwjNMKGkIhymEH0vTl8FKG9YmJlLVn9/z+cZ6ielfUcuUDK
	 LkLzCajuHyDQRdwFZ8AzgnrAs/0ATFz47GCsG8/ps3grY+TM0vas1Wgv0znhCkf4XZ
	 C3BqiP5tZlVHlrQodgPN83/e4yuJGQccEoyB60QU=
Date: Tue, 06 Jan 2026 11:16:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,rostedt@goodmis.org,oliver.sang@intel.com,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,bigeasy@linutronix.de,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-prevent-pcp-corruption-with-smp=n-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260106191658.23D49C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: prevent pcp corruption with SMP=n - fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-prevent-pcp-corruption-with-smp=n-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-prevent-pcp-corruption-with-smp=n-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: prevent pcp corruption with SMP=n - fix
Date: Tue, 6 Jan 2026 09:23:37 +0100

Add pcp_ prefix to the spin_lock_irqsave wrappers, per Steven.  With that
make them also take pcp pointer and reference the lock field themselves,
to be like the existing pcp trylock wrappers.

Link: https://lkml.kernel.org/r/04624b16-40ea-42c6-b687-4013796e4779@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-prevent-pcp-corruption-with-smp=n-fix
+++ a/mm/page_alloc.c
@@ -177,19 +177,21 @@ static inline void __pcp_trylock_noop(un
  */
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 static inline void __flags_noop(unsigned long *flags) { }
-#define spin_lock_maybe_irqsave(lock, flags)		\
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
 ({							\
 	 __flags_noop(&(flags));			\
-	 spin_lock(lock);				\
+	 spin_lock(&(ptr)->lock);			\
 })
-#define spin_unlock_maybe_irqrestore(lock, flags)	\
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
 ({							\
-	 spin_unlock(lock);				\
+	 spin_unlock(&(ptr)->lock);			\
 	 __flags_noop(&(flags));			\
 })
 #else
-#define spin_lock_maybe_irqsave(lock, flags)		spin_lock_irqsave(lock, flags)
-#define spin_unlock_maybe_irqrestore(lock, flags)	spin_unlock_irqrestore(lock, flags)
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
+		spin_lock_irqsave(&(ptr)->lock, flags)
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
+		spin_unlock_irqrestore(&(ptr)->lock, flags)
 #endif
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
@@ -2601,9 +2603,9 @@ bool decay_pcp_high(struct zone *zone, s
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2626,9 +2628,9 @@ void drain_zone_pages(struct zone *zone,
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	}
 }
 #endif
@@ -2643,7 +2645,7 @@ static void drain_pages_zone(unsigned in
 	int count;
 
 	do {
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2652,7 +2654,7 @@ static void drain_pages_zone(unsigned in
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	} while (count);
 }
 
@@ -6148,12 +6150,12 @@ static void zone_pcp_update_cacheinfo(st
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-pcp-corruption-with-smp=n.patch
mm-page_alloc-prevent-pcp-corruption-with-smp=n-fix.patch
mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch
mm-page_alloc-ignore-the-exact-initial-compaction-result.patch
mm-page_alloc-refactor-the-initial-compaction-handling.patch
mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

