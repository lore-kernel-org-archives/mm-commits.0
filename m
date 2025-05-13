Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4651EFFB3
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119334; cv=none; b=jickqLcFa4GlLEIGlAGaqAub0wlW3GQK2XeE+0upttHd9rUoMjhHHgNDl+9c5gqZGQzWogXu9q+VzO4REJFTX6rFFqKu0FwReVKdetIk+uR/n9EoVqILuUoeJ6F/uBfCWzirI/hUmKwme1YEgy+Npae5fBScFcanfNRYU49H430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119334; c=relaxed/simple;
	bh=E+GvSYdsgVrrRVDYL0UO4zTRTVjOGDdmvnnlr9XCwnM=;
	h=Date:To:From:Subject:Message-Id; b=OQaGINdj/G9rRFDEehKG3uhgovyp09kuPV70tMmVevh62UYmy3b8SGgfJUNVNwHHw6lywRQWpSB/w9JdxqdxY7cXawpHj5SSNz9X9MIJvQjLjwUHIXrp2Nks9FdPp5DC/lZp5Vofd3n/CKmir2zZdQyHvxIPWzGpMEiFrBrdPxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1faxQU9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1faxQU9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448C8C4CEE4;
	Tue, 13 May 2025 06:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119334;
	bh=E+GvSYdsgVrrRVDYL0UO4zTRTVjOGDdmvnnlr9XCwnM=;
	h=Date:To:From:Subject:From;
	b=1faxQU9wxMcsTqgkpPxWQZBc0fHY/H04tnuMLRxrOjBPDCfsy8B3JJvk3So/zVqmK
	 sQxUyfo3CxG3BqPOee/FfMtkBJAM8ExBiOHDTWDroOnBTw2MtXgIoUCGOV8+6Qw66n
	 Cycnm9LhYZrSLCYB2tUsOym8+Lap0DgdMJDXtFTg=
Date: Mon, 12 May 2025 23:55:33 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-introduce-ksm_stat-at-memcg-v2.patch removed from -mm tree
Message-Id: <20250513065534.448C8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: introduce ksm_stat at memcg-v2
has been removed from the -mm tree.  Its filename was
     memcontrol-introduce-ksm_stat-at-memcg-v2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4465,6 +4465,40 @@ static int memory_numa_stat_show(struct
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
@@ -4637,6 +4671,12 @@ static struct cftype memory_files[] = {
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


