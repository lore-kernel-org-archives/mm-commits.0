Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F36B134C4
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908564; cv=none; b=tY0uoYro1Gq2Ef+cYN4VCdQz38YGn6BYJncC521plJdTUOVXQCdoEyBE4Q7zZOeyfBXSpU/dDdNZ6c7v35iZn0y/VlNjAFa3Cmam3ruI5IzUEo159OgBvYLfnAmzmiH2QY+9/9eT41NY2/hoekDuA2W0PRNGfGq6dSkk55TMUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908564; c=relaxed/simple;
	bh=MbkMsd5M3P2HtMU7bAe2GYGYt6j4Yc6v3O4SzgUzDyg=;
	h=Date:To:From:Subject:Message-Id; b=kJYYKvQ1f+OpWbKLgejzOEjeB/CeSVNTYexWC0AiVQfRHZ7yIflCW8MTh2ZDZiqTWAMm2e6xpeIc/jJgBlv4+ut4G8tFEfzdKG3rC9Cx/TQS84r5HdZFVKCnqXFVB/laXQnffHVq7Gm858NMDytzV2uIqrn6fErpMJiZNF1xsFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b8ELVvM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8ELVvM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD84C4CEC5;
	Mon,  9 Sep 2024 19:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725908564;
	bh=MbkMsd5M3P2HtMU7bAe2GYGYt6j4Yc6v3O4SzgUzDyg=;
	h=Date:To:From:Subject:From;
	b=b8ELVvM8JgTh/6ZdOPLyVy0kWvjVQ4Sw0LHJbFmixs9egpDcKQhu0ZLsPILEFV79Z
	 j6za+GjLj8Bpdl4wqAutC5f9DahEknkJIuFO4BUpdRF7Bal5dmZNzRKlWE/7rMjlT3
	 gLe2s3u+2cHwa4vVJDO4YipmU76PDeaWYXGiQbxc=
Date: Mon, 09 Sep 2024 12:02:43 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,longman@redhat.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,chenridong@huawei.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch added to mm-unstable branch
Message-Id: <20240909190244.3FD84C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup: disallow mounting v1 hierarchies without controller implementation
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch

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
From: Michal Koutný <mkoutny@suse.com>
Subject: cgroup: disallow mounting v1 hierarchies without controller implementation
Date: Mon, 9 Sep 2024 18:32:22 +0200

The configs that disable some v1 controllers would still allow mounting
them but with no controller-specific files. (Making such hierarchies
equivalent to named v1 hierarchies.) To achieve behavior consistent with
actual out-compilation of a whole controller, the mounts should treat
respective controllers as non-existent.

Wrap implementation into a helper function, leverage legacy_files to
detect compiled out controllers. The effect is that mounts on v1 would
fail and produce a message like:
  [ 1543.999081] cgroup: Unknown subsys name 'memory'

Link: https://lkml.kernel.org/r/20240909163223.3693529-4-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup-v1.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cgroup-v1.c~cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation
+++ a/kernel/cgroup/cgroup-v1.c
@@ -46,6 +46,12 @@ bool cgroup1_ssid_disabled(int ssid)
 	return cgroup_no_v1_mask & (1 << ssid);
 }
 
+static bool cgroup1_subsys_absent(struct cgroup_subsys *ss)
+{
+	/* Check also dfl_cftypes for file-less controllers, i.e. perf_event */
+	return ss->legacy_cftypes == NULL && ss->dfl_cftypes;
+}
+
 /**
  * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
  * @from: attach to all cgroups of a given task
@@ -932,7 +938,8 @@ int cgroup1_parse_param(struct fs_contex
 		if (ret != -ENOPARAM)
 			return ret;
 		for_each_subsys(ss, i) {
-			if (strcmp(param->key, ss->legacy_name))
+			if (strcmp(param->key, ss->legacy_name) ||
+			    cgroup1_subsys_absent(ss))
 				continue;
 			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
 				return invalfc(fc, "Disabled controller '%s'",
@@ -1024,7 +1031,8 @@ static int check_cgroupfs_options(struct
 	mask = ~((u16)1 << cpuset_cgrp_id);
 #endif
 	for_each_subsys(ss, i)
-		if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i))
+		if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i) &&
+		    !cgroup1_subsys_absent(ss))
 			enabled |= 1 << i;
 
 	ctx->subsys_mask &= enabled;
_

Patches currently in -mm which might be from mkoutny@suse.com are

memcg-cleanup-with-config_memcg_v1.patch
cgroup-cpuset-expose-cpuset-filesystem-with-cpuset-v1-only.patch
cgroup-disallow-mounting-v1-hierarchies-without-controller-implementation.patch
cgroup-do-not-report-unavailable-v1-controllers-in-proc-cgroups.patch

