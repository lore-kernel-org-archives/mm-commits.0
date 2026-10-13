Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020B391838
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865953; cv=none; b=uv84Wrcl1sTjAb/ZTYZ9FanMtWEpdfqp9MMjzWum2f3qBHud9e594sGZOTYP0ZDmDdHjyEoPhheJI2EWXIz7TEY3M6Rxi5v3GzBoSvUgoNw3XoktkfvF94yI6sup/VF29GS7RYIhC1tArqxwjcFfk3kGKZprjDwLkixVeM+oD3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865953; c=relaxed/simple;
	bh=79eB/YmpLxwloj736huqF0tPk+C2HGWR+jycRDUgkl0=;
	h=Date:To:From:Subject:Message-Id; b=qI8udbMjmHHPUHYsc/0N0V9uxc+s4Btq7x3oWjfkgtCc2UJusE6FUXkipns06vY0+XMdIvdvjMr/S0BaiwiPm3fvVqkNpPUZafYRo2jMpQKrzL4FXdPGe4TjCHW4+fcRrbHjs3ODCaL0Q510f5oKvGYrgj7VzR+GhTo+QR3l59E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5ProTyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5ProTyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4411F00893;
	Tue, 13 Oct 2026 04:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865952;
	bh=ioPfqZDq6Nr20Re1snXOknsslO7vFJ5K6EIupQ1LpTI=;
	h=Date:To:From:Subject;
	b=E5ProTyiF8eolzNPLUYSOiHJKQ0PZ0MkobNYPRmh85G0fM78GwLQuCBk7hc8qagsc
	 1TzzxPZv5bUdDo6W2pH66e6/GiXY7O46psNg8rIHIpeLQjPhVptKe/W8Uxas/zlsi+
	 yWGRRD27giZlxRdfJipbfLKdI3yZaVKlaE+5AHFM=
Date: Mon, 12 Oct 2026 21:32:31 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch removed from -mm tree
Message-Id: <20261013043232.3A4411F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_counter: constify page_counter_read() and page_counter_margin()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: page_counter: constify page_counter_read() and page_counter_margin()
Date: Tue, 15 Sep 2026 19:20:10 -0400

Both only read the counter.  Constify them so that users can read counters
from const memcgs.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-6-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/page_counter.h |    4 ++--
 mm/page_counter.c            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/page_counter.h~mm-page_counter-constify-page_counter_read-and-page_counter_margin
+++ a/include/linux/page_counter.h
@@ -63,12 +63,12 @@ static inline void page_counter_init(str
 	counter->track_failcnt = false;
 }
 
-static inline unsigned long page_counter_read(struct page_counter *counter)
+static inline unsigned long page_counter_read(const struct page_counter *counter)
 {
 	return atomic_long_read(&counter->usage);
 }
 
-long page_counter_margin(struct page_counter *counter);
+long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
--- a/mm/page_counter.c~mm-page_counter-constify-page_counter_read-and-page_counter_margin
+++ a/mm/page_counter.c
@@ -54,7 +54,7 @@ static void propagate_protected_usage(st
  * Return: The minimum value of max minus usage across @counter and all of
  * its ancestors. The value may be negative during a concurrent charge.
  */
-long page_counter_margin(struct page_counter *counter)
+long page_counter_margin(const struct page_counter *counter)
 {
 	long margin = PAGE_COUNTER_MAX;
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are


