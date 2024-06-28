Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1779B8E
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612482; cv=none; b=fgtJbguY9ULoybD389kp8D7l3CwWNTWf6tmsXp4bqgV27ch1rHZNrxO52bFzsUFZIAkK1Dzvwv7+Oq446QrJLovXoBqZjJy1fLjaoHL9/8TuWJvMboHnU+TY/Gnglaabx6kracrdX/FJehOfjciwWea8gzSQUVRbhs+fdQE0VpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612482; c=relaxed/simple;
	bh=HPH3E/L6A1IhZXkKk86DED5UTSHOpIbMQC+/XywsTuQ=;
	h=Date:To:From:Subject:Message-Id; b=UCTdP6vOBPAf61y6SrqUmL7W0PEKZA4ajqqGhckYBqECeGQkClFVcCM5RNrbkmAd/euPKpBBXleXH4aWIg8AxfFWVnYuOouaKUHhl3spMtNitdJ7xZnCJ/gvdBtieTylea8EUOtSl1V3zjMv4HHSQdWAPwCI3rj5LDk3oQJZ0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzBAElhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzBAElhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA14C116B1;
	Fri, 28 Jun 2024 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612481;
	bh=HPH3E/L6A1IhZXkKk86DED5UTSHOpIbMQC+/XywsTuQ=;
	h=Date:To:From:Subject:From;
	b=IzBAElhYttfed69nqhxdBwBE+yYctJgVwUqj1OGLrNPQ/+3Hmrla8PUw4GjE9q7BL
	 4sdolbV7ppGYsTnr5B6DYeNVQ9HCvue58oQiOqsUxoZQT9d0YHBmtfShkM95f5AoTU
	 oPMemoJ1j9I1zCsR3Phlh+RrsvtsxX3ZYEl/0AZc=
Date: Fri, 28 Jun 2024 15:08:01 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch added to mm-unstable branch
Message-Id: <20240628220801.8FA14C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: guard cgroup v1-specific code in mem_cgroup_print_oom_meminfo()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch

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
Subject: mm: memcg: guard cgroup v1-specific code in mem_cgroup_print_oom_meminfo()
Date: Fri, 28 Jun 2024 21:03:11 +0000

Put cgroup v1-specific code in mem_cgroup_print_oom_meminfo() under
CONFIG_MEMCG_V1.

Link: https://lkml.kernel.org/r/20240628210317.272856-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo
+++ a/mm/memcontrol.c
@@ -1535,6 +1535,7 @@ void mem_cgroup_print_oom_meminfo(struct
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
 			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
+#ifdef CONFIG_MEMCG_V1
 	else {
 		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->memsw)),
@@ -1543,6 +1544,7 @@ void mem_cgroup_print_oom_meminfo(struct
 			K((u64)page_counter_read(&memcg->kmem)),
 			K((u64)memcg->kmem.max), memcg->kmem.failcnt);
 	}
+#endif
 
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
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

