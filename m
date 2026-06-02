Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FF3B8D50
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439034; cv=none; b=DJsedhz+sx53PiQ7fieJDinNcwxraiIS1O9nK8fhOTGKXLoZ537M5j8BGtdJkwDUGPVIeMfWEWdm96n4w+wEtiDPxg25rl+AelU+/2basHLXlIh0787AwG2lL4aHt6FPc9Np39GKPWqVYNNn3wQCBXyarsXcsVusKpU+yue5YBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439034; c=relaxed/simple;
	bh=lpJ7HzWLirsKxaWGFkCvJeBc251InT1VW1P6zAOG3aI=;
	h=Date:To:From:Subject:Message-Id; b=NoQvbmxVkD+Jxx3RkMdyv4MwQwi4brWhqNamvmeSBvBPwhvXrYh0Swdf1DEZQ3jZSNC48QoaTzHnYNVfYAzOB/l2kj0EA2HtWxVMKzOUKnDT0wZ28IS9/IdX8eLKuH8kFHiE9TNg7JlrutHsiNBdN1mvQS9GLKxeG4zNfC136i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0zNmBqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0zNmBqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB31B1F00899;
	Tue,  2 Jun 2026 22:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439033;
	bh=cE1bgIya2PHCnTjeUHGjEOlnwMvINl3vAo9UoEvtVUU=;
	h=Date:To:From:Subject;
	b=j0zNmBqurytUehyBvqBg1PjzW9xfqKYUKuqi8BVFluItm6U5sjh+q3dK0winVrELJ
	 +FNQMoorIWwmwzV6oj0qFp6EZcrUMoOMZwqU5gUwy3329cX/wSy8fN7NfEhOGcO+5V
	 5oPUQjTcwdYYVKNvOqdKuOXxWRx18jiiU0wU3RBM=
Date: Tue, 02 Jun 2026 15:23:52 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,david@fromorbit.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch removed from -mm tree
Message-Id: <20260602222352.DB31B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
Date: Sun, 10 May 2026 19:37:00 +0100

set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
before checking shrinker_id against info->map_nr_max, so an id past the
currently visible map_nr_max reads past the unit[] array before the
WARN_ON_ONCE() catches it.

Determined from code inspection.

Move the load into the bounded branch.

Link: https://lore.kernel.org/20260510183700.102475-1-devnexen@gmail.com
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/shrinker.c~mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit
+++ a/mm/shrinker.c
@@ -197,12 +197,13 @@ void set_shrinker_bit(struct mem_cgroup
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
-		struct shrinker_info_unit *unit;
 
 		rcu_read_lock();
 		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		unit = info->unit[shrinker_id_to_index(shrinker_id)];
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
+			struct shrinker_info_unit *unit;
+
+			unit = info->unit[shrinker_id_to_index(shrinker_id)];
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
 			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

