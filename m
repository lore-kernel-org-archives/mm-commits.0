Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A59C4501A
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746579219; cv=none; b=D+hJ0fM0vjQ2j3WKPbIPns+uSzRRoGjrA+OqgK/n/QG+4XAbGChxFAi+/KTvpfY1gJOxvEQTj1U/ovMJDwi43uHutN3wZZ1w7eB4DWSjZ4zMZTVBLgJReJ/OxwDFcLmq+ZjFtgVOp1iVbAdWQDFL46qN0vER2uidlJoqFOmIZ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746579219; c=relaxed/simple;
	bh=JHdJgW6q6Gd++UZqYEZT77Uk7sEFquWBur2mYMTP/t8=;
	h=Date:To:From:Subject:Message-Id; b=rHu8mFM0WPqK/05XRWrSWmGSFF77sbEuGX4Etx/zsJZYhmw9trAg6vWnswbIGQ7vjIQFIs71oU+/yYybsTGgyAYFXPIzyZ4+N6t9gMpwJgzKaxOIwTSpXAgi9FqWpD5XIpqYfoW5z/N755waA4NvwhBGRY1sy5OuwgCR+IrWiAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDsIoSVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDsIoSVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D189C4CEE4;
	Wed,  7 May 2025 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746579218;
	bh=JHdJgW6q6Gd++UZqYEZT77Uk7sEFquWBur2mYMTP/t8=;
	h=Date:To:From:Subject:From;
	b=fDsIoSVZ3N0i12Z1dWNzyYgjftBzanWyex0QwMg7URtSXXI25SN3vxsH5FJW4yc3U
	 oWA+hyXiqzueLS2txPxM0QROLpO7W+a6OEGDo2Ku8U+zdON1lbxnjE2DMxOy9Nxe0C
	 Gp5uKzkYSi2YnoxNp+e8xpnBvDawQ5z8tZKq4waY=
Date: Tue, 06 May 2025 17:53:38 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,gthelen@google.com,brauner@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-introduce-non-blocking-limit-setting-option-v3.patch added to mm-unstable branch
Message-Id: <20250507005338.9D189C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-introduce-non-blocking-limit-setting-option-v3
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-introduce-non-blocking-limit-setting-option-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-introduce-non-blocking-limit-setting-option-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-introduce-non-blocking-limit-setting-option-v3
Date: Tue, 6 May 2025 16:28:33 -0700

add more explanation in doc and commit message on O_NONBLOCK side-effects
(Johannes)

Link: https://lkml.kernel.org/r/20250506232833.3109790-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   34 ++++++++++++++--------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-introduce-non-blocking-limit-setting-option-v3
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1299,12 +1299,17 @@ PAGE_SIZE multiple when read back.
 	monitors the limited cgroup to alleviate heavy reclaim
 	pressure.
 
-        If memory.high is opened with O_NONBLOCK then the synchronous
-        reclaim is bypassed. This is useful for admin processes that
-        need to dynamically adjust the job's memory limits without
-        expending their own CPU resources on memory reclamation. The
-        job will trigger the reclaim and/or get throttled on its
-        next charge request.
+	If memory.high is opened with O_NONBLOCK then the synchronous
+	reclaim is bypassed. This is useful for admin processes that
+	need to dynamically adjust the job's memory limits without
+	expending their own CPU resources on memory reclamation. The
+	job will trigger the reclaim and/or get throttled on its
+	next charge request.
+
+	Please note that with O_NONBLOCK, there is a chance that the
+	target memory cgroup may take indefinite amount of time to
+	reduce usage below the limit due to delayed charge request or
+	busy-hitting its memory to slow down reclaim.
 
   memory.max
 	A read-write single value file which exists on non-root
@@ -1323,12 +1328,17 @@ PAGE_SIZE multiple when read back.
 	Caller could retry them differently, return into userspace
 	as -ENOMEM or silently ignore in cases like disk readahead.
 
-        If memory.max is opened with O_NONBLOCK, then the synchronous
-        reclaim and oom-kill are bypassed. This is useful for admin
-        processes that need to dynamically adjust the job's memory limits
-        without expending their own CPU resources on memory reclamation.
-        The job will trigger the reclaim and/or oom-kill on its next
-        charge request.
+	If memory.max is opened with O_NONBLOCK, then the synchronous
+	reclaim and oom-kill are bypassed. This is useful for admin
+	processes that need to dynamically adjust the job's memory limits
+	without expending their own CPU resources on memory reclamation.
+	The job will trigger the reclaim and/or oom-kill on its next
+	charge request.
+
+	Please note that with O_NONBLOCK, there is a chance that the
+	target memory cgroup may take indefinite amount of time to
+	reduce usage below the limit due to delayed charge request or
+	busy-hitting its memory to slow down reclaim.
 
   memory.reclaim
 	A write-only nested-keyed file which exists for all cgroups.
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

