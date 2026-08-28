Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1321F3ABDB3
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 19:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787946962; cv=none; b=gUWxSDBtrndb1nHM4BxNzX2jvVXHemPPc3QITUGkDXzOHQ8oDNtZQzyLkoyRleiF6N/E0qEYLnVoGDIKOjQSBlBMxClu7CO9kt2S4/ZtA8qkZkqSvkinQ+s3O5hGK7T7RR4nYFHJeC0bCK4nDHbTsi67m69WP0Px94bpU0lbSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787946962; c=relaxed/simple;
	bh=AoQomaibxlVSfkdLGHCmMFRZJV0cDBCPsi9ZvUozcJ4=;
	h=Date:To:From:Subject:Message-Id; b=m+YLuF2m2m3O40rDoqCUDhTo0Bqqc3cUDGyNd1ErYTpon0BgABGyYvLe0xtP9trI7nNIyy7/WaPGSMoWoYIJlbUjJzh7e3V3ax39W5zbItrUHRDmAFALIlbOXatT2HDjqsiCtjCpg80q4pmejocCBfzDSTCy5vsMfVaf3f+MQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w8RtY7fX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w8RtY7fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE81E1F000E9;
	Fri, 28 Aug 2026 19:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787946960;
	bh=Wmn4doyzySLbf4XSCPw64wGL6DwXmZQAmeFB4xvI3HM=;
	h=Date:To:From:Subject;
	b=w8RtY7fXwBVAJodpbm0NcUmho7H8df702ICtzAEXirs0eGcS+t4Ts9z6GwqKJv6PG
	 JZOmcvdFI1dQleHi/OVrWXhoi4Jz2m43Xn5UdjfE/TvEbeFc2rFuNUga30aOjRvw4G
	 Be7hCXuwBqO/0gGEZv1hvExXLeKfa5/Zlwbcypc8=
Date: Fri, 28 Aug 2026 12:56:00 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-clear-flushing_cached_charge-on-cpu-offline.patch added to mm-new branch
Message-Id: <20260828195600.AE81E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
has been added to the -mm mm-new branch.  Its filename is
     memcg-clear-flushing_cached_charge-on-cpu-offline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-clear-flushing_cached_charge-on-cpu-offline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-clear-flushing_cached_charge-on-cpu-offline.patch

