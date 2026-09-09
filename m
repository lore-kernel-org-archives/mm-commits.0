Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C2F34041B;
	Wed,  9 Sep 2026 06:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788935329; cv=none; b=jI3HBgqRVYRz4N715f18JI0ihxqBrMajnH+6MUxOOteX51ryejfPMkrbydIXHDnP1cRRXKjtD93QaRcNW94bj4WYXpe/2n2Pgo2yKdqoqARJQcBfeYXL5LftqnpWUh+5aZkPf//i6h15aggt1p+WtvJD2OaXCsfj/tXWhuogJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788935329; c=relaxed/simple;
	bh=/YBVqqCwlG/Y4qiqYDB9YF4ISlUJYzsCVg2EbmPnp2g=;
	h=Date:To:From:Subject:Message-Id; b=jmJOTXEYJodZqHdk4qTLpNrVlZhNhoX4quaOubYsVdZb3HVbrk8rP82W88QJBo5oPhVWkm+Udj4QP6YTmfvrP+9NEIRiyU7vFqXuSua1VRmNRfZGsW/no9/sCeR9i1Obc/tD/rC5rMWkO61ZSE69mGCFeHWWkvVIyVCZNQbgnU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfpVwsnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfpVwsnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C460A1F00A3D;
	Wed,  9 Sep 2026 06:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788935327;
	bh=TQ7whNqDQHLlkHRvY/G7kN+8iaXJTi9neRVI+YvtObA=;
	h=Date:To:From:Subject;
	b=gfpVwsnb4klgy37b8AH+qL64ETgO6ftY2+YRlNtBcA76jfgPImlQSSdLzMZb9rH52
	 Bq/3vdZwR1zSYXh2sDfvMVI14KsQ/bIFBr0JuJQEgDPdTKTEPFHwez9MWPuzMSEnUM
	 q/rJSRf1cF6Y8xFY+67b27pBoKWiNzFiUqFZw6j0=
Date: Tue, 08 Sep 2026 23:28:47 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,david@fromorbit.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch removed from -mm tree
Message-Id: <20260909062847.C460A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
has been removed from the -mm tree.  Its filename was
     mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
Date: Wed, 2 Sep 2026 15:37:59 +0800

With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
never allocates an id, so shrinker->id keeps the 0 it got from the
kzalloc() in shrinker_alloc().  __list_lru_init() then copies that 0 into
lru->shrinker_id, where it looks like a valid bit index.

Nothing calls expand_shrinker_info() on nokmem either, so shrinker_nr_max
stays 0 and every memcg ends up with an empty map (map_nr_max == 0).

deferred_split_folio() hands a real memcg to __list_lru_add() regardless
of whether the lru is memcg aware, so the first THP queued in a cgroup
does set_shrinker_bit(memcg, nid, 0) and trips the bounds check:

WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
Call Trace:
 <TASK>
 deferred_split_folio+0x18c/0x220
 map_anon_folio_pmd_nopf+0xdd/0x130
 map_anon_folio_pmd_pf+0x14/0xb0
 do_huge_pmd_anonymous_page+0x1a1/0x620
 __handle_mm_fault+0xea9/0x10d0
 handle_mm_fault+0xe5/0x320
 do_user_addr_fault+0x1cc/0x870
 exc_page_fault+0x81/0x1b0
 asm_exc_page_fault+0x27/0x30
 </TASK>

Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[] read
from happening, but the id should not look valid in the first place. 
Clear it before returning.

Two other spots could paper over this: drop the id in __list_lru_init()
when nokmem turns memcg_aware off, or make deferred_split_folio() pass
NULL like list_lru_add_obj() does.  Both leave shrinker->id lying around
for the next caller, so fix it where the id is handed out.

Link: https://lore.kernel.org/20260902073800.305481-1-jiayuan.chen@linux.dev
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shrinker.c~mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem
+++ a/mm/shrinker.c
@@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct s
 {
 	int id;
 
+	shrinker->id = -1;
+
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

