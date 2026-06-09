Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53B2D9ECB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968143; cv=none; b=fwJYb5FfaZWJOGGstThkBBVuFj4qKnyZexMRL+bO02xkw0fnNGjD6D6ih/e/BOI4wNxIPT9YOmJAAVCIepDSnccq+uflBrAeTwyT1btuyx/GwrPGb2R93FzIHDwkczdQIXqocn8IzWsWYgJbc/yHXnxmJ+AEc8D+K1vWRFQz7yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968143; c=relaxed/simple;
	bh=4NznfKa//X9A33dZREgBKEvUeZ5dyjUdm1MaCKw3+rk=;
	h=Date:To:From:Subject:Message-Id; b=Lkrj5fzio95BXWeuPPVzEQ+1RzpZdB/p4woKu0794f0E08uawKFt+VbZZdIZjY70wIsInznSy8EZQHCwLdzhqKnY2MQXCCZijzC5Q08yEkhf5czNeNETBlAnKthx9E7C3kG55NTbv/X4+egKQpCnb6eS1K+AbKnPYwKZBMmwzNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z8kzuF7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z8kzuF7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4551F00893;
	Tue,  9 Jun 2026 01:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968142;
	bh=E3FKqtCPzDFd/lJww3Qno/VA5Vw7xDzu9yValNSOOEA=;
	h=Date:To:From:Subject;
	b=z8kzuF7ga8GyaoAtyHA9KMqwaxR5B0vB5fdyzVwC+SpCWvDOWVuqlrLENGOnyR/mK
	 kH3J8fDi/GkI3hnILHbTR5xKnQZ0bALR/GAuYnAI3GumWkULWPaz9q3bUytgLToe1x
	 WsR7dMAoVcrKyy9V7a8OoQJ85y/3rEb2WxEDwd2A=
Date: Mon, 08 Jun 2026 18:22:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch removed from -mm tree
Message-Id: <20260609012222.0E4551F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/thp: clear deferred split shrinker bits when queues drain
has been removed from the -mm tree.  Its filename was
     mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/thp: clear deferred split shrinker bits when queues drain
Date: Tue, 2 Jun 2026 12:34:53 +0800

deferred_split_count() returns the raw list_lru count.  When the
per-memcg, per-node list is empty, that count is 0.

That skips scanning, but it does not tell memcg reclaim that the shrinker
is empty.  shrink_slab_memcg() only clears the memcg shrinker bit when the
count callback reports SHRINK_EMPTY.

Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
cleared once the queue has drained.

Link: https://lore.kernel.org/20260602043453.67597-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain
+++ a/mm/huge_memory.c
@@ -4410,7 +4410,10 @@ void deferred_split_folio(struct folio *
 static unsigned long deferred_split_count(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	return list_lru_shrink_count(&deferred_split_lru, sc);
+	unsigned long count;
+
+	count = list_lru_shrink_count(&deferred_split_lru, sc);
+	return count ?: SHRINK_EMPTY;
 }
 
 static bool thp_underused(struct folio *folio)
_

Patches currently in -mm which might be from lance.yang@linux.dev are


