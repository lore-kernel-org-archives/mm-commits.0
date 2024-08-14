Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2161B86C1
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669086; cv=none; b=iTIcG2JNBdjV2E5PKuUe+ioe6PUZDmD28CcQ9EGwmU7pb8PYlAefs1g/GaAJEsSRprH4oARmsSKt1aaasodx8z+3d4WUaWOuqlQBf2EWczQ41CcQsV96CKFf9W+Xg2khLcGllP1NS3ngRLWe6C00W7ZuGrfApbtL1Uaue4dxlB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669086; c=relaxed/simple;
	bh=i7SHBYirrcNFo02OG52F7q8q18z5CJJ3BtLfi6Xq0ns=;
	h=Date:To:From:Subject:Message-Id; b=PXkPoH7IdNcUwFm6pi2rfIg8RbqGoFvsT18wOUhwjGEqnHtHoNX1LG+nKzCPyKFqfY6mtObSJRIeyKXOIP2IyhNnGfRyGO/HBf4+i5iohlBaEBFXHUpvvu/OGke7tCa8RKugeZh93WFSClp0n52im1KbnMti6P4dQkF19nf9C8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPl3149w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPl3149w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA130C116B1;
	Wed, 14 Aug 2024 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723669086;
	bh=i7SHBYirrcNFo02OG52F7q8q18z5CJJ3BtLfi6Xq0ns=;
	h=Date:To:From:Subject:From;
	b=DPl3149wRoqJDLTTvxkWyAFdJYiHSZ+whXTsZvuoa2FdZMWII+HnEilP6Rt/lZciL
	 9CuavUYJzRkajYa3mSBDkSO68soCvHq2lLG6VCTCvtw0/KMl1QAx6864gv7a5elPx8
	 ecS5GIU2qMsAMWpuH2gSk6Xgc4on4JWtLNb6gWlc=
Date: Wed, 14 Aug 2024 13:58:05 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-initiate-deprecation-of-pressure_level.patch added to mm-unstable branch
Message-Id: <20240814205805.EA130C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: initiate deprecation of pressure_level
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-initiate-deprecation-of-pressure_level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-initiate-deprecation-of-pressure_level.patch

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
Subject: memcg: initiate deprecation of pressure_level
Date: Wed, 14 Aug 2024 13:28:25 -0700

The pressure_level in memcg v1 provides memory pressure notifications to
the user space.  At the moment it provides notifications for three levels
of memory pressure i.e.  low, medium and critical, which are defined based
on internal memory reclaim implementation details.  More specifically the
ratio or scanned and reclaimed pages during a memory reclaim.  However
this is not robust as there are workloads with mostly unreclaimable user
memory or kernel memory.

For v2, the users can use PSI for memory pressure status of the system or
the cgroup.  Let's start the deprecation process for pressure_level and
add warnings to gather the info on how the current users are using this
interface and how they can be used to PSI.

Link: https://lkml.kernel.org/r/20240814202825.2694077-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    8 ++++++--
 mm/memcontrol-v1.c                             |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-initiate-deprecation-of-pressure_level
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -86,6 +86,8 @@ Brief summary of control files.
                                      used.
  memory.force_empty		     trigger forced page reclaim
  memory.pressure_level		     set memory pressure notifications
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
@@ -898,8 +900,10 @@ At reading, current status of OOM is sho
           The number of processes belonging to this cgroup killed by any
           kind of OOM killer.
 
-11. Memory Pressure
-===================
+11. Memory Pressure (DEPRECATED)
+================================
+
+THIS IS DEPRECATED!
 
 The pressure level notifications can be used to monitor the memory
 allocation cost; based on the pressure, applications can implement
--- a/mm/memcontrol-v1.c~memcg-initiate-deprecation-of-pressure_level
+++ a/mm/memcontrol-v1.c
@@ -1910,6 +1910,9 @@ static ssize_t memcg_write_event_control
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
+		pr_warn_once("pressure_level is deprecated and will be removed. "
+			     "Please report your usecase to linux-mm-@kvack.org "
+			     "if you depend on this functionality. \n";
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

