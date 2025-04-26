Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3404A02
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745631957; cv=none; b=cPkhxRL1paqNCPaGyhIGThOiPM2bSrBZijoqjgVmg945P+FYxqs3r7qybnA7j4J2h/PhZyRRVHdqyQMoYs9eG8ZJ4HwqLUqmfSHnc0wYxiohja+EuNrnMNaNU9tZLczzRYwMWfOmMndwR5+c5yQinV5nt3OeGbD0em8JjzOBb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745631957; c=relaxed/simple;
	bh=Ee6r5i989L6Bv7GYgqFtIsr9ePfiNn0E6victsQ7eNM=;
	h=Date:To:From:Subject:Message-Id; b=UmSe+hDP9ae9fApyIv4VU2kSE0rK6V5s3PY0D8g9KpMbP0yMCX0jAFsEhGFlwkzefDTJn6jELxC5m2SZW4sISHl2F2wAs4E4Tf41IWgjaGENEYWi3u1qtIXQeerFCiL4y3xMxlGrKuCZ6dpOWOdPpZ3tbksN1Mmdbgu+uug9LK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/JBTeoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/JBTeoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9E1C4CEE4;
	Sat, 26 Apr 2025 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745631956;
	bh=Ee6r5i989L6Bv7GYgqFtIsr9ePfiNn0E6victsQ7eNM=;
	h=Date:To:From:Subject:From;
	b=V/JBTeoNSvmso9Ob5QYJsxpMWmTvmvYrKmIfTN7GKl/gyi3LD2xB7IEmGSMFPs4vx
	 JO7Oa+hb5KKI0QydzW17xDFLGDnNat24Nx93ySLuB4ZWunDs4q/ic3XxirICsvu+KQ
	 CrnJeKxo3HUZ7GLLU4h6vlgdO8ofnIkpFz5XZwFo=
Date: Fri, 25 Apr 2025 18:45:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,shijie@os.amperecomputing.com,shakeel.butt@linux.dev,rrangel@chromium.org,roman.gushchin@linux.dev,pmladek@suse.com,paulmck@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,linux@rasmusvillemoes.dk,kpsingh@kernel.org,hannes@cmpxchg.org,guoweikang.kernel@gmail.com,francesco@valla.it,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch added to mm-unstable branch
Message-Id: <20250426014556.AE9E1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: move mem_cgroup_init() ahead of cgroup_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch

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
Subject: mm/memcg: move mem_cgroup_init() ahead of cgroup_init()
Date: Fri, 25 Apr 2025 11:19:23 +0800

Patch series "Use kmem_cache for memcg alloc", v3.

(willy tldr: "you've gone from allocating 8 objects per 32KiB to
allocating 13 objects per 32KiB, a 62% improvement in memory consumption"
[1])


The mem_cgroup_alloc function creates mem_cgroup struct and it's
associated structures including mem_cgroup_per_node.  Through detailed
analysis on our test machine (Arm64, 16GB RAM, 6.6 kernel, 1 NUMA node,
memcgv2 with nokmem,nosocket,cgroup_disable=pressure), we can observe the
memory allocation for these structures using the following shell commands:

  # Enable tracing
  echo 1 > /sys/kernel/tracing/events/kmem/kmalloc/enable
  echo 1 > /sys/kernel/tracing/tracing_on
  cat /sys/kernel/tracing/trace_pipe | grep kmalloc | grep mem_cgroup

  # Trigger allocation if cgroup subtree do not enable memcg
  echo +memory > /sys/fs/cgroup/cgroup.subtree_control

Ftrace Output:

  # mem_cgroup struct allocation
  sh-6312    [000] ..... 58015.698365: kmalloc:
    call_site=mem_cgroup_css_alloc+0xd8/0x5b4
    ptr=000000003e4c3799 bytes_req=2312 bytes_alloc=4096
    gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1 accounted=false

  # mem_cgroup_per_node allocation
  sh-6312    [000] ..... 58015.698389: kmalloc:
    call_site=mem_cgroup_css_alloc+0x1d8/0x5b4
    ptr=00000000d798700c bytes_req=2896 bytes_alloc=4096
    gfp_flags=GFP_KERNEL|__GFP_ZERO node=0 accounted=false

Key Observations:

  1. Both structures use kmalloc with requested sizes between 2KB-4KB
  2. Allocation alignment forces 4KB slab usage due to pre-defined sizes
     (64B, 128B,..., 2KB, 4KB, 8KB)
  3. Memory waste per memcg instance:
      Base struct: 4096 - 2312 = 1784 bytes
      Per-node struct: 4096 - 2896 = 1200 bytes
      Total waste: 2984 bytes (1-node system)
      NUMA scaling: (1200 + 8) * nr_node_ids bytes

So, it's a little waste.

This patchset introduces dedicated kmem_cache:
  Patch2 - mem_cgroup kmem_cache - memcg_cachep
  Patch3 - mem_cgroup_per_node kmem_cache - memcg_pn_cachep

The benefits of this change can be observed with the following tracing
commands:

  # Enable tracing
  echo 1 > /sys/kernel/tracing/events/kmem/kmem_cache_alloc/enable
  echo 1 > /sys/kernel/tracing/tracing_on
  cat /sys/kernel/tracing/trace_pipe | grep kmem_cache_alloc | grep mem_cgroup
  # In another terminal:
  echo +memory > /sys/fs/cgroup/cgroup.subtree_control


The output might now look like this:

  # mem_cgroup struct allocation
  sh-9827     [000] .....   289.513598: kmem_cache_alloc:
    call_site=mem_cgroup_css_alloc+0xbc/0x5d4 ptr=00000000695c1806
    bytes_req=2312 bytes_alloc=2368 gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1
    accounted=false
  # mem_cgroup_per_node allocation
  sh-9827     [000] .....   289.513602: kmem_cache_alloc:
    call_site=mem_cgroup_css_alloc+0x1b8/0x5d4 ptr=000000002989e63a
    bytes_req=2896 bytes_alloc=2944 gfp_flags=GFP_KERNEL|__GFP_ZERO node=0
    accounted=false

This indicates that the `mem_cgroup` struct now requests 2312 bytes and is
allocated 2368 bytes, while `mem_cgroup_per_node` requests 2896 bytes and
is allocated 2944 bytes.  The slight increase in allocated size is due to
`SLAB_HWCACHE_ALIGN` in the `kmem_cache`.

Without `SLAB_HWCACHE_ALIGN`, the allocation might appear as:

  # mem_cgroup struct allocation
  sh-9269     [003] .....    80.396366: kmem_cache_alloc:
    call_site=mem_cgroup_css_alloc+0xbc/0x5d4 ptr=000000005b12b475
    bytes_req=2312 bytes_alloc=2312 gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1
    accounted=false

  # mem_cgroup_per_node allocation
  sh-9269     [003] .....    80.396411: kmem_cache_alloc:
    call_site=mem_cgroup_css_alloc+0x1b8/0x5d4 ptr=00000000f347adc6
    bytes_req=2896 bytes_alloc=2896 gfp_flags=GFP_KERNEL|__GFP_ZERO node=0
    accounted=false

While the `bytes_alloc` now matches the `bytes_req`, this patchset
defaults to using `SLAB_HWCACHE_ALIGN` as it is generally considered more
beneficial for performance.  Please let me know if there are any issues or
if I've misunderstood anything.

This patchset also move mem_cgroup_init ahead of cgroup_init() due to
cgroup_init() will allocate root_mem_cgroup, but each initcall invoke
after cgroup_init, so if each kmem_cache do not prepare, we need testing
NULL before use it.


This patch (of 3):

When cgroup_init() creates root_mem_cgroup through css_alloc callback,
some critical resources might not be fully initialized, forcing later
operations to perform conditional checks for resource availability.

This patch move mem_cgroup_init() to address the init order, it invoke
before cgroup_init, so, compare to subsys_initcall, it can use to prepare
some key resources before root_mem_cgroup alloc.

Link: https://lkml.kernel.org/r/aAsRCj-niMMTtmK8@casper.infradead.org [1]
Link: https://lkml.kernel.org/r/20250425031935.76411-1-link@vivo.com
Link: https://lkml.kernel.org/r/20250425031935.76411-2-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
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

 include/linux/memcontrol.h |    3 +++
 init/main.c                |    2 ++
 mm/memcontrol.c            |    5 ++---
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init
+++ a/include/linux/memcontrol.h
@@ -1057,6 +1057,7 @@ static inline u64 cgroup_id_from_mm(stru
 	return id;
 }
 
+extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
@@ -1472,6 +1473,8 @@ static inline u64 cgroup_id_from_mm(stru
 {
 	return 0;
 }
+
+static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
 /*
--- a/init/main.c~mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init
+++ a/init/main.c
@@ -50,6 +50,7 @@
 #include <linux/writeback.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/efi.h>
 #include <linux/tick.h>
@@ -1087,6 +1088,7 @@ void start_kernel(void)
 	nsfs_init();
 	pidfs_init();
 	cpuset_init();
+	mem_cgroup_init();
 	cgroup_init();
 	taskstats_init_early();
 	delayacct_init();
--- a/mm/memcontrol.c~mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init
+++ a/mm/memcontrol.c
@@ -5040,14 +5040,14 @@ static int __init cgroup_memory(char *s)
 __setup("cgroup.memory=", cgroup_memory);
 
 /*
- * subsys_initcall() for memory controller.
+ * Memory controller init before cgroup_init() initialize root_mem_cgroup.
  *
  * Some parts like memcg_hotplug_cpu_dead() have to be initialized from this
  * context because of lock dependencies (cgroup_lock -> cpu hotplug) but
  * basically everything that doesn't depend on a specific mem_cgroup structure
  * should be initialized from here.
  */
-static int __init mem_cgroup_init(void)
+int __init mem_cgroup_init(void)
 {
 	int cpu;
 
@@ -5068,7 +5068,6 @@ static int __init mem_cgroup_init(void)
 
 	return 0;
 }
-subsys_initcall(mem_cgroup_init);
 
 #ifdef CONFIG_SWAP
 /**
_

Patches currently in -mm which might be from link@vivo.com are

mm-memcg-move-mem_cgroup_init-ahead-of-cgroup_init.patch
mm-memcg-use-kmem_cache-when-alloc-memcg.patch
mm-memcg-use-kmem_cache-when-alloc-memcg-pernode-info.patch

