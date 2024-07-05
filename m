Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF9947E
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141603; cv=none; b=HuJ0DMcg+YXhVbmEils4kgEXoammXHzdeZmqO+7YJ9BMgdq4I8ylYwsZ30u5b+IK7ihO5EO8HUmcOXRfbtvCj676jS2epI49f88Mn2e1pbGG9+kVBbXiS08OBmBbHvmThN471v70afTOAX4psQW4hsGBEIBehhI/lY4F4/gMf2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141603; c=relaxed/simple;
	bh=i5eCA0hMdTVlnWVf2aFVaOGUrsZ9vYKYDD/a1yV2kqU=;
	h=Date:To:From:Subject:Message-Id; b=NOuEAwuXucPnaAYUZwd3rW6xxJJaWgCJcpOQDQHAH+KP74IjLQ/Vyz/zg6YZUW4+vp/8q8OsIKB/6/HrpnTp1B7cE4cx0Ep6E8tVZ60ZARtixWiEpS+3TqIIHICdfC8bOwVe6pOb0T/+F+55VJgeZJyr6FabiFAtZEmBkqiPYJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IbADOE32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IbADOE32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6817C3277B;
	Fri,  5 Jul 2024 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141602;
	bh=i5eCA0hMdTVlnWVf2aFVaOGUrsZ9vYKYDD/a1yV2kqU=;
	h=Date:To:From:Subject:From;
	b=IbADOE32CUVMRTbx8quNN7wGsKAA49kd8Kgtyp7525HW9Sj0WJvTcwHyFyk+6quz4
	 6dew3Hynihe0PW3/YW2e65CxKJn6dSq4NguOWJkMEMFT7py1sqdzsg/yOl9GC7O4F3
	 BKndXOFQSvsiUwB6HM+29E71jKReJYYLu+hLQUNw=
Date: Thu, 04 Jul 2024 18:06:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-rename-charge-move-related-functions.patch removed from -mm tree
Message-Id: <20240705010642.C6817C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: rename charge move-related functions
has been removed from the -mm tree.  Its filename was
     mm-memcg-rename-charge-move-related-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: rename charge move-related functions
Date: Mon, 24 Jun 2024 17:58:57 -0700

Rename exported function related to the charge move to have the memcg1_
prefix.

Link: https://lkml.kernel.org/r/20240625005906.106920-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   14 +++++++-------
 mm/memcontrol-v1.h |    8 ++++----
 mm/memcontrol.c    |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol.c
@@ -2580,7 +2580,7 @@ retry:
 	 * At task move, charge accounts can be doubly counted. So, it's
 	 * better to wait until the end of task_move if something is going on.
 	 */
-	if (mem_cgroup_wait_acct_move(mem_over_limit))
+	if (memcg1_wait_acct_move(mem_over_limit))
 		goto retry;
 
 	if (nr_retries--)
@@ -5995,12 +5995,12 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_free = mem_cgroup_css_free,
 	.css_reset = mem_cgroup_css_reset,
 	.css_rstat_flush = mem_cgroup_css_rstat_flush,
-	.can_attach = mem_cgroup_can_attach,
+	.can_attach = memcg1_can_attach,
 #if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
 	.attach = mem_cgroup_attach,
 #endif
-	.cancel_attach = mem_cgroup_cancel_attach,
-	.post_attach = mem_cgroup_move_task,
+	.cancel_attach = memcg1_cancel_attach,
+	.post_attach = memcg1_move_task,
 #ifdef CONFIG_MEMCG_KMEM
 	.fork = mem_cgroup_fork,
 	.exit = mem_cgroup_exit,
--- a/mm/memcontrol-v1.c~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol-v1.c
@@ -384,7 +384,7 @@ unlock:
 	return ret;
 }
 
-bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg)
 {
 	if (mc.moving_task && current != mc.moving_task) {
 		if (mem_cgroup_under_move(memcg)) {
@@ -1056,7 +1056,7 @@ static void mem_cgroup_clear_mc(void)
 	mmput(mm);
 }
 
-int mem_cgroup_can_attach(struct cgroup_taskset *tset)
+int memcg1_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL; /* unneeded init to make gcc happy */
@@ -1126,7 +1126,7 @@ int mem_cgroup_can_attach(struct cgroup_
 	return ret;
 }
 
-void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
+void memcg1_cancel_attach(struct cgroup_taskset *tset)
 {
 	if (mc.to)
 		mem_cgroup_clear_mc();
@@ -1285,7 +1285,7 @@ retry:
 	atomic_dec(&mc.from->moving_account);
 }
 
-void mem_cgroup_move_task(void)
+void memcg1_move_task(void)
 {
 	if (mc.to) {
 		mem_cgroup_move_charge();
@@ -1294,14 +1294,14 @@ void mem_cgroup_move_task(void)
 }
 
 #else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
+int memcg1_can_attach(struct cgroup_taskset *tset)
 {
 	return 0;
 }
-static void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
+void memcg1_cancel_attach(struct cgroup_taskset *tset)
 {
 }
-static void mem_cgroup_move_task(void)
+void memcg1_move_task(void)
 {
 }
 #endif
--- a/mm/memcontrol-v1.h~mm-memcg-rename-charge-move-related-functions
+++ a/mm/memcontrol-v1.h
@@ -29,11 +29,11 @@ static inline int try_charge(struct mem_
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
 
-bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg);
+bool memcg1_wait_acct_move(struct mem_cgroup *memcg);
 struct cgroup_taskset;
-int mem_cgroup_can_attach(struct cgroup_taskset *tset);
-void mem_cgroup_cancel_attach(struct cgroup_taskset *tset);
-void mem_cgroup_move_task(void);
+int memcg1_can_attach(struct cgroup_taskset *tset);
+void memcg1_cancel_attach(struct cgroup_taskset *tset);
+void memcg1_move_task(void);
 
 struct cftype;
 u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

