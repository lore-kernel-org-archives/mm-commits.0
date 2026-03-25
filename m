Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11DC3EDACF
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450113; cv=none; b=hPcjT0qx8leTLb3gVRY/zRvexaUplR1IYgtJOzH+19zu0WjE1a5ZLkLgJ7isSafWYG+Hd8N4fDLtegaaocyDH5Z0sOXB22daaxwoNyzOrnIpi+pM2Ga7L4b+yuBDulzmS3WbhhGCBgmZDTwf8jyZihEmiZpBSiY72/a/CrRXNxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450113; c=relaxed/simple;
	bh=CuD0R2qdkwBz6O1EyYPpCcRFKw9BawZfVNpJP4RJT34=;
	h=Date:To:From:Subject:Message-Id; b=ocnNDZ1G8FjKo42ArUrhkql7AWcI7ieF4AlsQvN5EcxK9J0qwHDIzDtVkX1EiCZ5J1U+mxhxuWLAxYZAOHysj+KJOprmqabRRYuH/zy8yXC7KUqdSxjFRI0IxHR5vSlmBwPDJ4h0sNzA5/FvOWPbOV6P04JmptSQXmNRhxjn0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axgosLbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axgosLbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1FBC4CEF7;
	Wed, 25 Mar 2026 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450112;
	bh=CuD0R2qdkwBz6O1EyYPpCcRFKw9BawZfVNpJP4RJT34=;
	h=Date:To:From:Subject:From;
	b=axgosLbfLCfa6RKa829fmosQe8AwEGnGJoUxD4VMzHDmPHjk40n1osw34mGV6W3vc
	 mlwLQEO4uTuErRA86gX0iUnELra8ROPI1Rs2QAROdTGVapd/aiVewAhtOCCe6he1AM
	 fgbHpQRrOK1M9HArjPzc/mGsj6AZf4Al5Sl/19Ac=
Date: Wed, 25 Mar 2026 07:48:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lenb@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-convert-compaction-to-zone-lock-wrappers.patch removed from -mm tree
Message-Id: <20260325144832.8F1FBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert compaction to zone lock wrappers
has been removed from the -mm tree.  Its filename was
     mm-convert-compaction-to-zone-lock-wrappers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: convert compaction to zone lock wrappers
Date: Fri, 27 Feb 2026 16:00:25 +0000

Compaction uses compact_lock_irqsave(), which currently operates on a raw
spinlock_t pointer so it can be used for both zone->lock and
lruvec->lru_lock.  Since zone lock operations are now wrapped,
compact_lock_irqsave() can no longer directly operate on a spinlock_t when
the lock belongs to a zone.

Split the helper into compact_zone_lock_irqsave() and
compact_lruvec_lock_irqsave(), duplicating the small amount of shared
logic.  As there are only two call sites and both statically know the lock
type, this avoids introducing additional abstraction or runtime dispatch
in the compaction path.

No functional change intended.

Link: https://lkml.kernel.org/r/3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/mm/compaction.c~mm-convert-compaction-to-zone-lock-wrappers
+++ a/mm/compaction.c
@@ -503,19 +503,36 @@ static bool test_and_set_skip(struct com
  *
  * Always returns true which makes it easier to track lock state in callers.
  */
-static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
-						struct compact_control *cc)
-	__acquires(lock)
+static bool compact_zone_lock_irqsave(struct zone *zone,
+				      unsigned long *flags,
+				      struct compact_control *cc)
+	__acquires(&zone->lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
-		if (spin_trylock_irqsave(lock, *flags))
+		if (zone_trylock_irqsave(zone, *flags))
 			return true;
 
 		cc->contended = true;
 	}
 
-	spin_lock_irqsave(lock, *flags);
+	zone_lock_irqsave(zone, *flags);
+	return true;
+}
+
+static bool compact_lruvec_lock_irqsave(struct lruvec *lruvec,
+					unsigned long *flags,
+					struct compact_control *cc)
+	__acquires(&lruvec->lru_lock)
+{
+	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
+		if (spin_trylock_irqsave(&lruvec->lru_lock, *flags))
+			return true;
+
+		cc->contended = true;
+	}
+
+	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 	return true;
 }
 
@@ -528,7 +545,7 @@ compact_folio_lruvec_lock_irqsave(struct
 	rcu_read_lock();
 retry:
 	lruvec = folio_lruvec(folio);
-	compact_lock_irqsave(&lruvec->lru_lock, flags, cc);
+	compact_lruvec_lock_irqsave(lruvec, flags, cc);
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
 		goto retry;
@@ -549,7 +566,6 @@ retry:
  * Returns true if compaction should abort due to fatal signal pending.
  * Returns false when compaction can continue.
  */
-
 static bool compact_unlock_should_abort(struct zone *zone,
 					unsigned long flags,
 					bool *locked,
@@ -634,8 +650,7 @@ static unsigned long isolate_freepages_b
 
 		/* If we already hold the lock, we can skip some rechecking. */
 		if (!locked) {
-			locked = compact_lock_irqsave(&cc->zone->lock,
-								&flags, cc);
+			locked = compact_zone_lock_irqsave(cc->zone, &flags, cc);
 
 			/* Recheck this is a buddy page under lock */
 			if (!PageBuddy(page))
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch

