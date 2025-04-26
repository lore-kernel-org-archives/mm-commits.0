Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2F04A02
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745631962; cv=none; b=naQ0gTorIQI0gg6IamZT8mb21gmwaY1S+8NCSZuchsh4s+PNBVYFH3AdQBtkPBdBWauLrcIgoHnVPgmGd2Uq+B0hnc3mRzEHtQTWRourK6D3+TC2/nXoK2MSaDSUirc3L9W7x5nKq6Vvcvew4ELXJvwgYsezWKTmDG3PWzNx4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745631962; c=relaxed/simple;
	bh=fvwxBZ9HeuLC+8EZa137BpJqnYP1F9daqI0i8aOzt88=;
	h=Date:To:From:Subject:Message-Id; b=G2UxZuMRCLwEJ8aXSnONunXvRQxK81AZwAHs+FJLaRN3N4rbT2kZ85nmkvilVddCiZWoet++8rdCxQSJ+BHyeYODCPgWQF/1Iaw71+2LZHXk8fXd8KUv3+lH/qzDWAVDG3xRMivk1sW0146P+dMq21+Y8MGlm3PicRaxMQ1YCOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bF0BQB/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bF0BQB/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BFBC4CEE4;
	Sat, 26 Apr 2025 01:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745631961;
	bh=fvwxBZ9HeuLC+8EZa137BpJqnYP1F9daqI0i8aOzt88=;
	h=Date:To:From:Subject:From;
	b=bF0BQB/pt1/j8C/tJj2Nys7IKxIXCQ8vGv/Avkd2DJ5+RXP1EOdJBk87ENDdCJcYc
	 GJ0RAcFqsCjbyXQCqbb4i2fDKf5aSqbePh0SFb+mLc5p29omaR1cHrDvmbPK3TDvb/
	 nih7+nqiks0Xkj1V27Duj+FpgH4DSWpP0H/I6LAk=
Date: Fri, 25 Apr 2025 18:46:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,shijie@os.amperecomputing.com,shakeel.butt@linux.dev,rrangel@chromium.org,roman.gushchin@linux.dev,pmladek@suse.com,paulmck@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,linux@rasmusvillemoes.dk,kpsingh@kernel.org,hannes@cmpxchg.org,guoweikang.kernel@gmail.com,francesco@valla.it,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch added to mm-unstable branch
Message-Id: <20250426014601.D4BFBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: use kmem_cache when alloc memcg pernode info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch

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
Subject: mm/memcg: use kmem_cache when alloc memcg pernode info
Date: Fri, 25 Apr 2025 11:19:25 +0800

When tracing mem_cgroup_per_node allocations with kmalloc ftrace:

kmalloc: call_site=mem_cgroup_css_alloc+0x1d8/0x5b4 ptr=00000000d798700c
    bytes_req=2896 bytes_alloc=4096 gfp_flags=GFP_KERNEL|__GFP_ZERO node=0
    accounted=false

This reveals the slab allocator provides 4096B chunks for 2896B
mem_cgroup_per_node due to:

1. The slab allocator predefines bucket sizes from 64B to 8096B
2. The mem_cgroup allocation size (2312B) falls between the 2KB and 4KB
   slabs
3. The allocator rounds up to the nearest larger slab (4KB), resulting in
   ~1KB wasted memory per memcg alloc - per node.

This patch introduces a dedicated kmem_cache for mem_cgroup structs,
achieving precise memory allocation. Post-patch ftrace verification shows:

kmem_cache_alloc: call_site=mem_cgroup_css_alloc+0x1b8/0x5d4
    ptr=000000002989e63a bytes_req=2896 bytes_alloc=2944
    gfp_flags=GFP_KERNEL|__GFP_ZERO node=0 accounted=false

Each mem_cgroup_per_node alloc 2944bytes(include hw cacheline align),
compare to 4096, it avoid waste.

Link: https://lkml.kernel.org/r/20250425031935.76411-4-link@vivo.com
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

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info
+++ a/mm/memcontrol.c
@@ -97,6 +97,7 @@ static bool cgroup_memory_nokmem __ro_af
 static bool cgroup_memory_nobpf __ro_after_init;
 
 static struct kmem_cache *memcg_cachep;
+static struct kmem_cache *memcg_pn_cachep;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
@@ -3612,7 +3613,8 @@ static bool alloc_mem_cgroup_per_node_in
 {
 	struct mem_cgroup_per_node *pn;
 
-	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	pn = kmem_cache_alloc_node(memcg_pn_cachep, GFP_KERNEL | __GFP_ZERO,
+				   node);
 	if (!pn)
 		return false;
 
@@ -5073,6 +5075,9 @@ int __init mem_cgroup_init(void)
 	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
 					 SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
 
+	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
+				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from link@vivo.com are

mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch
mm-memcg-use-kmem_cache-when-alloc-memcg.patch
mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch

