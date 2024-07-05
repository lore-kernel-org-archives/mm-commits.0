Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886EBE4D
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141623; cv=none; b=T9zicKY+XCw1IN/URR7zTKrwFNtIFu678sKHfL0E3hIJW834x/vD01YidnOZT3rlxJvhOxv2Wh9bb2mMDshqZATU413WCYyd7cVP1Re8cpJeysyH+UwZBfofEaVgvguQslFz7RkmVwNDJXxbrLQKXlBhQanSvJVXMn5PO2uGTRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141623; c=relaxed/simple;
	bh=DSNQvoxGKlUFRMq1U25ZHHvTjM5/92mQLMnSgODHtfQ=;
	h=Date:To:From:Subject:Message-Id; b=F/IJvfHcnTn2TEb3z7d/h4uZiPZj3AMa1oBaU8FwbV6f06phUMaLVfzXkHyPw6DwDXELIT1Uu3Yu7RMQheiqywW3CDsnaCyzRGa3J7+LhYAEQeQPrZxgnlgtpea5R2HmkafIb4Of4LWx5yMCf0MLbkvqltixNheOSndnECVVYKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KeQ9opT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KeQ9opT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E3DC3277B;
	Fri,  5 Jul 2024 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141623;
	bh=DSNQvoxGKlUFRMq1U25ZHHvTjM5/92mQLMnSgODHtfQ=;
	h=Date:To:From:Subject:From;
	b=KeQ9opT+FZWheG6G+Gmxn/AjaZjOBiEwltdbr3LY4MzhVgYhXqjJrDXh29386omA/
	 V13ungAcXy1zlv9tyEsnWbUI21IZ5EY29oQ9ZCgAG++/IAxj7exPa22mutrGQQIyAP
	 KI7LsXUolRcW+fEcox1KM4GqEzzsHJFohU/jyrbU=
Date: Thu, 04 Jul 2024 18:07:02 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch removed from -mm tree
Message-Id: <20240705010703.26E3DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: gather memcg1-specific fields initialization in memcg1_memcg_init()
has been removed from the -mm tree.  Its filename was
     mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: gather memcg1-specific fields initialization in memcg1_memcg_init()
Date: Fri, 28 Jun 2024 21:03:12 +0000

Gather all memcg1-specific struct mem_cgroup's members initialization in a
new memcg1_memcg_init() function, defined in mm/memcontrol-v1.c. 
Obviously, if CONFIG_MEMCG_V1 is not set, there is no need to initialize
these fields, so the function becomes trivial.

Link: https://lkml.kernel.org/r/20240628210317.272856-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    9 +++++++++
 mm/memcontrol-v1.h |    2 ++
 mm/memcontrol.c    |    6 +-----
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol.c
@@ -3589,13 +3589,9 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
-	INIT_LIST_HEAD(&memcg->oom_notify);
-	mutex_init(&memcg->thresholds_lock);
-	spin_lock_init(&memcg->move_lock);
 	vmpressure_init(&memcg->vmpressure);
-	INIT_LIST_HEAD(&memcg->event_list);
-	spin_lock_init(&memcg->event_list_lock);
 	memcg->socket_pressure = jiffies;
+	memcg1_memcg_init(memcg);
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
 	INIT_LIST_HEAD(&memcg->objcg_list);
--- a/mm/memcontrol-v1.c~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol-v1.c
@@ -1961,6 +1961,15 @@ out_kfree:
 	return ret;
 }
 
+void memcg1_memcg_init(struct mem_cgroup *memcg)
+{
+	INIT_LIST_HEAD(&memcg->oom_notify);
+	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
+	INIT_LIST_HEAD(&memcg->event_list);
+	spin_lock_init(&memcg->event_list_lock);
+}
+
 void memcg1_css_offline(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_event *event, *tmp;
--- a/mm/memcontrol-v1.h~mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init
+++ a/mm/memcontrol-v1.h
@@ -71,6 +71,7 @@ int memory_stat_show(struct seq_file *m,
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
+void memcg1_memcg_init(struct mem_cgroup *memcg);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
@@ -119,6 +120,7 @@ extern struct cftype mem_cgroup_legacy_f
 
 #else	/* CONFIG_MEMCG_V1 */
 
+static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
 static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline bool memcg1_wait_acct_move(struct mem_cgroup *memcg) { return false; }
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

