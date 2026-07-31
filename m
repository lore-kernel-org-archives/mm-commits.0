Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6230B33939D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465836; cv=none; b=lBfHc02zPAqHDpQg6bANRUT+uZqcMRm6Xvp7mq6dv/6rdMvUAClMl5CGMPmx2fbWoESKqmoYhDtD07cEkoHVSM7pblSiaCPeKzuj/yD/FdYeq1t3bSfbASPYlXoX1Tl5GEUfwMJr9+B56tS8/rXcmj0gPt1ap+GM7nbrPO3phRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465836; c=relaxed/simple;
	bh=cGuV8DJdH6h4yrpd8LOoTboHI5ceSZxE8uTS5Ss0DcY=;
	h=Date:To:From:Subject:Message-Id; b=ubURn1rc5T+NXxtTG0vO2qYyJ97lpGz6TJRJofV6Y4EsYs7qpY5yOTCcAkK5yX2H+oPF8PYMnMePz5wiTxbVT64E18bbapZMd6yBm6YKU6eF0kcA6ztjciHnaqMZd6wX7Is/riAvhPQ41ZAHoplGol64i40eLhYRXMLUluox0xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/PgZ9XA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/PgZ9XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3929F1F000E9;
	Fri, 31 Jul 2026 02:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465835;
	bh=W/oz6TWXUFxwq/nN9sKMAM2SuLnH0qjZ0jP19d6Bvyk=;
	h=Date:To:From:Subject;
	b=o/PgZ9XANbgxexFQwpUS77e7KIcnISUXORseHmXwYqT5LkmPaObY59izF9sFCURrs
	 hfehAoAEpMY7wdtzhRq+Wsq0g8UFkKzTIKlyhQpPn+pax2H2oO+Mhf7CROLKB4NNr4
	 x+Z86xoaeNiIIUJeDesLehRyS5ZkCoa8G2H7S6tw=
Date: Thu, 30 Jul 2026 19:43:54 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,chengming.zhou@linux.dev,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-reset-zswap-settings-in-css_reset.patch removed from -mm tree
Message-Id: <20260731024355.3929F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: reset zswap settings in css_reset
has been removed from the -mm tree.  Its filename was
     mm-memcg-reset-zswap-settings-in-css_reset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm: memcg: reset zswap settings in css_reset
Date: Thu, 2 Jul 2026 10:48:25 +0800

mem_cgroup_css_reset() is called when the memory controller is disabled on
a cgroup but the memcg cannot be destroyed because it is pinned by a
subsystem dependency -- for example, the io controller declares
.depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
and the css is hidden rather than killed.

The purpose of css_reset is to revert the memcg to its vanilla state so
that no policies are applied and the css can be safely made visible again
later.  Currently, all page counters (memory.max, swap.max, kmem.max,
tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
reset to their defaults, but zswap_max and zswap_writeback are not.

These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
zswap_writeback inherited from parent) but were missing from css_reset. 
As a result, stale zswap policies remain in effect after css_reset: the
zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
zswap_max limit, and the writeback path continues to honor the old
zswap_writeback setting, even though the memory controller has been
"disabled" on this cgroup.

Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
their defaults in css_alloc.

Test:
	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control

	mkdir /sys/fs/cgroup/test
	mkdir /sys/fs/cgroup/test/child

	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max

	# child/memory.swap.max and child/memory.zswam.max disappear
	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# re-enable memory control
	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# before this patch
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    8192

	# after this patch, same as memory.swap.max
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    max

Link: https://lore.kernel.org/20260703063826.306878-1-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/20260702024827.353185-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-reset-zswap-settings-in-css_reset
+++ a/mm/memcontrol.c
@@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_ZSWAP
+	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->zswap_writeback, true);
+#endif
 #ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

