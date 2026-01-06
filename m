Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EDA30748B
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725495; cv=none; b=UCvVpD28sfjxIugBaa6etPPbtAdwmJYU6jGjwFPECEljDDA7UCy8qIyZ3st60j4QhgG3i+Kpb+XWyIn8x/mPjB3tUmkp09aaOlx/RiEE+dNv1kjMFNSC9mAzn6uH8jP7CWgXoY5Fhjvxw0U8+MARTiYrj/c4rGWx0TbjZ2Ajugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725495; c=relaxed/simple;
	bh=9cmbuaKfxTZdMJ8P0MdrW9Zcy2v76x8QsusPyltDX1s=;
	h=Date:To:From:Subject:Message-Id; b=mfvI3nrmAoBP16sahuqpBWLJTy3lGNvMSjckOqQtUTM2c4Yz+7yjQ69dn8RGcxiiXHYaWdoO5Dwhnfsza5Zm6O6mGYB84ODAGFQ9lq+wBoDMyjhBnOnYSv1KPmp7Yl+Dh1jp5vlNAmXxk6m8i/OK+z0iXRSGF+SSuabSGRILwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e6qdiDgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e6qdiDgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE40C116C6;
	Tue,  6 Jan 2026 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725493;
	bh=9cmbuaKfxTZdMJ8P0MdrW9Zcy2v76x8QsusPyltDX1s=;
	h=Date:To:From:Subject:From;
	b=e6qdiDgR3g2NR1APWiynmecSNOylP6TSuiWAHIAdfHe8m5jhQFI7J/cE/mkqMvXoG
	 j5lmDGlZnnWmFPtodW2k4Z/wJEWd/9fY4Ubb7K+n6+onrKZg5Pj2TZfjcJgzsTOEQL
	 PSE7rfHIT1Ht9PbI9WZXN42uvpM5BBz98oXc59tE=
Date: Tue, 06 Jan 2026 10:51:33 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch added to mm-new branch
Message-Id: <20260106185133.8DE40C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch

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
Subject: memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
Date: Thu, 25 Dec 2025 15:21:15 -0800

Now that all callers have been converted to use either:
 - The private ID APIs (mem_cgroup_private_id/mem_cgroup_from_private_id)
   for internal kernel objects that outlive their cgroup
 - The public cgroup ID APIs (mem_cgroup_ino/mem_cgroup_get_from_ino)
   for external interfaces

Remove the unused wrapper functions mem_cgroup_id() and
mem_cgroup_from_id() along with their !CONFIG_MEMCG stubs.

Link: https://lkml.kernel.org/r/20251225232116.294540-8-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |   18 ------------------
 mm/memcontrol.c            |    5 -----
 2 files changed, 23 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id
+++ a/include/linux/memcontrol.h
@@ -830,12 +830,6 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return mem_cgroup_private_id(memcg);
-}
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
-
 static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
@@ -1282,18 +1276,6 @@ static inline void mem_cgroup_scan_tasks
 {
 }
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	WARN_ON_ONCE(id);
-	/* XXX: This should always return root_mem_cgroup */
-	return NULL;
-}
-
 static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 {
 	return 0;
--- a/mm/memcontrol.c~memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id
+++ a/mm/memcontrol.c
@@ -3615,11 +3615,6 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	return mem_cgroup_from_private_id(id);
-}
-
 struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	struct cgroup *cgrp;
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

