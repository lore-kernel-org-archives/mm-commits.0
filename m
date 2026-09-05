Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9021F38B7D7
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788652195; cv=none; b=VApzjHhfCyiGGh9kOXTtywM1N3P7y2KPjMJXhNV+cvKtDKy0ricYizYupQUnXfO5HPmOp3Rmztj9UnKzh5QczBTze/dOdHdB0UE3wozdb2Vqlhx2vLJh1tzAdx58SSotwZZ3kjtQWYWfZUqorcudDntuDSw8JY8U+L6U0UfTLlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788652195; c=relaxed/simple;
	bh=fxlYDkbPyH+W4fE6k8dJxUtrD4xFGWpd6kZCPC8ygjY=;
	h=Date:To:From:Subject:Message-Id; b=p6hQEzIcoM8H4Rgne9cgH4BH8FgKbfhu5emdhXhnx5vSlTVhrd7vp3qG8BJFZsgHR7O33ec99+k8V64zUssv9K+4yfJ/SGjc7lHiJ23dRgs2T0XHXO7nOUQ7HCk+WlbEUAQXmVdNlo9RNo/HUJreD8KxWfpls0aUp2cCJIYNtTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jEOQ8R9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jEOQ8R9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED861F00A3D;
	Sat,  5 Sep 2026 23:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788652194;
	bh=5sM1pitRbeUpKnRhMGM/cSuCzfLSwDww9bfy1YXZ7VM=;
	h=Date:To:From:Subject;
	b=jEOQ8R9n/L01t4jk2jxfMSpcFjPSLnHR8WAXHecTRWnlAQqxt1nIN7TWOL0M7Ijy3
	 K0vWqJTOQzpoCeH51ep/OnT10nQO3LmtgHRpomidn1jXWV5DKKfiYCp4jv46ea6JcS
	 FXBp4oH06QYy+wNmh8CrhwvRmz9Y1H5KxdkLihpc=
Date: Sat, 05 Sep 2026 16:49:53 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,hannes@cmpxchg.org,stevensd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch added to mm-new branch
Message-Id: <20260905234954.3ED861F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: don't call schedule_work when no spinning is allowed
has been added to the -mm mm-new branch.  Its filename is
     memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: David Stevens <stevensd@google.com>
Subject: memcg: don't call schedule_work when no spinning is allowed
Date: Fri, 4 Sep 2026 10:31:45 -0700

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI.  If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Found this via code inspection.  I spent a little bit trying to trigger it
for real, but the only way I managed was by writing a hacky driver absuing
alloc_pages_nolock().

Link: https://lore.kernel.org/20260904173145.2028377-1-stevensd@google.com
Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: David Stevens <stevensd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol.c            |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/irq_work_types.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -233,6 +234,7 @@ struct mem_cgroup {
 #endif
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 	__cacheline_group_end_aligned(memcg_write_hot);
--- a/mm/memcontrol.c~memcg-dont-call-schedule_work-when-no-spinning-is-allowed
+++ a/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/irq_work.h>
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
@@ -2424,6 +2425,11 @@ static void high_work_func(struct work_s
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2832,7 +2838,10 @@ done_restock:
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4207,6 +4216,7 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4415,6 +4425,7 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
_

Patches currently in -mm which might be from stevensd@google.com are

memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

