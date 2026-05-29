Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76816370D49
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027691; cv=none; b=GQSVkMlKOU9Pw78uE6SQufgmD3w5qP6+Soj+R/DVrs1mpNIM+4qwzNfwVJIcLfXK54TWqkp8uK2HfK2Yni3AYbKzeYjN3VCyTttViRJ5nTOlWfsq4+Z+P51DKE2rZkMWTKoJLcHIcuugp85kvTseUww4lWvcWDWBWKntCekOKYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027691; c=relaxed/simple;
	bh=DlKvkX0ILvezm9qqXdpL4eXUsBcA0Yhz5ycMvhZaKH4=;
	h=Date:To:From:Subject:Message-Id; b=hFE9UIHDFJT0ppLC4YbVZt+q5pyoQwPVX6I8Ckc0SmFkeiz7rL1QWlZUAJVxxj1yF9/VrbWzZqp/Pjf/A/mBp/YmxtT0aMSP2ZP4I1R23w79ukihPkZAp9slq0jxE6k5mtaCQ2JvkYuk/OXPyPErpM18cxwzlk5p10g3BShhQMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbdx9CSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbdx9CSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494B71F00898;
	Fri, 29 May 2026 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027690;
	bh=TRyTFJEMFHRlNkV2ZR5d/vuKYzcSQBV1tNzAfJyKiJY=;
	h=Date:To:From:Subject;
	b=tbdx9CSdYH1moKSx6epLb7qgWM/nflsaG1rpkZhbqbBvWkWOrWdKVtidPaaik5MiT
	 lBhwqq5BxZZLCJzCE5lY0AZjWHrGslEl8nBGple9uJkxpk2cGjsKdlztcOXgtJ0bZR
	 0dmAMOphEB3E1zIDWVeDpz+7u3KVLak4BqtEmMyo=
Date: Thu, 28 May 2026 21:08:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch removed from -mm tree
Message-Id: <20260529040810.494B71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in unset_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in unset_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:07 +0000

Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Link: https://lore.kernel.org/815c0905ea77828ed32bf56ff0a6d3c6548eb3a2.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/page_isolation.c~mm-use-zone-lock-guard-in-unset_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -223,15 +223,14 @@ static int set_migratetype_isolate(struc
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -279,8 +278,6 @@ static void unset_migratetype_isolate(st
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

