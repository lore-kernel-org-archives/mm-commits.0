Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9A233343B
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772141154; cv=none; b=C8TMo6CpPdowjWaFEiSy+OrZuAFB4WoBYQTrMaDvp+cqtCVkKkpemQnQCVGW7OA1FwJ6PcFM7Vo5j1b1B1Xhg4DRfCnY4qUgk5xLwwC/KL0zShn7wuFJHLH7/mBzLUg9uYiyd4LjSfxbKbf/TmSw4x66L8xDnT1gjQz6qqg36pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772141154; c=relaxed/simple;
	bh=CClwyVy0XmQVgyva4nHcNTCiskfLfxYYWUPajamEkd0=;
	h=Date:To:From:Subject:Message-Id; b=oWQwxbu3YWQ+hyD/f9CACFLer0YBQ3n7Bt5uvk/ZTGcXhsbNo4P7f2pqQulXuVqlWzLnk6f5V6fyU6NI/nKftE2XIbZmJ5MdrA+4+zyanPL7qkpOI2mZmtvypa53PyIFbjb2b/xowS2OOKNPmBTuUsq2kc4G2VSBR60ZswUaawI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oFpkIyuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFpkIyuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D776C116C6;
	Thu, 26 Feb 2026 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772141154;
	bh=CClwyVy0XmQVgyva4nHcNTCiskfLfxYYWUPajamEkd0=;
	h=Date:To:From:Subject:From;
	b=oFpkIyukDXGjkuBsb6YAwH8ucwjnMS/mg65k8Z7wlgMLNwnSwKXngKHNzSaqgAHf/
	 VHTX7sdfm9sl9CzhPs/2KFwhcAaOQp3vi5KKLp9On2KkSDRqUZFrqNXoSfGx54ELCH
	 gRunow34X2m3L/t184tdiJFzXmvifaZi25jRcVtA=
Date: Thu, 26 Feb 2026 13:25:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-compaction-to-zone-lock-wrappers.patch added to mm-new branch
Message-Id: <20260226212554.0D776C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert compaction to zone lock wrappers
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-compaction-to-zone-lock-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-compaction-to-zone-lock-wrappers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: convert compaction to zone lock wrappers
Date: Thu, 26 Feb 2026 18:26:20 +0000

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

Link: https://lkml.kernel.org/r/01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
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
+__acquires(&zone->lock)
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
+__acquires(&lruvec->lru_lock)
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

mm-introduce-zone-lock-wrappers.patch
mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch

