Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FA442A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247862; cv=none; b=PuJDhAC7U2QL4IiaNto7lss4RdIla3AYydsPvem/2GLC+h/4s4EvnG7lLZuH+G0zcKy2Z9zOruIRs3pA/6FheTA4FltKvxAdKmMA/wtKHdhSLWX84DPEamPNn3Gnyl1BFldRgvl6grABDk/8RK2qzlygX8AJ+n6DDphBPfjzgR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247862; c=relaxed/simple;
	bh=xYevQtMMhvfX2NFvH+Mrqa4qJuqaYesaCPrij+AOZ8A=;
	h=Date:To:From:Subject:Message-Id; b=NlCHTPyrupltue/aGXX8nVzqcTkccg8vvnZAPcvdEH2N0PPO2cE8tuTkBwnS21U/79BmYxWnss3C/iOXFHEP2oZLjP9tfGndVsxmXCwhRtaq1vhaCalJd4s0NPStf3Ro7T8z8PvHkbvRWq1mUBnsA7zDMr4A8s7jFkdRSo0ZJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfSxrKSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfSxrKSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2125C4CEC2;
	Mon,  2 Sep 2024 03:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247861;
	bh=xYevQtMMhvfX2NFvH+Mrqa4qJuqaYesaCPrij+AOZ8A=;
	h=Date:To:From:Subject:From;
	b=mfSxrKSRNYKxRuPJni2md1QV4p6KyNiiHktfEobDVQF3aWiLlspVdCu/kMHH3LrQz
	 mZpsfldvznPw06ExKqdJlh2QNig8ziERZB2HsL2ztN9KuIH3L0bT3BKB+r76XDzGg7
	 3KQUKgz8/4/GMqEl5LRziXSBbBqe0WjBm8YELucw=
Date: Sun, 01 Sep 2024 20:31:01 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-initiate-deprecation-of-pressure_level.patch removed from -mm tree
Message-Id: <20240902033101.D2125C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: initiate deprecation of pressure_level
has been removed from the -mm tree.  Its filename was
     memcg-initiate-deprecation-of-pressure_level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: initiate deprecation of pressure_level
Date: Wed, 14 Aug 2024 15:00:21 -0700

The pressure_level in memcg v1 provides memory pressure notifications to
the user space.  At the moment it provides notifications for three levels
of memory pressure i.e.  low, medium and critical, which are defined based
on internal memory reclaim implementation details.  More specifically the
ratio of scanned and reclaimed pages during a memory reclaim.  However
this is not robust as there are workloads with mostly unreclaimable user
memory or kernel memory.

For v2, the users can use PSI for memory pressure status of the system or
the cgroup.  Let's start the deprecation process for pressure_level and
add warnings to gather the info on how the current users are using this
interface and how they can be used to PSI.

Link: https://lkml.kernel.org/r/20240814220021.3208384-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
@@ -2000,6 +2000,9 @@ static ssize_t memcg_write_event_control
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
+		pr_warn_once("pressure_level is deprecated and will be removed. "
+			     "Please report your usecase to linux-mm-@kvack.org "
+			     "if you depend on this functionality. \n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


