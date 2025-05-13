Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CACA1F03D6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119335; cv=none; b=hBvMEfbDodsrVgg1zYHFhrIfloClKyh40aE2Sd9i/UhpCoAD/58zoFdXNUlN8bdlpwBw5qReXTpM6prlRkD4HfTa9oziradFygVc9ZdNEFTM2680LqlNLXgt2rSyY2k+ntY6VdYfPPoa17wWJdUgd+Gz7yZuPo9PvDoL/6fsX54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119335; c=relaxed/simple;
	bh=bTHztQf3AB5lxpQ1NLdjQLNQG89dzi7LLaYRRI08d+4=;
	h=Date:To:From:Subject:Message-Id; b=Gg44v9gfr+MPq18VHKyJfq9FuiOFZTj1H61njArdDjxIGxw22Ej/TVRCC8McLKxNvrvJOyI6+GufVTgclqLGvE350pJAZ0e5zXBLe9et1TUWGet9fbMIZCGR/4x9h//vhB4hzbFciuByWDFWn2STKmspHzVC6E0UpocfQ14Bilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OIrNSEzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OIrNSEzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737BCC4CEE4;
	Tue, 13 May 2025 06:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119335;
	bh=bTHztQf3AB5lxpQ1NLdjQLNQG89dzi7LLaYRRI08d+4=;
	h=Date:To:From:Subject:From;
	b=OIrNSEzPR0iSZXy6tJB3V5dsLBoTkvVTZyzwHbMN7jRmazhp/0ZYnDsEDqEKscuwn
	 Vm4ko31yaY5i+UBiWpT4Lqf7SzGycChZiYgVYtT/o4uvF1Kvhgm+jJR81s+Jro7J5O
	 vtVPCXGR6hOPeCuSX3Z+sN39bpVcz7tJLWJBEkUA=
Date: Mon, 12 May 2025 23:55:34 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch removed from -mm tree
Message-Id: <20250513065535.737BCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: add ksm_zero_pages in cgroup/memory.ksm_stat
has been removed from the -mm tree.  Its filename was
     memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: add ksm_zero_pages in cgroup/memory.ksm_stat
Date: Thu, 1 May 2025 04:14:43 +0000

Users can obtain ksm_zero_pages of a cgroup just by:

/ # cat /sys/fs/cgroup/memory.ksm_stat
ksm_rmap_items 76800
ksm_zero_pages 0

Link: https://lkml.kernel.org/r/20250501041443.3324342-1-xu.xin16@zte.com.cn
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

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat
+++ a/mm/memcontrol.c
@@ -64,6 +64,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/ksm.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -4468,6 +4469,7 @@ static int memory_numa_stat_show(struct
 #ifdef CONFIG_KSM
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
+	long ksm_zero_pages;
 };
 
 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -4478,6 +4480,7 @@ static int evaluate_memcg_ksm_stat(struc
 	mm = get_task_mm(task);
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		mmput(mm);
 	}
 
@@ -4491,9 +4494,12 @@ static int memcg_ksm_stat_show(struct se
 
 	/* Initialization */
 	ksm_stat.ksm_rmap_items = 0;
+	ksm_stat.ksm_zero_pages = 0;
+
 	/* summing all processes'ksm statistic items of this cgroup hierarchy */
 	mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
 	seq_printf(m, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
+	seq_printf(m, "ksm_zero_pages %ld\n", ksm_stat.ksm_zero_pages);
 
 	return 0;
 }
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


