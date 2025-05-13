Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201931EB9FD
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119227; cv=none; b=JfH8Hkxr3yUReCuhCI2adGhrGUlQ5wzSfn6uaXlUbnoRaJMEFzoTua4wrkNEaTsBIXMoNsL2bd5aM2jr3BKGubg6QEVkHTNAVBkpcBLBFEPVOxRkNKgcGON66GATPzWDINlxB1VYmobFahFqgsANdeu0dt4vkkRvqsPrbDONcTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119227; c=relaxed/simple;
	bh=7GgTrZJgOEDpBwaqBPCF+7TOYZ0M0ucWxPjAoMjIR4M=;
	h=Date:To:From:Subject:Message-Id; b=s0FINVad/Zw46DWHrNIiGTntmENotEj2mYaoKIGDEVRhmCN24G6syyLw8TmfKSS2r9lix4Kx7O5/aFYs5IZiZ94wM5nIpQFmqmVlENzJsgF/sbRmzy6TGbch/GKbxigljvA0bA+A0PChtng/yJJGn9lUEBDyKFrfnTGNlGcE2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wOpQc0Nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wOpQc0Nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F055C4CEE4;
	Tue, 13 May 2025 06:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119226;
	bh=7GgTrZJgOEDpBwaqBPCF+7TOYZ0M0ucWxPjAoMjIR4M=;
	h=Date:To:From:Subject:From;
	b=wOpQc0Nc51+JgMI7Wn/xV3Yujt7hfx+h7N861HXqrkytXymw+UhqGbGp7DSv+XQWH
	 00v5h/Z03vDPgcERaumUQKrmRgW97w6Ds+Rt3IvfVsyMV7VQo4mtiNqfZO/O7HbgOA
	 PCjogfkJMVRJFHZDvBDLMFjotzVc6vq8ArpMsiuQ=
Date: Mon, 12 May 2025 23:53:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,shijie@os.amperecomputing.com,shakeel.butt@linux.dev,rrangel@chromium.org,roman.gushchin@linux.dev,pmladek@suse.com,paulmck@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,linux@rasmusvillemoes.dk,kpsingh@kernel.org,hannes@cmpxchg.org,guoweikang.kernel@gmail.com,francesco@valla.it,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-use-kmem_cache-when-alloc-memcg.patch removed from -mm tree
Message-Id: <20250513065346.8F055C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: use kmem_cache when alloc memcg
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-kmem_cache-when-alloc-memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Huang Shijie <shijie@os.amperecomputing.com>
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
@@ -3665,7 +3667,7 @@ static struct mem_cgroup *mem_cgroup_all
 	int __maybe_unused i;
 	long error;
 
-	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
+	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
@@ -5051,6 +5053,7 @@ __setup("cgroup.memory=", cgroup_memory)
  */
 int __init mem_cgroup_init(void)
 {
+	unsigned int memcg_size;
 	int cpu;
 
 	/*
@@ -5068,6 +5071,10 @@ int __init mem_cgroup_init(void)
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


