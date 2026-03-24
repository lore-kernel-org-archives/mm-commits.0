Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395CC364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388609; cv=none; b=mc0UfvxAqT0cLbNsQjrtcF7YGVJmK9dkbg1Va6JFA3vnHWv8K0CqhIbtNnK0CGP/VCipoANweu5zeHqhzIY6lxBddxJxPgi4/Ms3Pp0s6EucN94dLry7Hb8NroZB7mUbg9QSRcmTxGe5QSiERmnEikR1Ae8OvTVC2PP1uBDqK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388609; c=relaxed/simple;
	bh=tN8CvzgjrN/5Xv0BwbJOGlWszSW3OyMg4xPxfzIV1gA=;
	h=Date:To:From:Subject:Message-Id; b=ftprXq/kfCAI1RF2rXEzLM61fT8RFycFzVZNfxIVyWGuVTtLblpEUDUJ4pLeHGrqxMzR4pmTecG8yAfhp6i60MyPfnP0mgeiBV1++Qy22jgcXDUY+pESait1WLcz7JYImejfRmIGAuR8pQeye4vfY34aoTSttSEjxe4j1Wm1rRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jGokrxqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGokrxqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FCAC19424;
	Tue, 24 Mar 2026 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388609;
	bh=tN8CvzgjrN/5Xv0BwbJOGlWszSW3OyMg4xPxfzIV1gA=;
	h=Date:To:From:Subject:From;
	b=jGokrxqUAUEnLuC+veqp2oG0oFLhXfD7L94OokL3/kWwljWDNKU6dxDavnVeQDY3/
	 PY/X4lIq7kiSwFLNBw5J2CMm5yNVvF21cBn8Fe8YHCc35LChPVU7clSR2vE/mMK81R
	 dH9kgVmuORpbJbw4ndyr5x8c67KuMRWIMSP6w+7o=
Date: Tue, 24 Mar 2026 14:43:28 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,jack@suse.cz,david@fromorbit.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch removed from -mm tree
Message-Id: <20260324214329.10FCAC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do not allocate shrinker info with cgroup.memory=nokmem
has been removed from the -mm tree.  Its filename was
     mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: mm: do not allocate shrinker info with cgroup.memory=nokmem
Date: Wed, 25 Feb 2026 19:38:44 +0100

There'd be no work for memcg-aware shrinkers when kernel memory is not
accounted per cgroup, so we can skip allocating per memcg shrinker data. 
This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
and saves work in shrink_slab_memcg().

Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
so nokmem should not disable their per-memcg behavior.  Such shrinkers
(e.g.  deferred_split_shrinker) still need access to per-memcg data (see
also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
memcg kmem")).

The savings with this patch come on container hosts that create many
superblocks (each with own shrinker) but tracking and processing per-memcg
data is pointless with nokmem (shrink_slab_memcg() is partially guarded
with !memcg_kmem_online already).

The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
registered before first non-root memcg is mkdir'd.

[mkoutny@suse.com: update comment, per Qi Zheng]
  Link: https://lkml.kernel.org/r/20260309-cgroup-ml-nokmem-shrinker-v2-1-3e7a7eefb6c9@suse.com
Link: https://lkml.kernel.org/r/20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/shrinker.c~mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem
+++ a/mm/shrinker.c
@@ -219,6 +219,8 @@ static int shrinker_memcg_alloc(struct s
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
+	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
+		return -ENOSYS;
 
 	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
@@ -721,6 +723,7 @@ non_memcg:
 	 *  - non-memcg-aware shrinkers
 	 *  - !CONFIG_MEMCG
 	 *  - memcg is disabled by kernel command line
+	 *  - non-slab shrinkers: when memcg kmem is disabled
 	 */
 	size = sizeof(*shrinker->nr_deferred);
 	if (flags & SHRINKER_NUMA_AWARE)
_

Patches currently in -mm which might be from mkoutny@suse.com are


