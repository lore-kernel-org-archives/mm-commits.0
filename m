Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE8B2528EF
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131259; cv=none; b=Te+wPcLHE4D5L4Fh6SE0w4OnWfhVfKCbQOMi0FNFKWtePRG6dj8c7pTSS1M4RIO4aoxXfdSTGpjaUcl18POJR34rDM37AdOfR7SQmdI2xwpu9/8VeSYfh/ST9B5InhoBd2apVF28BLjk2pCu+08dfYnbAPqmxtEZlXu7w99s5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131259; c=relaxed/simple;
	bh=VBNemLGr0juO8exb9nIktKKF7GMHL5t1jV8kzUqLy7o=;
	h=Date:To:From:Subject:Message-Id; b=Dfv/+LWgWGyWO4khvQxaRQusXDYiAG0EEub9wgwxOVK6hMEpgQK58JGM7araGIoypg5Bf5BI9he4s5BRWkPePkd19KEmDpecrkMpZoocUDRTSx2HjxY6K/wpO/U3b/CxRfsx2e2gS+FVelKbpEOoVA2KDnj/Jq24X3JPzVwsVRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHkCiKNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHkCiKNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3031C4CEE3;
	Thu,  1 May 2025 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131258;
	bh=VBNemLGr0juO8exb9nIktKKF7GMHL5t1jV8kzUqLy7o=;
	h=Date:To:From:Subject:From;
	b=MHkCiKNIbOxIbfH5eBG+mHGndI8tLRe6XfFzpDUMMdJl4i9ZUgDbJXCm9v1HsRMSM
	 O7n0oeZIqftlWL8orBdX+EoAry0JHOvKT3YSePA6HBX6QcEBtgKW/wcnhMvK/CLeol
	 LVX2daJa56AZU7QlLCGC8UgfRG79GRWAZU72kUD8=
Date: Thu, 01 May 2025 13:27:38 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch added to mm-new branch
Message-Id: <20250501202738.B3031C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcontrol: add ksm_zero_pages in cgroup/memory.ksm_stat
has been added to the -mm mm-new branch.  Its filename is
     memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch

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
@@ -4470,6 +4471,7 @@ static int memory_numa_stat_show(struct
 #ifdef CONFIG_KSM
 struct memcg_ksm_stat {
 	unsigned long ksm_rmap_items;
+	long ksm_zero_pages;
 };
 
 static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
@@ -4480,6 +4482,7 @@ static int evaluate_memcg_ksm_stat(struc
 	mm = get_task_mm(task);
 	if (mm) {
 		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
 		mmput(mm);
 	}
 
@@ -4493,9 +4496,12 @@ static int memcg_ksm_stat_show(struct se
 
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

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

