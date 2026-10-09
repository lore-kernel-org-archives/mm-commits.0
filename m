Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554243FE375
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525420; cv=none; b=ZSfBP2lk/qEzWQlCVukO1CnklXzjySIXV60wasXSQTxbfce0J5MgiCd+KyH9FsO17zdYH1NtoV+YtQLY+qjiWJO7/Fz4Ti9iCTKxMlogluqg+x2xvmtu9NFCkcjuRL4hdIM86LGI6oNt2qvwDyGam8x4B4iVyN/9ZS8chYIcMpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525420; c=relaxed/simple;
	bh=NhEI67H28T/vHLJIQStH0eOD+q+1OCuVY+GgFJVxrlg=;
	h=Date:To:From:Subject:Message-Id; b=uqYMtzOwEQRf0EMPHZOl9OZQbtJT7dD2cOEHRTRPAlHRCwmcQN41O6R8J83QnRRpX5EwGfkKj8s6DPnqWiZRRCglEEaY7lrFWweA6Vi6NetJ7WSwLEacQr6rBjLsZNOLsoTOBnCHQLXhV9uaHjdVHXvvVgZr3rnj/gmrmvmqMAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xH523AfV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xH523AfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D260E1F00893;
	Fri,  9 Oct 2026 05:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525418;
	bh=hhCxsVSKouFJfzlEe+KNzXrKvDv6lKTYlsfhBgXpHGM=;
	h=Date:To:From:Subject;
	b=xH523AfVv3rr4B3JmPGUWmVS8rqGEgLyOrSfmSQN/ksvznskh6R6TdqEeqPMaVhHM
	 X5MTlCF6iK3zE5nfw+ad+OYIh4N6fEx+eroaDPyulKkK4bdiBzk8QaYTVgk3I+z3BR
	 RI19O6DwFEqW/B3AFpSSMnxAUx8fpJzSQhYtibxM=
Date: Thu, 08 Oct 2026 22:56:58 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,hannes@cmpxchg.org,stevensd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch removed from -mm tree
Message-Id: <20261009055658.D260E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: don't call schedule_work when no spinning is allowed
has been removed from the -mm tree.  Its filename was
     memcg-dont-call-schedule_work-when-no-spinning-is-allowed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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


