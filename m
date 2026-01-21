Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EB527FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966058; cv=none; b=VXXQl963gonoWMqJY5mdUtPuvWCmoHQ3rjKYbXkGJOoZGoLpM8FRZ28L8QXqmo35yl8UWHEWKDQwuxxQq5qaIA+yEXQ7MkeczKpVDnspJSSXXYqbomXCGy28/3ESzvW2xglV6CmHJH6qkyDByxP/B7gg/LhdXvm+rCcQt4HKiGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966058; c=relaxed/simple;
	bh=866UKMRsgGv5NIbwLnkMGZBvZblqSXSrE6XVZDY+J38=;
	h=Date:To:From:Subject:Message-Id; b=ZtAoEy3pvEl3RYo3XqcKutsJcKzLmOl82Hi1k80NXnXpiMXn6M/Szsr0npBtaWtV8XJ3E6/FzPaqPDqNeM79DS/ZmTTz4OtnA3xp3afev+tmA3TfkbCBvvFk3CApFiZiY3HP45QpsooVemVotFOEFDMA4Q7qD7yy8eA8J+Vma+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRD8GlIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRD8GlIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0281C16AAE;
	Wed, 21 Jan 2026 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966058;
	bh=866UKMRsgGv5NIbwLnkMGZBvZblqSXSrE6XVZDY+J38=;
	h=Date:To:From:Subject:From;
	b=QRD8GlIkNQgp1c1TstZWbbecWbKi2MxSzJ+q8I7b6KnkTJ2NNHeomd77/OzwE5pl3
	 g7XLxLi0MiupKiXTYM9JC7XRnCOBdCRzzXSeqaCCFzQ47EyNt9UAya5YI2stg7qzHq
	 o6Dx4He7a9DF/yCAxfytUtPDqIyHG27oHXJB5jn8=
Date: Tue, 20 Jan 2026 19:27:37 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-mem_cgroup_usage-memcontrol-v1c.patch removed from -mm tree
Message-Id: <20260121032737.E0281C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move mem_cgroup_usage memcontrol-v1.c
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_usage-memcontrol-v1c.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: move mem_cgroup_usage memcontrol-v1.c
Date: Thu, 11 Dec 2025 01:30:18 +0000

Patch series "memcg cleanups", v3.

Two code moves/removals with no behavior change.


This patch (of 2):

Currently, mem_cgroup_usage is only used for v1, just move it to
memcontrol-v1.c

Link: https://lkml.kernel.org/r/20251211013019.2080004-1-chenridong@huaweicloud.com
Link: https://lkml.kernel.org/r/20251211013019.2080004-2-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   22 ++++++++++++++++++++++
 mm/memcontrol-v1.h |    2 --
 mm/memcontrol.c    |   22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

--- a/mm/memcontrol.c~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol.c
@@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	unsigned long val;
-
-	if (mem_cgroup_is_root(memcg)) {
-		/*
-		 * Approximate root's usage from global state. This isn't
-		 * perfect, but the root usage was always an approximation.
-		 */
-		val = global_node_page_state(NR_FILE_PAGES) +
-			global_node_page_state(NR_ANON_MAPPED);
-		if (swap)
-			val += total_swap_pages - get_nr_swap_pages();
-	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
-	}
-	return val;
-}
-
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
--- a/mm/memcontrol-v1.c~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol-v1.c
@@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(
 }
 #endif
 
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	unsigned long val;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/*
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
+		 */
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
+		if (swap)
+			val += total_swap_pages - get_nr_swap_pages();
+	} else {
+		if (!swap)
+			val = page_counter_read(&memcg->memory);
+		else
+			val = page_counter_read(&memcg->memsw);
+	}
+	return val;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
--- a/mm/memcontrol-v1.h~memcg-move-mem_cgroup_usage-memcontrol-v1c
+++ a/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
_

Patches currently in -mm which might be from chenridong@huawei.com are


