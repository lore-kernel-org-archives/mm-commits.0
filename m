Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093162DECBF
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725480; cv=none; b=Ra588iIdDR89u6CnQwfyy/V40lQm4XpzRKl6lcxHfvEuIq33NLFAkUCjiEBMhNdu1i5MGYwPyZaR+gvKwnNXOEvO/hU80wV9CXfoEFCIDv4nrpmlCizU2zTE2RkQk2ETVhKSFlpI7WSctETbRRQoQi9rLXIljtERro7e6/Fd8dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725480; c=relaxed/simple;
	bh=mylQ9gk3eNaWbGAIOyPgsTyKrxjvLXlxahEZdnFhCfc=;
	h=Date:To:From:Subject:Message-Id; b=IKv84W3ocIHfmQkc4LzehvxLDDc4JHPYll+3KxDta+dY4CP+ulBM7yL1uyMolZLYKQbV15r/ZKIKNfjQ+oKa+CtoPr0XuS28kq0J8s6B3BYzIpoBhd8ReJqYkKPvwqinQklWoO4gbjIgiD7r2Ll3bni05yRDY6hd0dbUffeyom0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhxkfrTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhxkfrTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9294C116C6;
	Tue,  6 Jan 2026 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725479;
	bh=mylQ9gk3eNaWbGAIOyPgsTyKrxjvLXlxahEZdnFhCfc=;
	h=Date:To:From:Subject:From;
	b=YhxkfrTnBNAhKVxddaMr2ElDdYjR8suCPLBniQ2HciCAYSiC00co+LjY1JLKG+vPD
	 TRBxF23v23LqLFPE5WLYsLeImDcGqUR8dt9fspzZ3EJvGHl7BsqiDSMzUiL6unvV4g
	 Pen7rUQ1W0KtagZ9vUPYazULh54TCzA1CXB1/agY=
Date: Tue, 06 Jan 2026 10:51:19 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch added to mm-new branch
Message-Id: <20260106185119.C9294C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino() unconditionally
has been added to the -mm mm-new branch.  Its filename is
     memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch
memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

