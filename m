Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793331990;
	b=PsGJdU5ENwVyz+cZPXx6hhFZUnLhOsbVb4OzXb3KV2acD994n+RCGwKRg8+vsWemfhdT
	 ZYg6XflSmY0bBJOLEM4PJTfN+epZJRwemJ/dciBe0XGLdnnlOjb+GSmx0CD1XsMWYNehA
	 9DzmrSlxgtejc2LaLCpAc3O/9XXXaiCaAJUOZ61UqvE+j/afD++ncaV98X+OWs1VZKB0E
	 LkqMwuZ5X2XvX4tC/euestPVMWjHk649hRfdgMhYuz5xiVsmiYgsJqKAGLJpfUJTFJ+N1
	 7JGZEJxZZuk1TBCvReVEAsJyayA9sqhnVrAYKV1eLSe1+Wk5oYPXADG8/TM41Yo8eBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793331990;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XGrD+yg6mnxsOK/dzhNkIDylpB+E2781oqrZCbSbBZU=;
	b=bN/lNzGioe7dfHKhJiutBrE6tUolp4YWOwEfwD2B6ioDprdUiBcPLL0YA+BZRYGy8KYe
	 QKpIMVqtppqyYswCW4fk/EH2b0B8dZ3yZe9uP6nhBTlhHAHmAoTnUVbSBghKt5o3ov0/Y
	 a8f5g421BP0C5b2H0g4Qa9sbRSkeCeaOn7KIsv2+NKIt+qe7H4HOEPmCdouwm6DsWmESh
	 D7y61bYTv3x4D2cylG7ZpHKux0LlyjdqZ4Rn1jQKOvipF7qUk2q79sfQPpT34zcKYZ5Nd
	 jJXqB3ThxaYCJ1GmaPvAw2PJpu6ibNUMz1zCtJnlWNreYjA6VEmDrM1QOG6IwZfD5XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cXSJJHpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF58B606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cXSJJHpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F26E1F000C1;
	Fri, 30 Oct 2026 03:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793331989;
	bh=XGrD+yg6mnxsOK/dzhNkIDylpB+E2781oqrZCbSbBZU=;
	h=Date:To:From:Subject;
	b=cXSJJHpfXSV3fDQvKUcdIWV/b5egVwIM82lqBbiaQHfutn+VOdgvT8o8Aj5iuN3TR
	 J2m4/zlCP2dqGUuCncZju6k7r8bz79qt5npDvTbYSXo/YyYyy8vcTptDLkNtTdpRTA
	 ZkCBkI38QrNxnVtJ02tedLi3vkeAbPaV4hyixs7M=
Date: Thu, 29 Oct 2026 20:46:28 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,
	mhocko@kernel.org,hannes@cmpxchg.org,joannelkoong@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch added to mm-new branch
Message-Id: <20261030034629.2F26E1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: reduce cacheline contention between lruvec stat updates and LRU lists
has been added to the -mm mm-new branch.  Its filename is
     memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: memcg: reduce cacheline contention between lruvec stat updates and LRU lists
Date: Fri, 23 Oct 2026 12:54:16 -0700

Patch series "memcg: reduce cacheline contention from lruvec stat", v3.

Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and struct
lruvec that can share a 128-byte cacheline pair with lines the lru_lock holder
writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), depending
on where struct mem_cgroup_per_node lands in its slab. On CPUs that do spatial
prefetching (eg Intel CPUs), this makes the stat updates contend with the
lru_lock holder.

Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly line is
paired with a cold line, and patch 2 makes the folio and kmem stat updates use
the memcg and node they already know instead of going through the lruvec,
whose pgdat field shares a cacheline pair with lru_lock or lru_zone_size[].

Results on a 2-socket Skylake (80 CPUs), average pages per second for
threads faulting in and freeing memory in a single memcg:

	   base     patch 1   patch 1+2
shmem, 20 threads  4.74M    5.59M     5.77M
shmem, 80 threads  7.94M    8.66M     8.82M
anon,  20 threads  3.04M    3.08M     3.10M


This patch (of 2):

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node. These updates are extremely frequent (eg these
updates happen several times for every page that's faulted in, freed,
dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but Intel CPUs do spatial
prefetching [1] and fetch cachelines in 128-byte aligned pairs.
Depending on where struct mem_cgroup_per_node lands in its slab, that
cacheline can be paired with the cacheline holding the LRU list heads.

When this happens, every stat update also pulls in a copy of the LRU
list heads cacheline, which is written to constantly by other CPUs under
the lru_lock. The stat update has to fetch it from another CPU, which is
unnecessary overhead since the stat update doesn't use the LRU list
heads at all. But even worse, the lru_lock holder then has to invalidate
those copies and wait for the acknowledgements to come back before it
can do its next write, which makes the lru_lock critical section longer
for everyone waiting on the lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly, so
that the read-mostly cacheline is paired with the cold cacheline
instead of the LRU list heads.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.59M   (+18%)
  shmem, 80 threads  7.94M     8.66M   (+9%)
  anon,  20 threads  3.04M     3.08M   (+1%)

Link: https://lore.kernel.org/20261023195417.1391216-1-joannelkoong@gmail.com
Link: https://lore.kernel.org/20261023195417.1391216-2-joannelkoong@gmail.com
Link: https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf [1] (bottom of page 62/800)
Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 include/linux/memcontrol.h |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists
+++ a/include/linux/memcontrol.h
@@ -96,6 +96,24 @@ struct mem_cgroup_per_node {
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
 	/*
+	 * Touched only when the memcg is reparented or freed. Placed right
+	 * after memcg_pn_read_mostly because CPUs with spatial prefetching
+	 * (eg most Intel CPUs) fetch cachelines in 128-byte aligned pairs.
+	 * This keeps the read-mostly line, which every lruvec stat update
+	 * reads, from being paired with the LRU list heads, which are written
+	 * constantly under lru_lock.
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
+	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
 	 * padding after lruvec in mem_cgroup_per_node").
@@ -114,17 +132,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch
memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch

