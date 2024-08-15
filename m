Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C1F156C49
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723765289; cv=none; b=eRz9W4vt6zAgOQyInr9R4qlI1aiz+vp053s06vVUo+Z7h0zDdUEHy7zQY5tbHLjaDhqq0okKN+7YdeC1Hv/e0VzaG+WGj5KJ3sa9aRk7CVMQK0+ct4qxHhqM/FEsUwaspfF4pavaewSzn308az+jtXadzOVknh2a4cTLofNDR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723765289; c=relaxed/simple;
	bh=5V022hWlOJUeX3baCIkCqUn+bfACkw05f7gA7bW8+0g=;
	h=Date:To:From:Subject:Message-Id; b=TKvyBQP5ufaOApP1WnbRb3encOOgK4Pf51hF2OdAev8UR4PCFijef6AZ880Rxh+h/iMvubQ+59BKf3B/nVpOwReJOwg2D4KjFBg4jx036fDp1ZxQ4Pkdzi12SQDfNQciqC5/I9CD6mq28WUAu7SWL6dzM5QvZSO3H//h7fANTqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNeUpJrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNeUpJrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F06C4AF0C;
	Thu, 15 Aug 2024 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723765289;
	bh=5V022hWlOJUeX3baCIkCqUn+bfACkw05f7gA7bW8+0g=;
	h=Date:To:From:Subject:From;
	b=RNeUpJrtVcDKjk6e4hAzTp4WQom6XCjfODze3Uge8yWuaQmScJhQjIjURlN/Sb/zj
	 zfhYeXS2ybe3uizNttTluTY2rDu+uA/BL0aIOI0eDB1nu4zt1CItm6PybiCTnZzgGr
	 tz113ieFKPD0+e0JAWamXuhHSfywGSKYXJ8dCnV0=
Date: Thu, 15 Aug 2024 16:41:28 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-initiate-deprecation-of-oom_control.patch added to mm-unstable branch
Message-Id: <20240815234128.E8F06C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: initiate deprecation of oom_control
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-initiate-deprecation-of-oom_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-initiate-deprecation-of-oom_control.patch

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
Subject: memcg: initiate deprecation of oom_control
Date: Wed, 14 Aug 2024 15:00:20 -0700

The oom_control provides functionality to disable memcg oom-killer,
notifications on oom-kill and reading the stats regarding oom-kills.  This
interface was mainly introduced to provide functionality for userspace
oom-killers.  However it is not robust enough and only supports OOM
handling in the page fault path.

For v2, the users can use the combination of memory.events notifications,
memory.high and PSI to provide userspace OOM-killing functionality. 
Actually LMKD in Android and OOMd in systemd and Meta infrastructure
already use PSI in combination with other stats to implement userspace
OOM-killing.

Let's start the deprecation process for v1 and gather the info on how the
current users are using this interface and work on providing a more robust
functionality in v2.

Link: https://lkml.kernel.org/r/20240814220021.3208384-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    8 ++++++--
 mm/memcontrol-v1.c                             |    7 +++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-initiate-deprecation-of-oom_control
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -92,6 +92,8 @@ Brief summary of control files.
                                      This knob is deprecated and shouldn't be
                                      used.
  memory.oom_control		     set/show oom controls.
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
  memory.kmem.limit_in_bytes          Deprecated knob to set and read the kernel
@@ -846,8 +848,10 @@ It's applicable for root and non-root cg
 
 .. _cgroup-v1-memory-oom-control:
 
-10. OOM Control
-===============
+10. OOM Control (DEPRECATED)
+============================
+
+THIS IS DEPRECATED!
 
 memory.oom_control file is for OOM notification and other controls.
 
--- a/mm/memcontrol-v1.c~memcg-initiate-deprecation-of-oom_control
+++ a/mm/memcontrol-v1.c
@@ -1991,6 +1991,9 @@ static ssize_t memcg_write_event_control
 		event->register_event = mem_cgroup_usage_register_event;
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
+		pr_warn_once("oom_control is deprecated and will be removed. "
+			     "Please report your usecase to linux-mm-@kvack.org"
+			     " if you depend on this functionality. \n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
@@ -2838,6 +2841,10 @@ static int mem_cgroup_oom_control_write(
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("oom_control is deprecated and will be removed. "
+		     "Please report your usecase to linux-mm-@kvack.org if you "
+		     "depend on this functionality. \n");
+
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

