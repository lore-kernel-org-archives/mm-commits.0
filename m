Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EB1223708
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131262; cv=none; b=VKIVup6v0qKa6YxANl/qzSD8/gNqlHMztZ7Ru3eosMPhRSgqjyWOIae2VtWy3Gi5P2C8xYM2AHKmefJl+QZV/8UlWZmc/F1nUeQYZBcDI3t/4EOKulV9dqPproO+FRLzW1eSRgoUiEbE2+B0/jZgeVW/brFi72d+p1ANz3benWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131262; c=relaxed/simple;
	bh=sx/+VWAUM1aKObtX4/HDBAAZfCj8qsgiJR0ugFxfBOk=;
	h=Date:To:From:Subject:Message-Id; b=WAhUzu29lE2UP3mIvMdko0sBAdIGtLIc83QkHggkxleiWD4zHI3kENzzXrjtElQhYqSy+Hm1INa5auGuMX8JU5KGFJJgaYptcjXQWifec2eL4qlUaE2r764Vkh6afTJdBUDj9KkZLd8H6rVxx/dIc+cLrq+DVI8O2Oi9TV0l7Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aEHOsKdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aEHOsKdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3A3C4CEE3;
	Thu,  1 May 2025 20:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131262;
	bh=sx/+VWAUM1aKObtX4/HDBAAZfCj8qsgiJR0ugFxfBOk=;
	h=Date:To:From:Subject:From;
	b=aEHOsKdma5fsq/OqtByqdS3tLGl9WRxBhNED/nntfTV6f/uMbdydy1KiyCPrn1DsD
	 5r8Ps1d8ctZrK2juJa746htZC8tfwr/joLrpZ9bMg391gcji0WPafcvdjBnxVkLV3H
	 2PEvt+0lF6K2fPdbplno2UskXfe9KmMsVI5okYo8=
Date: Thu, 01 May 2025 13:27:42 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-v1-add-ksm_stat-at-memcg-v1.patch added to mm-new branch
Message-Id: <20250501202742.9C3A3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol-v1: add ksm_stat at memcg-v1
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-v1-add-ksm_stat-at-memcg-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-v1-add-ksm_stat-at-memcg-v1.patch

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
Subject: memcontrol-v1: add ksm_stat at memcg-v1
Date: Thu, 1 May 2025 04:16:47 +0000

With the enablement of container-level KSM (e.g., via prctl), there is a
growing demand for container-level observability of KSM behavior. 
However, current cgroup implementations lack support for exposing
KSM-related metrics.

This patch introduces a new interface named ksm_stat at the cgroup
hierarchy level, enabling users to monitor KSM merging statistics
specifically for containers where this feature has been activated,
eliminating the need to manually inspect KSM information for each
individual process within the cgroup-v1.

Since the implementation of ksm_stat has been added into memcg-v2, this
just add it back to memcg-v1 with the same function of traversing the
process of the memcg.

Users can obtain the KSM information of a cgroup just by:

        `cat /sys/fs/cgroup/memory.ksm_stat`

Link: https://lkml.kernel.org/r/20250501041647.3324541-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
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

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol-v1.c         |    6 ++++++
 mm/memcontrol.c            |    2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/include/linux/memcontrol.h
@@ -939,6 +939,8 @@ unsigned long lruvec_page_state(struct l
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+int memcg_ksm_stat_show(struct seq_file *m, void *v);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1416,6 +1418,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline int memcg_ksm_stat_show(struct seq_file *m, void *v)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
--- a/mm/memcontrol.c~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/mm/memcontrol.c
@@ -4493,7 +4493,7 @@ static int evaluate_memcg_ksm_stat(struc
 	return 0;
 }
 
-static int memcg_ksm_stat_show(struct seq_file *m, void *v)
+int memcg_ksm_stat_show(struct seq_file *m, void *v)
 {
 	struct memcg_ksm_stat ksm_stat;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
--- a/mm/memcontrol-v1.c~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/mm/memcontrol-v1.c
@@ -2080,6 +2080,12 @@ struct cftype mem_cgroup_legacy_files[]
 		.seq_show = memcg_numa_stat_show,
 	},
 #endif
+#ifdef CONFIG_KSM
+	{
+		.name = "ksm_stat",
+		.seq_show = memcg_ksm_stat_show,
+	},
+#endif
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
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

