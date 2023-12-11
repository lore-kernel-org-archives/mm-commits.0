Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D753B6
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8SHAjpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD89C433C8;
	Mon, 11 Dec 2023 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256129;
	bh=FapqNPX7Ddcc8SPBlmDNDSGVjBp3xyDJGXN62Flk1GY=;
	h=Date:To:From:Subject:From;
	b=f8SHAjpDLXKCbZnHEAJlgxH4q4AVzDnKf6My3H9pdu0vZftUJW2Pzx84FrK6RznjA
	 V+3NHhonBMXh5+NV+UqW4888m8uNrMe9SDw208IOVK/G1Di626lI53/FPJEL27g5lq
	 Lu+WmvBrAaIvUyNt5ki84WGWlhljKqltbKZHDr+A=
Date: Sun, 10 Dec 2023 16:55:28 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,mhocko@suse.com,jiang.xuexin@zte.com.cn,hughd@google.com,hannes@cmpxchg.org,wang.yong12@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom-dump_tasks-add-rss-detailed-information-printing.patch removed from -mm tree
Message-Id: <20231211005529.6DD89C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, oom:dump_tasks add rss detailed information printing
has been removed from the -mm tree.  Its filename was
     mm-oom-dump_tasks-add-rss-detailed-information-printing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yong Wang <wang.yong12@zte.com.cn>
Subject: mm, oom:dump_tasks add rss detailed information printing
Date: Thu, 23 Nov 2023 18:40:18 +0800 (CST)

When the system is under oom, it prints out the RSS information of each
process.  However, we don't know the size of rss_anon, rss_file, and
rss_shmem.

To distinguish the memory occupied by anonymous or file mappings
or shmem, could help us identify the root cause of the oom.

So this patch adds RSS details, which refers to the /proc/<pid>/status[1].
It can help us know more about process memory usage.

Example of oom including the new rss_* fields:
[ 1630.902466] Tasks state (memory values in pages):
[ 1630.902870] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
[ 1630.903619] [    149]     0   149      486      288        0      288         0    36864        0             0 ash
[ 1630.904210] [    156]     0   156   153531   153345   153345        0         0  1269760        0             0 mm_test

[1] commit 8cee852ec53f ("mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status").

Link: https://lkml.kernel.org/r/202311231840181856667@zte.com.cn
Signed-off-by: Yong Wang <wang.yong12@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/oom_kill.c~mm-oom-dump_tasks-add-rss-detailed-information-printing
+++ a/mm/oom_kill.c
@@ -399,10 +399,11 @@ static int dump_task(struct task_struct
 		return 0;
 	}
 
-	pr_info("[%7d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
+	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
 		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		mm_pgtables_bytes(task->mm),
+		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
+		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
 		get_mm_counter(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
 	task_unlock(task);
@@ -423,7 +424,7 @@ static int dump_task(struct task_struct
 static void dump_tasks(struct oom_control *oc)
 {
 	pr_info("Tasks state (memory values in pages):\n");
-	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+	pr_info("[  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name\n");
 
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are


