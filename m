Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AF01EF0BB
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119338; cv=none; b=nSuQZ4gw/kCP0GlkF1NIIB+Bf5ajs7Yw7X/qTTC79Qvf49mLk0+L5afrR/dl6eDs/CEMKVbvTeg7RrNYFtiY86KbuP1R9FBKhN9BWFKmFrQNoW4hv6cO3RnzQDa/fZqkmCU9QRdhXjBB0/PE+2TZ2YlQkTLRI6AIgLv78pD7xIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119338; c=relaxed/simple;
	bh=R91jp96pJZGWeRFgGii7tT1Qhiei5OJ/847KMuN8QJs=;
	h=Date:To:From:Subject:Message-Id; b=aafe/p5d10BTBprr0MG+7LcXB60jMLDxd53NuVG1u89tag9y4nd5lHQfERYo7v6/1h+yxXgHCeUYciVrJ4+D9c1xomz4KaG6FO/aGZfRZFrTeeQ+WYuEW3rhaEJlzcX7hjfTicBW/HVXYJJKRmeDHC9fcEvPvYyahAuxTYxUKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aeh80mY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aeh80mY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C972CC4CEE4;
	Tue, 13 May 2025 06:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119337;
	bh=R91jp96pJZGWeRFgGii7tT1Qhiei5OJ/847KMuN8QJs=;
	h=Date:To:From:Subject:From;
	b=Aeh80mY9vkKqMiQ5yqrDCFHUF50lwH5s0impSjqiJi1KsFkcGjD7dYx9XU+xNwSCY
	 94wOt0HpuHl0YUKucMKTcXH9IiZ1WhnSRls/8gwJgebGHbWduhzsGHm9dyxqvmzAN1
	 ucdj75QGU6oSByMIBv/c9o2zWOYxLWWMx4RwsHa8=
Date: Mon, 12 May 2025 23:55:37 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch removed from -mm tree
Message-Id: <20250513065537.C972CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: add ksm_profit in cgroup/memory.ksm_stat
has been removed from the -mm tree.  Its filename was
     memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: add ksm_profit in cgroup/memory.ksm_stat
Date: Thu, 1 May 2025 04:15:49 +0000

Users can obtain ksm_profit of a cgroup just by:

/ # cat /sys/fs/cgroup/memory.ksm_stat
ksm_rmap_items 76800
ksm_zero_pages 0
ksm_merging_pages 76800
ksm_profit 309657600

[akpm@linux-foundation.org: make ksm_process_profit() available on CONFIG_PROCFS=n]
Link: https://lkml.kernel.org/r/20250501041549.3324472-1-xu.xin16@zte.com.cn
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

 mm/ksm.c        |    2 --
 mm/memcontrol.c |    4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat
+++ a/mm/ksm.c
@@ -3268,7 +3268,6 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-#ifdef CONFIG_PROC_FS
 /*
  * The process is mergeable only if any VMA is currently
  * applicable to KSM.
@@ -3293,7 +3292,6 @@ long ksm_process_profit(struct mm_struct
 	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SYSFS
 /*
--- a/mm/memcontrol.c~memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat
+++ a/mm/memcontrol.c
@@ -4471,6 +4471,7 @@ struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
 	long ksm_zero_pages;
 	unsigned long ksm_merging_pages;
+	long ksm_profit;
 };
 
 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -4483,6 +4484,7 @@ static int evaluate_memcg_ksm_stat(struc
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
+		ksm_stat->ksm_profit += ksm_process_profit(mm);
 		mmput(mm);
 	}
 
@@ -4498,6 +4500,7 @@ static int memcg_ksm_stat_show(struct se
 	ksm_stat.ksm_rmap_items = 0;
 	ksm_stat.ksm_zero_pages = 0;
 	ksm_stat.ksm_merging_pages = 0;
+	ksm_stat.ksm_profit = 0;
 
 	/* summing all processes'ksm statistic items of this cgroup hierarchy */
 	mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
@@ -4505,6 +4508,7 @@ static int memcg_ksm_stat_show(struct se
 	seq_printf(m, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
 	seq_printf(m, "ksm_zero_pages %ld\n", ksm_stat.ksm_zero_pages);
 	seq_printf(m, "ksm_merging_pages %ld\n", ksm_stat.ksm_merging_pages);
+	seq_printf(m, "ksm_profit %ld\n", ksm_stat.ksm_profit);
 
 	return 0;
 }
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


