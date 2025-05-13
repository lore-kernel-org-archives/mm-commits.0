Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7A81F0985
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119336; cv=none; b=K/IONxW+D9icqBMWOSIooO2E0FBkPV59DezXIk1s8uIPIGZkflfeLrONhjWnCEqJybsb0v9GA0UB5iS370FsqFEieV74FXv1NKqoZOuzKcrcjj2AboFo6tDOFf/6dnj83vcVgW+HpajKkKV7iI7U16cbyOMHm+skOumLG4gybPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119336; c=relaxed/simple;
	bh=UdZJbreOLp2r+LceIG6t7Qyg+hhOl1OHgx90nYaUOog=;
	h=Date:To:From:Subject:Message-Id; b=Vreb0OTd7aApDYeKXEhFUxvK9LwkYnKZfZRdgbQkxdr0+aL3CS+ZEyi543PXZR9NP3WO9K0IBDZfvdsW94t734qMXXEzvypA1PSq1hcQiFyd8J+RYdvi1H74EtJW8Zs6K2vf4dBAMqLkMIPmMLSi0YF/ZOPkjO+CmIZxdvkDJxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iERKx8wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iERKx8wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE5CC4AF0B;
	Tue, 13 May 2025 06:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119336;
	bh=UdZJbreOLp2r+LceIG6t7Qyg+hhOl1OHgx90nYaUOog=;
	h=Date:To:From:Subject:From;
	b=iERKx8wgJpC0H674OS3nyeK2tIulQaiHklDJm+NeUwK5Hel41LKRoSCDr0UzBAQMD
	 OpHBkziBr8F2/EbYFQd8L9rpDaPGkEO+QQhvZL61HeFVT+pbeMzcyEeoGCykYCse0k
	 JN3NaSA78hKxdJPBTw/+zc6PUNEKZE7xFsTSpy/M=
Date: Mon, 12 May 2025 23:55:36 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch removed from -mm tree
Message-Id: <20250513065536.9EE5CC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: add ksm_merging_pages in cgroup/memory.ksm_stat
has been removed from the -mm tree.  Its filename was
     memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol: add ksm_merging_pages in cgroup/memory.ksm_stat
Date: Thu, 1 May 2025 04:15:14 +0000

Users can obtain ksm_merging_pages of a cgroup just by:

/ # cat /sys/fs/cgroup/memory.ksm_stat
ksm_rmap_items 76800
ksm_zero_pages 0
ksm_merging_pages 1092

Link: https://lkml.kernel.org/r/20250501041514.3324403-1-xu.xin16@zte.com.cn
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

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat
+++ a/mm/memcontrol.c
@@ -4470,6 +4470,7 @@ static int memory_numa_stat_show(struct
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
 	long ksm_zero_pages;
+	unsigned long ksm_merging_pages;
 };
 
 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -4481,6 +4482,7 @@ static int evaluate_memcg_ksm_stat(struc
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
 		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
+		ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
 		mmput(mm);
 	}
 
@@ -4495,11 +4497,14 @@ static int memcg_ksm_stat_show(struct se
 	/* Initialization */
 	ksm_stat.ksm_rmap_items = 0;
 	ksm_stat.ksm_zero_pages = 0;
+	ksm_stat.ksm_merging_pages = 0;
 
 	/* summing all processes'ksm statistic items of this cgroup hierarchy */
 	mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
+
 	seq_printf(m, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
 	seq_printf(m, "ksm_zero_pages %ld\n", ksm_stat.ksm_zero_pages);
+	seq_printf(m, "ksm_merging_pages %ld\n", ksm_stat.ksm_merging_pages);
 
 	return 0;
 }
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


