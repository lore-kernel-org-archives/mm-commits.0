Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F4F42A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247860; cv=none; b=OjFj4r8RGGWRDoOxofXC7GuLzYplm22zJz3lP9Ac8MQdREVQeFPWeCblTYGSOmWahvyQ/6wAkOSryCvG5RvRDDK5oAwbO9jBRUouKTuTKghpYCaivIT+3Onad6hoCPvIKk9DKIgP9lXYfU4ce6WSsLNk9VdswwXOm19ovg0xwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247860; c=relaxed/simple;
	bh=j2NkK2AgGoPxjSxWOHioL2O+20vIxsCmKOfJsmB7EmM=;
	h=Date:To:From:Subject:Message-Id; b=crSruRi5VGWxLo/OI5Qm0bZCzxcEZ/mIqgPfVNjkO1iBd2iO4IqbnZjQuiI9fwQvwv70sYhgKrSRAIaTJhO253X8eUFHJgAx2/DCy3YZ3kxBVXcu3Aq3tGOBRbEPpIzcUDq7QReX+fCDRk+aSrLmcEt/FNH6DqUh7FwvAaJpTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTx9dHvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTx9dHvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB61C4CEC2;
	Mon,  2 Sep 2024 03:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247860;
	bh=j2NkK2AgGoPxjSxWOHioL2O+20vIxsCmKOfJsmB7EmM=;
	h=Date:To:From:Subject:From;
	b=qTx9dHvqMhpqvFkpLNzO9OP5zfRdeeQXBw7CCJQpkaezFtCv1ZTbbijK6mgYN1nfm
	 0+E07+yQYYeQOpTVApKN1oU+Kh4fTeaEUFT7/R9ECTKnn2ND+x2PDWBVArNEZvrnst
	 AkAdF8aV9YdxgerwLT3gxJoeytn+qZxODxx+oCDo=
Date: Sun, 01 Sep 2024 20:30:59 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-initiate-deprecation-of-oom_control.patch removed from -mm tree
Message-Id: <20240902033100.7DB61C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: initiate deprecation of oom_control
has been removed from the -mm tree.  Its filename was
     memcg-initiate-deprecation-of-oom_control.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1994,6 +1994,9 @@ static ssize_t memcg_write_event_control
 		event->register_event = mem_cgroup_usage_register_event;
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
+		pr_warn_once("oom_control is deprecated and will be removed. "
+			     "Please report your usecase to linux-mm-@kvack.org"
+			     " if you depend on this functionality. \n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
@@ -2841,6 +2844,10 @@ static int mem_cgroup_oom_control_write(
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


