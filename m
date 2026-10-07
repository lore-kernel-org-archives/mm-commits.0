Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2FF2DC765
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334210; cv=none; b=pv98ZC5aH5baeRRIoGvbsAZnOVWc2W3AQUUwqUDINXBVnTrJ2zNlIrn3texG7Dt1vTLn1jfEwvTdNzOo8Vj2fEm/1IUFgrdqAfYNxRWz3YxiwReed2abXi2H2HM5d1J16xo/BjkY/c2xs0yjDZfICZO7VpOz6PDhsX42USSKuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334210; c=relaxed/simple;
	bh=MGFRwDmFvZ49+BP+GybffmF+b6wm+AVvvM6Zq4V35w4=;
	h=Date:To:From:Subject:Message-Id; b=NuFRW4yUjeVfVoP9P1f8Klj09LrlNByjMPlTGk7cop9/yp7B6R+dro7o7Dk+y098cafM9/0piAQn0EFRTkGq4V6gfMcvCh0qiTvPwD/SqV5nJWOJO8F1tAN1XWPlRp9jq92E3bGUFVlWMId8nmbI4QhEs0DMs6Lil0fqu85AsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AWUttjFd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AWUttjFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35971F0089C;
	Wed,  7 Oct 2026 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334209;
	bh=WqAFj2rnHbEsGsfsvF6oRTB9qEY9NIhZ8KTv0qK+jlM=;
	h=Date:To:From:Subject;
	b=AWUttjFdxLs/hyxVk/JUVfGlw2UxBriwoPWWhySyqmRv2Kr/J0RfGhK3YpUDCIsQd
	 Qe1tMXm3XzYeqVeshniJmhiVHEmeyiuLX6jmE5iWUd/U2yAmGw3zTOwJlh8ZLJxFUy
	 MU7zemoOxjbaMYCxq/DzamVJOua3yuM3IqTyncSE=
Date: Tue, 06 Oct 2026 17:50:09 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-clear-flushing_cached_charge-on-cpu-offline.patch removed from -mm tree
Message-Id: <20261007005009.B35971F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
has been removed from the -mm tree.  Its filename was
     memcg-clear-flushing_cached_charge-on-cpu-offline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
Date: Fri, 28 Aug 2026 12:24:19 -0700

Sashiko [1] reported that memcg_hotplug_cpu_dead() drains the stocks of
the CPU which went away but leaves FLUSHING_CACHED_CHARGE alone.

The flag can be set at that point: drain_all_stock() may have claimed the
stock and queued the drain work shortly before the CPU went down. 
workqueue_offline_cpu() unbinds the per-cpu workers, so such a pending
work item is executed by an unbound worker on some other CPU, where
drain_local_memcg_stock() operates on this_cpu_ptr() and thus drains and
clears the flag of that other CPU instead.  Nothing clears the flag of the
dead CPU, so drain_all_stock() would skip its stock forever once the CPU
comes back online.

Clear the flag of both stocks after draining them.

Link: https://lore.kernel.org/20260828192419.3057939-1-shakeel.butt@linux.dev
Link: https://sashiko.dev/#/patchset/20260828135036.7d44361f%40fangorn [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/memcontrol.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-clear-flushing_cached_charge-on-cpu-offline
+++ a/mm/memcontrol.c
@@ -2373,9 +2373,21 @@ void drain_all_stock(struct mem_cgroup *
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
+	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
+
 	/* no need for the local lock */
-	drain_obj_stock(&per_cpu(obj_stock, cpu));
-	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+	drain_obj_stock(obj_st);
+	drain_stock_fully(memcg_st);
+
+	/*
+	 * A drain work queued before the CPU went away is executed by an
+	 * unbound worker on some other CPU and clears that CPU's flag, so
+	 * clear the flags here to make these stocks drainable again once
+	 * the CPU comes back online.
+	 */
+	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
+	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

