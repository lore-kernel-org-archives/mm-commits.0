Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92651134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418000; cv=none; b=LkBm+QPX/bFxISTWhDyu6Z8GWHZ3UrlAN0S/Zn8rjOG9Uf6p0YquKkPZGymXMvs4UTR1m0XK+Asdc1un37uawr7irnbdWYaLFhR5GB+XuF7NB5VbS2lc9IRv6VvbcWg4d2PtGFD6BKC/dPwK7C7CEZxLc8KQ7OMZyOW4tavKYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418000; c=relaxed/simple;
	bh=P6rt0tLsoIn4OEzqdx32vI0ekcTDHljt/ttE0fjre8Y=;
	h=Date:To:From:Subject:Message-Id; b=gDYsTa20CRxBtw2wS8AIejDcGfCZ0XRf7snWJEbCRXXDE22MAqHjQlzmmG1+viQ44xsE7cq+8K1g5kgY84s4voCP0jAyKbYX6nb9Om5Lvqga3fGJmqYr1GxwJWTaY1FyPUGwfhmFIlzl4AEjIQU2Ba28xuGtv8xLkd8ugDPbt74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgRjAwUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgRjAwUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00668C4CEE2;
	Sat, 12 Apr 2025 00:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418000;
	bh=P6rt0tLsoIn4OEzqdx32vI0ekcTDHljt/ttE0fjre8Y=;
	h=Date:To:From:Subject:From;
	b=wgRjAwUAKn1LTN+CMukDghxjbQOfOoIU0x0quoqoa0wYRqIC0XbV1Fg/e1igI2sqd
	 BJl6HkJGPIxCAtz8CJfYQkyRYe4NUKODQy+EELnlyhTz+XFbPSFfR+E6+1H1zw8Fjn
	 0ElrqY9QzYvUJIFxqFJf7BdHVBvQkQlnvP4DR3AE=
Date: Fri, 11 Apr 2025 17:33:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shakeel.butt@linux.dev,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,martin.lau@kernel.org,harry.yoo@oracle.com,daniel@iogearbox.net,bigeasy@linutronix.de,andrii@kernel.org,ast@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-avoid-second-trylock-of-zone-lock.patch removed from -mm tree
Message-Id: <20250412003320.00668C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: avoid second trylock of zone->lock
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-second-trylock-of-zone-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


