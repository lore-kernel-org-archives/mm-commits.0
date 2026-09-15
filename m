Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB13F825A
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 03:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789444239; cv=none; b=uVgc7bkT9VQ1i2OMoQM+XZFlHP6Fzmi8wNAjitGROhHmBa2FxJtqRNACDM99N7UinyfM8rpXzUhniMamFQzcvFrU7CZGgooQ1CrGgW21dYZAyqp0DKUAk8zz//TcLcoA6nOjetINF0CC0i6P/DEgM3tg8xUTwCCrL0nyGE4At2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789444239; c=relaxed/simple;
	bh=oSjDajcGmJafEBff4nR2xnQ7hPuQgr0AwNd6wIT0mDE=;
	h=Date:To:From:Subject:Message-Id; b=j7S8aBiaIp9XyKF3bo2Kygfx6vxR+QA29VOZW88FjHZ6Iwz/aSg7sclK/CnzMIC2aT0qEDDwRs29EBHJQ2ljGkDmzOYs0dIx+E6Tp5wPuP/5fuYrGGABLZ1Yq7jhdz6F7exR/20LjAiGjmBMhAwMEtYgGNaq0wxBwsCsvrgFA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcZzH1dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcZzH1dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F9D1F000FF;
	Tue, 15 Sep 2026 03:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789444237;
	bh=CDWGbISG8TJ+vIUGwYffor9Y2xKJCm0VmwBb1b09sCY=;
	h=Date:To:From:Subject;
	b=FcZzH1dgAnba8FQAFobJn6lQSPs9r2JuOe2F5RNvVmOatgB8E4PX0JozRADFLx4cX
	 R/QeZJjR/tEHNgQ+mqeO9B5jYvkIEQVCOmeZnmYdywZx4QT6NLvk1RySiWzZ6aqYAT
	 HEtmZ3bvfQnD6RVHyt2/PbAKqcoFsdyxc4KPeuZw=
Date: Mon, 14 Sep 2026 20:50:37 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-clear-the-reference-counter-for-rejected-folios.patch removed from -mm tree
Message-Id: <20260915035037.99F9D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: clear the reference counter for rejected folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: clear the reference counter for rejected folios
Date: Wed, 9 Sep 2026 09:57:04 +0800

As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
a new generation, LRU_REFS_FLAGS should be cleared so that the reference
counter can start over.

For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag when lru_gen_folio_seq() would place them in the
oldest generation.  That's fine.

But for rejected folios where lru_gen_folio_seq() returns a generation
other than the oldest one (which can be treated as a promotion), we do not
clear LRU_REFS_FLAGS.  This can violate the promotion mechanism.  And this
means the rejected folio enters the new generation with stale, inflated
tier bits, which can inflate reference counts and distort eviction
statistics for these rejected folios.

Fix this by clearing LRU_REFS_FLAGS for rejected folios.  Of course, I
need to evaluate the impact of the changes, which mainly falls into 3
cases:

1. When lru_gen_folio_seq() returns the oldest generation for rejected
   folios, there are no logic changes, and they will be put back into the
   2nd youngest generation.

2. For rejected folios with PG_active set by shrink_folio_list(), we
   only clear the LRU_REFS_FLAGS and do not change the generation.

3. For rejected folios with PG_referenced set, the original code would
   put them back into the 2nd oldest generation.  After this patch, we
   will put them back into the 2nd youngest generation.

I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
use folio_mark_accessed to replace folio_set_active"), a rejected
referenced folio was also put back to the 2nd youngest gen.  Meanwhile, I
didn't see any noticeable performance impact on my 32-core Arm machine
when running 'make -j32' to build the kernel inside a 3G-limited memcg
with either zram or NVMe swap.

Link: https://lore.kernel.org/9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-mglru-clear-the-reference-counter-for-rejected-folios
+++ a/mm/vmscan.c
@@ -5072,11 +5072,12 @@ retry:
 			continue;
 		}
 
+		/* See the comments on LRU_REFS_FLAGS */
+		folio_set_lru_refs(folio, 0);
+
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

maintainers-add-baoquan-and-me-as-mglru-reviewers.patch
mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch

