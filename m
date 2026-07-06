Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C6A3A75BD;
	Mon,  6 Jul 2026 23:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379810; cv=none; b=GpvxrTvHjnsocNlFig97Yt0uZrb57R9H5Ep7IUFFv+RF74ss3HUeIK2+TdEnaeQCYGxz+Bo547hWsUjsuz5vti7c/V7qIn+DDripAfNY/JmvnYtEDorrPF3bb+vrrbuI8FfYGkfkEwUAfnxqATAPXQdUQ5ex8ICv0QZrs8lS0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379810; c=relaxed/simple;
	bh=lMK5IY/GLwCKqSc0EPzjsvQTP1hko0NMVzIVzDZxOpg=;
	h=Date:To:From:Subject:Message-Id; b=e41MqYvFbl7TGTkiKCpPa9qcsC1TYSzKPO6jGg3d2eGpQO1M+EzBqobnXsy5bPx5sF8xZd56MkIevecAz79KkIxm7QcetkHPfvkAhwqvlHMMO5rKuVyl61N9ViPIAuorRUXVKgLIMVoryAgn7c/N5WIiC723WJkp/Divw6fm9Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ya+tqX8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ya+tqX8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A221F000E9;
	Mon,  6 Jul 2026 23:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379808;
	bh=8SOhLGoqJbJihhgr4HsVj9xf2+MXkkekLW95+/gxOJA=;
	h=Date:To:From:Subject;
	b=Ya+tqX8fYAeakqOH5QjLkswE++rE295yDaiiv/vDnCIyWtDGwFYgnT1vg4rfpRgxO
	 pA6jYSNH2+hAqEvck7jcpHOPpG1tsPWr4QRK/KiCNNP7MXFDHrqbIuuXDOkkz2PSA6
	 CmN7Za9xlSLlIS0kPTEDxdmE8f/j8n/QxUuniRcM=
Date: Mon, 06 Jul 2026 16:16:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,tj@kernel.org,stable@vger.kernel.org,ridong.chen@linux.dev,rakie.kim@sk.com,mkoutny@suse.com,matthew.brost@intel.com,longman@redhat.com,linux@rasmusvillemoes.dk,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,farhad.alemi@berkeley.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch removed from -mm tree
Message-Id: <20260706231648.86A221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
has been removed from the -mm tree.  Its filename was
     cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Mon, 6 Jul 2026 10:20:23 +0200

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask once we reach that code path.

[david@kernel.org: add a comment, slightly rephrase description]
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Link: https://lore.kernel.org/20260706082023.60832-1-david@kernel.org
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,12 @@ void cpuset_update_tasks_nodemask(struct
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		/*
+		 * For v1 we can have empty effective_mems, but we cannot
+		 * attach any tasks (see cpuset_can_attach_check()). For v2,
+		 * effective_mems is guaranteed to not be empty.
+		 */
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
_

Patches currently in -mm which might be from farhad.alemi@berkeley.edu are


