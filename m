Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB84A02
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745631960; cv=none; b=XtY0wU3egi7XejongUxI3nGTNnHzcC3EyKb+zSCvaSc64RAp6pzwyYsGinI0dFV5qC4HVFvpQqsuGcFmHbYdSfz2R1glDMUOeMO7bWm7Jj2qJLj39eeefhBt7USJiKLMshLNap2xASe5c8lnBealcfMvVBW7WlkKSK9XWd9UF+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745631960; c=relaxed/simple;
	bh=qB9Dceqf9vojF8SsTnihWnFuFhBf0giTiSksuLJYY+o=;
	h=Date:To:From:Subject:Message-Id; b=LtCR4/JAKfm8/rF6nBhuuTAnmDcVE8gISB0B/4Za6QIQ8UqN4lHteXliPp4+WvLSV4fHA4FoPZhokEbR0snSKQyKvWknEqP6grcDeKaK/1Dwkq/tUG+i8GNmOJQ78rWLNaK4nS1xWcTMxujJt9PSJniBhe2aFw6pO/kqw8cDLJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=il47e+5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="il47e+5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9636C4CEE4;
	Sat, 26 Apr 2025 01:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745631959;
	bh=qB9Dceqf9vojF8SsTnihWnFuFhBf0giTiSksuLJYY+o=;
	h=Date:To:From:Subject:From;
	b=il47e+5hZ65PsH2a9/5WLEa4ySUbuJdSxFldKQqImCi0RpKsk2DMLYJSuQ5zw4yEj
	 44+HTlM3E+ZD2klwRVOHrytOJyJUlWEA7H1tjYLSobT3vsG5tpiUHlT3tm6Gk/9OzQ
	 AS3Na4VvcyUz1VHUwxvvLA9YzONqIr1jztnaOZdg=
Date: Fri, 25 Apr 2025 18:45:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,shijie@os.amperecomputing.com,shakeel.butt@linux.dev,rrangel@chromium.org,roman.gushchin@linux.dev,pmladek@suse.com,paulmck@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,linux@rasmusvillemoes.dk,kpsingh@kernel.org,hannes@cmpxchg.org,guoweikang.kernel@gmail.com,francesco@valla.it,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-kmem_cache-when-alloc-memcg.patch added to mm-unstable branch
Message-Id: <20250426014559.A9636C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: use kmem_cache when alloc memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-kmem_cache-when-alloc-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-kmem_cache-when-alloc-memcg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huan Yang <link@vivo.com>
Subject: mm/memcg: use kmem_cache when alloc memcg
Date: Fri, 25 Apr 2025 11:19:24 +0800

When tracing mem_cgroup_alloc() with kmalloc ftrace, we observe:

kmalloc: call_site=mem_cgroup_css_alloc+0xd8/0x5b4 ptr=000000003e4c3799
    bytes_req=2312 bytes_alloc=4096 gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1
    accounted=false

The output indicates that while allocating mem_cgroup struct (2312 bytes),
the slab allocator actually provides 4096-byte chunks. This occurs because:

1. The slab allocator predefines bucket sizes from 64B to 8096B
2. The mem_cgroup allocation size (2312B) falls between the 2KB and 4KB
   slabs
3. The allocator rounds up to the nearest larger slab (4KB), resulting in
   ~1KB wasted memory per allocation

This patch introduces a dedicated kmem_cache for mem_cgroup structs,
achieving precise memory allocation. Post-patch ftrace verification shows:

kmem_cache_alloc: call_site=mem_cgroup_css_alloc+0xbc/0x5d4
    ptr=00000000695c1806 bytes_req=2312 bytes_alloc=2368
    gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1 accounted=false

Each memcg alloc offer 2368bytes(include hw cacheline align), compare to
4096, avoid waste.

Link: https://lkml.kernel.org/r/20250425031935.76411-3-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Francesco Valla <francesco@valla.it>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Huang Shijie <shijie@os.amperecomputing.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Raul E Rangel <rrangel@chromium.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-use-kmem_cache-when-alloc-memcg
+++ a/mm/memcontrol.c
@@ -96,6 +96,8 @@ static bool cgroup_memory_nokmem __ro_af
 /* BPF memory accounting disabled? */
 static bool cgroup_memory_nobpf __ro_after_init;
 
+static struct kmem_cache *memcg_cachep;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
@@ -3663,7 +3665,7 @@ static struct mem_cgroup *mem_cgroup_all
 	int __maybe_unused i;
 	long error;
 
-	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
+	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
@@ -5049,6 +5051,7 @@ __setup("cgroup.memory=", cgroup_memory)
  */
 int __init mem_cgroup_init(void)
 {
+	unsigned int memcg_size;
 	int cpu;
 
 	/*
@@ -5066,6 +5069,10 @@ int __init mem_cgroup_init(void)
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_stock);
 
+	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
+	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
+					 SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from link@vivo.com are

mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch
mm-memcg-use-kmem_cache-when-alloc-memcg.patch
mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch

