Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE9318EF3
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486675; cv=none; b=cfJP07u86bbhIjGx3f2sIp1//pxeHV0osj9sRLtADpYzLgkbhUcB993QjmUBo9+FcUn9+q2wifmMjTdbh4X1iw5Ujrc7TsGctWdKdlja0JJ0YvEKUH3sCs6PkZUacQvqDo/58mav+BWEXWQmh9+JVNp50p1VPE3HdVzqAbTaH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486675; c=relaxed/simple;
	bh=z6s05iZMEV8D29Q0B1/0qr/1rKhbLJMRhab5hERz4g4=;
	h=Date:To:From:Subject:Message-Id; b=PFdGH3k9MgmFhJT0uJYJaP20cJ8ywzTtFZdSe4b5vxjubN6gk6WohDxbTSilbnqZKM0fvv2b5ddO2bMrF8mK1P+KWY2rTNKPhktJ4SulrQPaIOQeSQzdHBcT2KuVTId0sZOiN7rBMSsbEwTR9ZzI0UC9qLairgQAFLf9FaQQK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1aLOMrVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1aLOMrVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EEFC116C6;
	Tue, 27 Jan 2026 04:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486675;
	bh=z6s05iZMEV8D29Q0B1/0qr/1rKhbLJMRhab5hERz4g4=;
	h=Date:To:From:Subject:From;
	b=1aLOMrVC+wlgGre7uLGVUwPelVQPDODy7cR3HxMlNNt+VHsugJ8ROBStKxAFgHwFi
	 IRwrvahTGzY/1o07whuzfM9b0kwi0tuAKZQ3jEzRem6cc49d1SC77OGNKYcRprbk5Y
	 yzt1+BmlDsXRklmHycSwlF9lkYCn8EcNn93lncXs=
Date: Mon, 26 Jan 2026 20:04:34 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch removed from -mm tree
Message-Id: <20260127040435.38EEFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino() unconditionally
has been removed from the -mm tree.  Its filename was
     memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino() unconditionally
Date: Thu, 25 Dec 2025 15:21:10 -0800

Remove the CONFIG_SHRINKER_DEBUG guards around mem_cgroup_ino() and
mem_cgroup_get_from_ino().  These APIs provide a way to get a memcg's
cgroup inode number and to look up a memcg from an inode number
respectively.

Making these functions unconditionally available allows other in-kernel
users to leverage them without requiring CONFIG_SHRINKER_DEBUG to be
enabled.

No functional change for existing users.

Link: https://lkml.kernel.org/r/20251225232116.294540-3-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |    4 ----
 mm/memcontrol.c            |    2 --
 2 files changed, 6 deletions(-)

--- a/include/linux/memcontrol.h~memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally
+++ a/include/linux/memcontrol.h
@@ -836,14 +836,12 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
-#ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1308,7 +1306,6 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
@@ -1318,7 +1315,6 @@ static inline struct mem_cgroup *mem_cgr
 {
 	return NULL;
 }
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
--- a/mm/memcontrol.c~memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally
+++ a/mm/memcontrol.c
@@ -3620,7 +3620,6 @@ struct mem_cgroup *mem_cgroup_from_id(un
 	return mem_cgroup_from_private_id(id);
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
@@ -3641,7 +3640,6 @@ struct mem_cgroup *mem_cgroup_get_from_i
 
 	return memcg;
 }
-#endif
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


