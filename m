Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A693254B4
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565698; cv=none; b=K/8B7/Jpydkdh6rxffFPKy/ZrVaexDqA1KasLaWmlA82vxCmF3025qAlADid/ss53gNe7pcx+4ThTZ/s2sic35aJjQYfwR10QM4R93NLjEhV8xCRqLxLAjY48595x5zJ6Eis5Fj/wxN4sanq7PF6sCmvGeXS5F1nRta+TYKmE6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565698; c=relaxed/simple;
	bh=7SkZf4o6L9yyyLKcCaZV9rAsVA3XbVKeWbfdv8UmCzs=;
	h=Date:To:From:Subject:Message-Id; b=UXUsw/DzMBVyyxHwJV7UAmcqQMY9cpc/C2vEC+OZXJGmkjb/ITKnGDtzpBkah5eNjiC5iOuXTZzH9Z4zW1u5QkUVHYRFzffCZSqWgdP/pAzJCn4VxiWfYKbNqxNwCcib/p+jrUt5skmml160CzLUYZ7anFQ5G3hcNN6Yr9cPPP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zssdm4Kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zssdm4Kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8947EC4CEF8;
	Wed, 15 Oct 2025 22:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760565697;
	bh=7SkZf4o6L9yyyLKcCaZV9rAsVA3XbVKeWbfdv8UmCzs=;
	h=Date:To:From:Subject:From;
	b=zssdm4KgpRhOteCeUwsgdq7iu071/0SpownTykinqljvs3kbyQMIEPpVf5+B4eVZD
	 bWWiRc0tVHqFAvLz+J+Srw3cByK7Dr9M+pMgYBWJMWzjRTg7lbL4NUDdF3M9IXAoG/
	 K2IoHHTcVKTzDFB77szyTXwZGAKH7iWSvfa4f3MM=
Date: Wed, 15 Oct 2025 15:01:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch added to mm-new branch
Message-Id: <20251015220137.8947EC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: replace folio_memcg() with folio_memcg_charged()
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Wed, 15 Oct 2025 14:35:30 +0800

Patch series "reparent the THP split queue", v5.

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the THP split
queue to its parent memcg.

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding objcg
lock and lru lock).  Therefore, we can apply the same mechanism as
list_lru to reparent the split queue first when memcg is offine.


This patch (of 4):

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer.  It is more efficient than
folio_memcg().  Therefore, replace folio_memcg() with
folio_memcg_charged().

Link: https://lkml.kernel.org/r/cover.1760509767.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/bc75f3a5bd0920861e522abd83eef74d402d8b57.1760509767.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-replace-folio_memcg-with-folio_memcg_charged
+++ a/mm/huge_memory.c
@@ -4102,7 +4102,7 @@ bool __folio_unqueue_deferred_split(stru
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch
mm-thp-introduce-folio_split_queue_lock-and-its-variants.patch
mm-thp-use-folio_batch-to-handle-thp-splitting-in-deferred_split_scan.patch

