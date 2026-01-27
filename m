Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20A83191D2
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486680; cv=none; b=D9dBeMpAy6ngnhViy9kHghDZ4KNQz3LKgMID3X7RRNdk/ZCbAYhAsolVql1QwEk22wpWcA46XJwBGDnyE7Ug+H6pWlKkjD7EJixzT/sJsXYb/IPUQ8oKGp0xomEVPpkQdlcJB9yncjvwuUvt1rPUXxyiX+Nhs/SuIvL29xeEOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486680; c=relaxed/simple;
	bh=yXATSgU4/JM8tI8vtISUFJuYh0cA4K/HmEr6ZCFnNZQ=;
	h=Date:To:From:Subject:Message-Id; b=W6HxBErXsT9m8LL57g1xlaVCdb2AOqbMMGnFKbQRnID8KOM0sbhEJKny4rFQcHnlqrYPO2+x9BwLZFe4VyBXWG0+it7GUbLHL3PGqVjRKFpQvQOVyOhkXp1lZrk5u7mgYNTZIUPS3mAQL7CFEDVRizhvtnexvToT6rM6XhMVXz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFhBWRgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFhBWRgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DC3C116C6;
	Tue, 27 Jan 2026 04:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486680;
	bh=yXATSgU4/JM8tI8vtISUFJuYh0cA4K/HmEr6ZCFnNZQ=;
	h=Date:To:From:Subject:From;
	b=CFhBWRgg5hsY3f3a8OWKFEp/Xf9ryrQojC9qTPfuI/Ub2DEAhuiLtdGXNEwD4DRM0
	 sTq6sIrYJV7xjJt47StFwu+dRrF0QRCwhYB/oLrylY0BIQjl0DBKHkAlU/IX47StN9
	 km3jcx5f0onnht0y/AvQaUrBHMKhE8ilQW3FoPXs=
Date: Mon, 26 Jan 2026 20:04:40 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch removed from -mm tree
Message-Id: <20260127040440.98DC3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
Date: Thu, 25 Dec 2025 15:21:14 -0800

The LRU gen debugfs interface was using the internal private memcg ID
which is meant for tracking kernel objects that outlive their cgroup. 
Switch to using the public cgroup ID instead.

Link: https://lkml.kernel.org/r/20251225232116.294540-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface
+++ a/mm/vmscan.c
@@ -5416,7 +5416,7 @@ static int lru_gen_seq_show(struct seq_f
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5501,7 +5501,7 @@ static int run_eviction(struct lruvec *l
 	return -EINTR;
 }
 
-static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
+static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
 	struct lruvec *lruvec;
@@ -5512,19 +5512,12 @@ static int run_cmd(char cmd, int memcg_i
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
-		rcu_read_lock();
-
-		memcg = mem_cgroup_from_id(memcg_id);
-		if (!mem_cgroup_tryget(memcg))
-			memcg = NULL;
-
-		rcu_read_unlock();
-
+		memcg = mem_cgroup_get_from_ino(memcg_id);
 		if (!memcg)
 			return -EINVAL;
 	}
 
-	if (memcg_id != mem_cgroup_id(memcg))
+	if (memcg_id != mem_cgroup_ino(memcg))
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
@@ -5591,7 +5584,7 @@ static ssize_t lru_gen_seq_write(struct
 		int n;
 		int end;
 		char cmd, swap_string[5];
-		unsigned int memcg_id;
+		u64 memcg_id;
 		unsigned int nid;
 		unsigned long seq;
 		unsigned int swappiness;
@@ -5601,7 +5594,7 @@ static ssize_t lru_gen_seq_write(struct
 		if (!*cur)
 			continue;
 
-		n = sscanf(cur, "%c %u %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
+		n = sscanf(cur, "%c %llu %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
 			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
 			err = -EINVAL;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


