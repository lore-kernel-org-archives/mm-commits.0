Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DA1F4E2
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141607; cv=none; b=SEfA4AouC1CoJ3uy3ibRUmY1BuUFKe2LK9jlptoi2xICSWgtm4/VWp4SjwrMheSWBPR7yuihAQGGAcNIr7YBnkXLl8cgSwrj6Pi9JiiXLRAskXz2uWgRgvxbjEn//ZTC7++cvOKL8/9VFpkCfZTjgA7hAyJadmkuMiJ3GjCSq1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141607; c=relaxed/simple;
	bh=ziShACS1r9aHnJyMAIpDTzY2OlkhK3DKVreELq9bxm0=;
	h=Date:To:From:Subject:Message-Id; b=mKcyD1apMwwGEoFpygmlbRDct5AcWJDIZ3ERk3leOnOzuDRznzSAzYLIqcGfGoBQelbL6kDNg11TccZSBLrIwzsat3YHuGSQjsNK12sj785x1l8+FracUH7W66za7aBeVyVpj8hyT4gQxHA0avvuk8Uw6E1NF4e17+1hLd3ze+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b8/+CMeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8/+CMeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A032FC4AF0A;
	Fri,  5 Jul 2024 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141607;
	bh=ziShACS1r9aHnJyMAIpDTzY2OlkhK3DKVreELq9bxm0=;
	h=Date:To:From:Subject:From;
	b=b8/+CMeC2l828w2OrzGz3+cCePmuCpFU6ShwxXM8GiL6R1++RhXn5bZNvhip9sBRT
	 Xvl8GtrGvUDra41ST0IP/jT8T68Hqi46zWG2gZIN2KiiGAeZmRa2EajnHVHgLFhfVE
	 IYCFwjKjpPJvMFshxf5R61otJbyeH7Q42oCuojw4=
Date: Thu, 04 Jul 2024 18:06:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-rename-memcg_oom_recover.patch removed from -mm tree
Message-Id: <20240705010647.A032FC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: rename memcg_oom_recover()
has been removed from the -mm tree.  Its filename was
     mm-memcg-rename-memcg_oom_recover.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: rename memcg_oom_recover()
Date: Mon, 24 Jun 2024 17:59:01 -0700

Rename memcg_oom_recover() into memcg1_oom_recover() for consistency with
other memory cgroup v1-related functions.

Move the declaration in mm/memcontrol-v1.h to be nearby other memcg v1 oom
handling functions.

Link: https://lkml.kernel.org/r/20240625005906.106920-10-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 mm/memcontrol-v1.h |    2 +-
 mm/memcontrol.c    |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol.c
@@ -3165,7 +3165,7 @@ static int mem_cgroup_resize_max(struct
 	} while (true);
 
 	if (!ret && enlarge)
-		memcg_oom_recover(memcg);
+		memcg1_oom_recover(memcg);
 
 	return ret;
 }
@@ -3750,7 +3750,7 @@ static int mem_cgroup_oom_control_write(
 
 	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
-		memcg_oom_recover(memcg);
+		memcg1_oom_recover(memcg);
 
 	return 0;
 }
@@ -5444,7 +5444,7 @@ static void uncharge_batch(const struct
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
 		if (ug->nr_kmem)
 			memcg_account_kmem(ug->memcg, -ug->nr_kmem);
-		memcg_oom_recover(ug->memcg);
+		memcg1_oom_recover(ug->memcg);
 	}
 
 	local_irq_save(flags);
--- a/mm/memcontrol-v1.c~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol-v1.c
@@ -1090,8 +1090,8 @@ static void __mem_cgroup_clear_mc(void)
 
 		mc.moved_swap = 0;
 	}
-	memcg_oom_recover(from);
-	memcg_oom_recover(to);
+	memcg1_oom_recover(from);
+	memcg1_oom_recover(to);
 	wake_up_all(&mc.waitq);
 }
 
@@ -2067,7 +2067,7 @@ static int memcg_oom_wake_function(wait_
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-void memcg_oom_recover(struct mem_cgroup *memcg)
+void memcg1_oom_recover(struct mem_cgroup *memcg)
 {
 	/*
 	 * For the following lockless ->under_oom test, the only required
--- a/mm/memcontrol-v1.h~mm-memcg-rename-memcg_oom_recover
+++ a/mm/memcontrol-v1.h
@@ -13,7 +13,6 @@ static inline void memcg1_soft_limit_res
 
 void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
 void memcg1_check_events(struct mem_cgroup *memcg, int nid);
-void memcg_oom_recover(struct mem_cgroup *memcg);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
 
@@ -92,5 +91,6 @@ ssize_t memcg_write_event_control(struct
 
 bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
 void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
+void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 #endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

