Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9751C126C1E
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610415; cv=none; b=o0ClKbm/ige8lN06nFZEijzbC9oRih6IJ1llPMf8W2GMcMN/zoJ2dfnMXNJnMwPtqETrb+1r8T8WhYCY7rEwOP7+yNayfTvsylxUgGVVOm8EXuLgRd5pHu8cs9UuLs3nBntILJpWt2yyxAlhtdSrIGVuYz//LHgCCddRE2jYd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610415; c=relaxed/simple;
	bh=es/9dksFeJXP59HX0JR92Tw9gaNRmLgOwnyRE0ZfDtw=;
	h=Date:To:From:Subject:Message-Id; b=uqoxMpptFGibzX+M/SifDoZch2ozrfcbgp6RjZTDgEjfqbbC+ARHigcDr8OQlmU3l5x//65P8lEtq1AcfEFE12z/exiCFl1pvNHnZ2CzieEEwi0s2eHkVG3XsGT2Z7SROE78r1NsC5uXxelCh6IYvQJze0mLOU0Mkm2bVcgeTRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4ndlqQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4ndlqQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16061C4CED0;
	Tue, 31 Dec 2024 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610415;
	bh=es/9dksFeJXP59HX0JR92Tw9gaNRmLgOwnyRE0ZfDtw=;
	h=Date:To:From:Subject:From;
	b=v4ndlqQ3sT+CsfHfNzjPu359NcO/EHpBauSv7mMDaTROumzDxNzOOKtxoqhA7cUKV
	 q0Iw8aadD1L7oMGOM347JS0wZo9MyxLVgnv8kffWSo67VgZHhH9/0ufLtqk3f5U8Vr
	 HrNnwn3rW6uUFa3iW8q7ttnrNKJQp2WfhRzkrloY=
Date: Mon, 30 Dec 2024 18:00:14 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,sashal@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-list_lru-fix-false-warning-of-negative-counter.patch removed from -mm tree
Message-Id: <20241231020015.16061C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: fix false warning of negative counter
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-false-warning-of-negative-counter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: fix false warning of negative counter
Date: Mon, 23 Dec 2024 23:09:07 +0800

commit 2788cf0c401c ("memcg: reparent list_lrus and free kmemcg_id on css
offline") removed sanity checks for the nr_items counter's value because
it implemented list_lru re-parenting in a way that will redirect
children's list_lru to the parent before re-parenting the items in
list_lru.  This will make item counter uncharging happen in the parent
while the item is still being held by the child.  As a result, the
parent's counter value may become negative.  This is acceptable because
re-parenting will sum up the children's counter values, and the parent's
counter will be fixed.

Later commit fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup
scope") reworked the re-parenting process, and removed the redirect.  So
it added the sanity check back, assuming that as long as items are still
in the children's list_lru, parent's counter will not be uncharged.

But that assumption is incorrect.  The xas_store in
memcg_reparent_list_lrus will set children's list_lru to NULL before
re-parenting the items, it redirects list_lru helpers to use parent's
list_lru just like before.  But still, it's not a problem as re-parenting
will fix the counter.

Therefore, remove this sanity check, but add a new check to ensure that
the counter won't go negative in a different way: the child's list_lru
being re-parented should never have a negative counter, since re-parenting
should occur in order and fixes counters.

Link: https://lkml.kernel.org/r/20241223150907.1591-1-ryncsn@gmail.com
Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
Signed-off-by: Kairui Song <kasong@tencent.com>
Closes: https://lore.kernel.org/lkml/Z2Bz9t92Be9l1xqj@lappy/
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-false-warning-of-negative-counter
+++ a/mm/list_lru.c
@@ -77,7 +77,6 @@ again:
 			spin_lock(&l->lock);
 		nr_items = READ_ONCE(l->nr_items);
 		if (likely(nr_items != LONG_MIN)) {
-			WARN_ON(nr_items < 0);
 			rcu_read_unlock();
 			return l;
 		}
@@ -450,6 +449,7 @@ static void memcg_reparent_list_lru_one(
 
 	list_splice_init(&src->list, &dst->list);
 	if (src->nr_items) {
+		WARN_ON(src->nr_items < 0);
 		dst->nr_items += src->nr_items;
 		set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

