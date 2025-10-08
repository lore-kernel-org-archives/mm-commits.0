Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9923D289
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759883595; cv=none; b=PNEbtawDEnkcNNBuWXb9NnYqhRl9FbPl4fu7floIR2Gagp/T27aqGosq4WhZfW/KoO1R1mnc8OkrrYscle2TOSK/Orm+vY3u3LK7WG6NIBl90pYlrvE3/5N67jc3C3pikBqMuD8Q4zQltxjzP3xnIathdX/Gwx2RoW+C/Vd1ofY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759883595; c=relaxed/simple;
	bh=aau1EJf+p4syfElvhYFZbQFH3SIuQGwboofnTHubn58=;
	h=Date:To:From:Subject:Message-Id; b=i3Um5CwL5oMUMa59OpqDMN8aAKSilB+YDzZY1BYJ1gS0CmzZCmVn+5Yr84jwG9NT67dbUD4DyGqF8DTUiPZass4PKXDNVVH8FrF+zzfPCBngOUn+o6fpWJB67NgaKxUANO7x+pxJmyKWNzIr091LqdFndPBFRu0OvY8fJIzk8Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JyBxYRfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JyBxYRfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA93C4CEF7;
	Wed,  8 Oct 2025 00:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759883594;
	bh=aau1EJf+p4syfElvhYFZbQFH3SIuQGwboofnTHubn58=;
	h=Date:To:From:Subject:From;
	b=JyBxYRfV+8D3tHML73eFCD9rE3Dqys9ZWWVkujgC0ozLRPihw9FP4D3qWqXsEPg+e
	 3316ruyQjY+GugnvpFVTsjaqD8rLIrHtD2JJY2grnc8WHnhyLhURaK1xlnImOP6Fc+
	 JO+KafHMm031oxDIuAl8AACkaAktJccERzY4lTNA=
Date: Tue, 07 Oct 2025 17:33:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,harry.yoo@oracle.com,hannes@cmpxchg.org,david@redhat.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch added to mm-new branch
Message-Id: <20251008003314.8DA93C4CEF7@smtp.kernel.org>
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
Date: Sat, 4 Oct 2025 00:53:15 +0800

Patch series "reparent the THP split queue", v4.

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

Link: https://lkml.kernel.org/r/7bb571c217c3c14c47e86706a50c1b792e88b4d6.1759510072.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-replace-folio_memcg-with-folio_memcg_charged
+++ a/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(stru
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

