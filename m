Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90512CA6
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743653103; cv=none; b=gPSue07jAPFcK3lTwMCMdZW6tutPUS2KEsT5u9RhwM3Js7q8gZKBz2YvqC0kVlyvWOHBsD0azelofP1ocwCQfBe+K84Lrs3SIb/iULcFgYBKSadJRu4RIawg9qQJuzjZgknUvMJyuw8es+ZwAkCXKiRjRHuhnW2xFKdDDRZckA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743653103; c=relaxed/simple;
	bh=hl9mMaQmfC+4A1gh2o3OGL36SKz/51WGpZrGcUSUyis=;
	h=Date:To:From:Subject:Message-Id; b=ZOP3UcUkndudnW5aHLU85YaE+HY7nau5C7czVoXBtZwYJYaTEeawabnpjEfU3safwMAB2KqiffV52IFkZWDrsnjraWDRsF+uw6eAYTwGsACQF71PQhp5ffaohxJJd85AsOHX4iZi+wVAG3vXezqnYa18rCLQHnLQ+ldyCqhoo5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLwbzJx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLwbzJx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5CAC4CEE3;
	Thu,  3 Apr 2025 04:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743653103;
	bh=hl9mMaQmfC+4A1gh2o3OGL36SKz/51WGpZrGcUSUyis=;
	h=Date:To:From:Subject:From;
	b=QLwbzJx3LEvX/rX00HEImRJRJcbWMzlVyqIW0GmYN4E3uDAUGpGBVQ0ktNoIei0BI
	 tm5LolJSCbFO3lgIQXmD/UXSgUDoachBBUmA5BX/DPKo2PZXrFYuTchIe5bwCY/cAo
	 s/PSndqfGXP3Iy+Y7JCZLnp9Q7vhepYsUQ+JV0Lk=
Date: Wed, 02 Apr 2025 21:05:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shakeel.butt@linux.dev,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,martin.lau@kernel.org,harry.yoo@oracle.com,daniel@iogearbox.net,bigeasy@linutronix.de,andrii@kernel.org,ast@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-second-trylock-of-zone-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403040502.EE5CAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: avoid second trylock of zone->lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-avoid-second-trylock-of-zone-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-second-trylock-of-zone-lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexei Starovoitov <ast@kernel.org>
Subject: mm/page_alloc: avoid second trylock of zone->lock
Date: Sun, 30 Mar 2025 17:28:09 -0700

spin_trylock followed by spin_lock will cause extra write cache access. 
If the lock is contended it may cause unnecessary cache line bouncing and
will execute redundant irq restore/save pair.  Therefore, check
alloc/fpi_flags first and use spin_trylock or spin_lock.

Link: https://lkml.kernel.org/r/20250331002809.94758-1-alexei.starovoitov@gmail.com
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-second-trylock-of-zone-lock
+++ a/mm/page_alloc.c
@@ -1400,11 +1400,12 @@ static void free_one_page(struct zone *z
 	struct llist_head *llhead;
 	unsigned long flags;
 
-	if (!spin_trylock_irqsave(&zone->lock, flags)) {
-		if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+		if (!spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
+	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 	}
 
@@ -2314,9 +2315,10 @@ static int rmqueue_bulk(struct zone *zon
 	unsigned long flags;
 	int i;
 
-	if (!spin_trylock_irqsave(&zone->lock, flags)) {
-		if (unlikely(alloc_flags & ALLOC_TRYLOCK))
+	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
+	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 	}
 	for (i = 0; i < count; ++i) {
@@ -2937,9 +2939,10 @@ struct page *rmqueue_buddy(struct zone *
 
 	do {
 		page = NULL;
-		if (!spin_trylock_irqsave(&zone->lock, flags)) {
-			if (unlikely(alloc_flags & ALLOC_TRYLOCK))
+		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+			if (!spin_trylock_irqsave(&zone->lock, flags))
 				return NULL;
+		} else {
 			spin_lock_irqsave(&zone->lock, flags);
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
_

Patches currently in -mm which might be from ast@kernel.org are

locking-local_lock-mm-replace-localtry_-helpers-with-local_trylock_t-type.patch
mm-page_alloc-avoid-second-trylock-of-zone-lock.patch

