Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DF725392F
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131257; cv=none; b=adGtm9B/lRZkfWe/OY+wJMtRyQKCDj7Y+znwG1h+gul3n6Uq3enleVdL3ntC2f88vO8vtxqPgMg8qtbe+tCoUMA3ClY2MCIFJoxA9ovYs+Vw2oflScGgYw0mSBnSyht4+gPfMCGC166AR3zRSwIpuPKolb08GXqtkKcCKmkQzyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131257; c=relaxed/simple;
	bh=3Xn1pP2wwylFuONc6LF+s+KpoCGEnu3Vmw0v5C55KfU=;
	h=Date:To:From:Subject:Message-Id; b=s4OA3QIJs6vA0zvKsm/TIcWfqV+Cm14PLC064ERoFmqxLekK0ZLCHq28NPKWKdaOq7+jpQvhQrCNqpEdXmSzb8gGaBQq0nxuheqY6CMqsrvyXNhi+jfkHSDeEghe8jYNMi8K92sLNsSN6p/fEooduOTLCxTcPC7c9ci+stALKz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wADue5Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wADue5Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C82C4CEE4;
	Thu,  1 May 2025 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131257;
	bh=3Xn1pP2wwylFuONc6LF+s+KpoCGEnu3Vmw0v5C55KfU=;
	h=Date:To:From:Subject:From;
	b=wADue5WqEbnc3+dJvnVryXAp33HaZk6hyr7KB3IZlsbqp5+TeqEWFr4zDZG3AgQSY
	 8JWitsjc7B0QIbyrjHQ4sxQnpWWc+K6/LmXtv8xWO2xwrtsrspZ/jepqvsxYZP9gVW
	 ZhwW9B5JarOkzkO3CmuQruDjLTeB4NXvc95h0Ffw=
Date: Thu, 01 May 2025 13:27:36 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-introduce-ksm_stat-at-memcg-v2.patch added to mm-new branch
Message-Id: <20250501202737.73C82C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol: introduce ksm_stat at memcg-v2
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-introduce-ksm_stat-at-memcg-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-introduce-ksm_stat-at-memcg-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: introduce ksm_stat at memcg-v2
Date: Thu, 1 May 2025 04:14:18 +0000

With the enablement of container-level KSM (e.g., via prctl), there is a
growing demand for container-level observability of KSM behavior. 
However, current cgroup implementations lack support for exposing
KSM-related metrics.

This patch introduces a new interface named ksm_stat at the cgroup
hierarchy level, enabling users to monitor KSM merging statistics
specifically for containers where this feature has been activated,
eliminating the need to manually inspect KSM information for each
individual process within the memcg-v2.

Users can obtain the KSM information of a cgroup just by:

        `cat /sys/fs/cgroup/memory.ksm_stat`

Link: https://lkml.kernel.org/r/20250501041418.3324279-1-xu.xin16@zte.com.cn
Co-developed-by: Haonan Chen <chen.haonan2@zte.com.cn>
Signed-off-by: Haonan Chen <chen.haonan2@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/memcontrol.c~memcontrol-introduce-ksm_stat-at-memcg-v2
+++ a/mm/memcontrol.c
@@ -4467,6 +4467,40 @@ static int memory_numa_stat_show(struct
 }
 #endif
 
+#ifdef CONFIG_KSM
+struct memcg_ksm_stat {
+	unsigned long ksm_rmap_items;
+};
+
+static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
+{
+	struct mm_struct *mm;
+	struct memcg_ksm_stat *ksm_stat = arg;
+
+	mm = get_task_mm(task);
+	if (mm) {
+		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		mmput(mm);
+	}
+
+	return 0;
+}
+
+static int memcg_ksm_stat_show(struct seq_file *m, void *v)
+{
+	struct memcg_ksm_stat ksm_stat;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	/* Initialization */
+	ksm_stat.ksm_rmap_items = 0;
+	/* summing all processes'ksm statistic items of this cgroup hierarchy */
+	mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
+	seq_printf(m, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
+
+	return 0;
+}
+#endif
+
 static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
@@ -4639,6 +4673,12 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_numa_stat_show,
 	},
 #endif
+#ifdef CONFIG_KSM
+	{
+		.name = "ksm_stat",
+		.seq_show = memcg_ksm_stat_show,
+	},
+#endif
 	{
 		.name = "oom.group",
 		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

