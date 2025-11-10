Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C24822332E
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 20:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762805096; cv=none; b=WvioQkU5w72JzaYqcoTJGtClMaSvO/PSG/RkAq+wgZWizXcXAGW1pV1aqTF1juElU+uOqHHOXuDE2dXi/8+yG++A0Av6xkUMNZfap5TsaXbPUoLNjZUZlQOseonQqyEDWpTnhaDwHfLQEkzLLWwk8CmWPp2Ke+chddpC2v75Mcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762805096; c=relaxed/simple;
	bh=+k4d5ebNweZMbsNdF+3sRhPcsuqbNoZMyPZhqUcSgcc=;
	h=Date:To:From:Subject:Message-Id; b=E5Nai03jBawGPjICDQblQ+LT/XGr1OmNzkL0XWEuBk724HG5yOuSsQIeTGPajGqfR8nYOVROzr6PTLjIJP1fB2hi6hLvRHOV/7M3MldF0WNr0tCJf6Zt7oyok96tggY3ynu8DdLlluYcXqZoIyIGgk+NvmFrMusJfeMmXcDj0nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LsV5nYXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LsV5nYXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D1BC4CEFB;
	Mon, 10 Nov 2025 20:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762805096;
	bh=+k4d5ebNweZMbsNdF+3sRhPcsuqbNoZMyPZhqUcSgcc=;
	h=Date:To:From:Subject:From;
	b=LsV5nYXEBRAK4hV1zi9koV5VbxAQMeMJHITNqq+AfBHd36Dw5+3YlICHeP4AdrH2t
	 dnIVDCbmYxhJYWVaAPgp55rS6JZHO/xRDEFxK8lf25rqYBycruC62TJ8JWCi7keZx7
	 O4OT7MUxUlFdU+eoksc7zNxUYRDnBWmQOSuBgAV0=
Date: Mon, 10 Nov 2025 12:04:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,richard.weiyang@gmail.com,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch added to mm-new branch
Message-Id: <20251110200456.21D1BC4CEFB@smtp.kernel.org>
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
Date: Mon, 10 Nov 2025 16:17:55 +0800

Patch series "reparent the THP split queue", v6.

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the THP split
queue to its parent memcg.

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding objcg
lock and lru lock).  Therefore, we can apply the same mechanism as
list_lru to reparent the split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and
preparatory work.

The last patch reparents the THP split queue to its parent memcg during
memcg offline.


This patch (of 4):

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer.  It is more efficient than
folio_memcg().  Therefore, replace folio_memcg() with
folio_memcg_charged().

Link: https://lkml.kernel.org/r/56624d537520e33e5a6b3755238b3dfb959a52ee.1762762324.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/ [1]
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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-replace-folio_memcg-with-folio_memcg_charged
+++ a/mm/huge_memory.c
@@ -4129,7 +4129,7 @@ bool __folio_unqueue_deferred_split(stru
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

