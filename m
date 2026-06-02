Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB903367B90
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 20:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432712; cv=none; b=cXiuL238MrKKVGzkfCTsieowtC3gdN9uJW3vI5bPJUVeVH6DRDiFVy46Oan7iticwZggZgl+y7QiyJ4hhQgjGv2LfIZDvVSQnyRb1M77y4+BhVsJBQqTgLwUqvto4HPtz0GfhjDHPEklVopI/zwnIauXlCYBY6t/7OLnYJsopGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432712; c=relaxed/simple;
	bh=0fj+YWDT9KtmS1+fr6mCyjMVCgxKtM3WYkJ1+qBmczU=;
	h=Date:To:From:Subject:Message-Id; b=b/MnYApUiRZNGeOxi3fnDDfEkhRH5dBlYC8YH0w9E/KNwzOBK9UjcfrN5BDYpPCiC/25I2WF5agNcpX7JdlsN3gxZLMIkjgmRc25fBghhieFDvX5s+77AdcVoOKxLkZr6+iHnfA9RhP2tnlG+xgiZGc8ecCTCTj9fbZ61cD0gsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2EcArV0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2EcArV0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6983D1F00893;
	Tue,  2 Jun 2026 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780432711;
	bh=+nQ/fk7U35L/1gaRUEpTnntpdAe3WHCy8DIBrIHnEcw=;
	h=Date:To:From:Subject;
	b=2EcArV0BbFD9WMFAaNr08Yjm/OD7DT/WjvY0A5U7K0nCLAKybcMNdS0/Qc5TCTPyw
	 bv0IT1bizb6QDGq1Yli9kJUO0SEYLtW7f8qToEriJUcv0FUccnfe2jtOeHchf0PSqf
	 oJVQ3Ldpcs/Gofr9QZ0eiJeffA1HEAEU0s9LtwuM=
Date: Tue, 02 Jun 2026 13:38:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch added to mm-unstable branch
Message-Id: <20260602203831.6983D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: clear deferred split shrinker bits when queues drain
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch

This patch will later appear in the mm-unstable branch at
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
@@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *
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

mm-thp-clear-deferred-split-shrinker-bits-when-queues-drain.patch

