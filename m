Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6F0770E2
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612492; cv=none; b=tCPi/IQeAFDnNXWULVjQafZHhw9/nChdEW4bA2AAPjiAs4fbLF73bIZrAlxfRrLYs2bgwQE6uzO6Oj8GPXLf8MTqfOEr4yNEsJmRsdrnE3V1Bzh5i6RzOSSGaCYiXSdJc6+t3oXt4L39lBTUkR0XgiJRSr8gJcptzhhLK6BulcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612492; c=relaxed/simple;
	bh=oUZ1tzXSCmpLP6YOMRu9DbJnbSvYw9P52//OI4Pk2qI=;
	h=Date:To:From:Subject:Message-Id; b=Fq7FnP10qqso9rkHIaC08DW95Y282QINodcgonr7L/39zdSP28Ws63F6OkmRiLR0ZuTtRHW83Sq4gRvLopEAy8zqgbCPlOF7/8R+qnCKKvX0MSuTTAB5qtkAxRtCKvanBmJpZmWB0b9pqYmWS6hez7ZLnAaigjK3D01WUQhfiNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=htAQ75KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="htAQ75KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABEBC2BBFC;
	Fri, 28 Jun 2024 22:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612491;
	bh=oUZ1tzXSCmpLP6YOMRu9DbJnbSvYw9P52//OI4Pk2qI=;
	h=Date:To:From:Subject:From;
	b=htAQ75KKSrR2KgCWk9TclP6ps6i7aFfz7Xn2MeHVzRoVY9gf67d9DCafgOTfKyrKE
	 rj+C595SZnKUBG3WXq/bCw8ccf7QteN/ryxHEp7oOpwbcDt8aDz7NX6TdOw+KIEDPI
	 Uf+Vjav6UvLAKw/tom0UA1Y3KPE+HBZm8SRSHba0=
Date: Fri, 28 Jun 2024 15:08:11 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch added to mm-unstable branch
Message-Id: <20240628220811.BABEBC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: put struct task_struct::memcg_in_oom under CONFIG_MEMCG_V1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: put struct task_struct::memcg_in_oom under CONFIG_MEMCG_V1
Date: Fri, 28 Jun 2024 21:03:16 +0000

The memcg_in_oom field of the struct task_struct is not used by the cgroup
v2's memory controller, so it can be happily compiled out if
CONFIG_MEMCG_V1 is not set.

Link: https://lkml.kernel.org/r/20240628210317.272856-9-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h~mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1
+++ a/include/linux/sched.h
@@ -1447,9 +1447,11 @@ struct task_struct {
 	unsigned int			kcov_softirq;
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_V1
 	struct mem_cgroup		*memcg_in_oom;
+#endif
 
+#ifdef CONFIG_MEMCG
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

