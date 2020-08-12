Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E131C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE77207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195821;
	bh=WvOiEhlS1J2dQsR4rDev+75novo/9g83T34xnpMnzlM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=o9ewUzHq342aRUNc+TnxrvG8OeSdtaSg3IuzXjxi0SW/nGbTJeLqwx9nSaxoM650d
	 QK/afVdxX3Mu0URY87BHciu/KKp7ziVrYsoR/XgOwsdr15IYdJotikGtlSC8W0dMdV
	 zoBYwJalFM+RV6i2SdfXnZJAj7tA0LIukCLE5fhE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBaU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:30:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E930206F2;
        Wed, 12 Aug 2020 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195819;
        bh=WvOiEhlS1J2dQsR4rDev+75novo/9g83T34xnpMnzlM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xj1fUQ8f/LFkN6lPIlC2Om5xQcCH1m8TgUxNtacXG7Fj7dKIDnSC/rYZFPKRPbsLC
         eWddTrElyJ72Zl2sTenlihFYzhVu7j5yXzUeqWBr1aOSqqph8Nd6QprsP1wYcCxlu0
         6VlZ6SZ6xWxKtyJpky3RU/r4Ms4JzjuFPghgwIds=
Date:   Tue, 11 Aug 2020 18:30:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, cuibixuan@huawei.com,
        dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 002/165] mm: memcg/percpu: account percpu memory
 to memory cgroups
Message-ID: <20200812013017.QR7bXAQC5%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/percpu: account percpu memory to memory cgroups

Percpu memory is becoming more and more widely used by various subsystems,
and the total amount of memory controlled by the percpu allocator can make
a good part of the total memory.

As an example, bpf maps can consume a lot of percpu memory, and they are
created by a user.  Also, some cgroup internals (e.g.  memory controller
statistics) can be quite large.  On a machine with many CPUs and big
number of cgroups they can consume hundreds of megabytes.

So the lack of memcg accounting is creating a breach in the memory
isolation.  Similar to the slab memory, percpu memory should be accounted
by default.

To implement the perpcu accounting it's possible to take the slab memory
accounting as a model to follow.  Let's introduce two types of percpu
chunks: root and memcg.  What makes memcg chunks different is an
additional space allocated to store memcg membership information.  If
__GFP_ACCOUNT is passed on allocation, a memcg chunk should be be used.=20
If it's possible to charge the corresponding size to the target memory
cgroup, allocation is performed, and the memcg ownership data is recorded.
System-wide allocations are performed using root chunks, so there is no
additional memory overhead.

To implement a fast reparenting of percpu memory on memcg removal, we
don't store mem_cgroup pointers directly: instead we use obj_cgroup API,
introduced for slab accounting.

[akpm@linux-foundation.org: fix CONFIG_MEMCG_KMEM=3Dn build errors and warn=
ing]
[akpm@linux-foundation.org: move unreachable code, per Roman]
[cuibixuan@huawei.com: mm/percpu: fix 'defined but not used' warning]
  Link: http://lkml.kernel.org/r/6d41b939-a741-b521-a7a2-e7296ec16219@huawe=
i.com
Link: http://lkml.kernel.org/r/20200623184515.4132564-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   55 +++++++++++-
 mm/percpu-km.c       |    5 -
 mm/percpu-stats.c    |   36 ++++---
 mm/percpu-vm.c       |    5 -
 mm/percpu.c          |  185 ++++++++++++++++++++++++++++++++++++-----
 5 files changed, 246 insertions(+), 40 deletions(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu.c
@@ -37,9 +37,14 @@
  * takes care of normal allocations.
  *
  * The allocator organizes chunks into lists according to free size and
- * tries to allocate from the fullest chunk first.  Each chunk is managed
- * by a bitmap with metadata blocks.  The allocation map is updated on
- * every allocation and free to reflect the current state while the bounda=
ry
+ * memcg-awareness.  To make a percpu allocation memcg-aware the __GFP_ACC=
OUNT
+ * flag should be passed.  All memcg-aware allocations are sharing one set
+ * of chunks and all unaccounted allocations and allocations performed
+ * by processes belonging to the root memory cgroup are using the second s=
et.
+ *
+ * The allocator tries to allocate from the fullest chunk first. Each chunk
+ * is managed by a bitmap with metadata blocks.  The allocation map is upd=
ated
+ * on every allocation and free to reflect the current state while the bou=
ndary
  * map is only updated on allocation.  Each metadata block contains
  * information to help mitigate the need to iterate over large portions
  * of the bitmap.  The reverse mapping from page to chunk is stored in
@@ -81,6 +86,7 @@
 #include <linux/kmemleak.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/memcontrol.h>
=20
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -160,7 +166,7 @@ struct pcpu_chunk *pcpu_reserved_chunk _
 DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop, m=
ap ext */
=20
-struct list_head *pcpu_slot __ro_after_init; /* chunk list slots */
+struct list_head *pcpu_chunk_lists __ro_after_init; /* chunk list slots */
=20
 /* chunks which need their map areas extended, protected by pcpu_lock */
 static LIST_HEAD(pcpu_map_extend_chunks);
@@ -500,6 +506,9 @@ static void __pcpu_chunk_move(struct pcp
 			      bool move_front)
 {
 	if (chunk !=3D pcpu_reserved_chunk) {
+		struct list_head *pcpu_slot;
+
+		pcpu_slot =3D pcpu_chunk_list(pcpu_chunk_type(chunk));
 		if (move_front)
 			list_move(&chunk->list, &pcpu_slot[slot]);
 		else
@@ -1341,6 +1350,10 @@ static struct pcpu_chunk * __init pcpu_a
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
 		      alloc_size);
=20
+#ifdef CONFIG_MEMCG_KMEM
+	/* first chunk isn't memcg-aware */
+	chunk->obj_cgroups =3D NULL;
+#endif
 	pcpu_init_md_blocks(chunk);
=20
 	/* manage populated page bitmap */
@@ -1380,7 +1393,7 @@ static struct pcpu_chunk * __init pcpu_a
 	return chunk;
 }
=20
-static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_alloc_chunk(enum pcpu_chunk_type type, gfp_=
t gfp)
 {
 	struct pcpu_chunk *chunk;
 	int region_bits;
@@ -1408,6 +1421,16 @@ static struct pcpu_chunk *pcpu_alloc_chu
 	if (!chunk->md_blocks)
 		goto md_blocks_fail;
=20
+#ifdef CONFIG_MEMCG_KMEM
+	if (pcpu_is_memcg_chunk(type)) {
+		chunk->obj_cgroups =3D
+			pcpu_mem_zalloc(pcpu_chunk_map_bits(chunk) *
+					sizeof(struct obj_cgroup *), gfp);
+		if (!chunk->obj_cgroups)
+			goto objcg_fail;
+	}
+#endif
+
 	pcpu_init_md_blocks(chunk);
=20
 	/* init metadata */
@@ -1415,6 +1438,10 @@ static struct pcpu_chunk *pcpu_alloc_chu
=20
 	return chunk;
=20
+#ifdef CONFIG_MEMCG_KMEM
+objcg_fail:
+	pcpu_mem_free(chunk->md_blocks);
+#endif
 md_blocks_fail:
 	pcpu_mem_free(chunk->bound_map);
 bound_map_fail:
@@ -1429,6 +1456,9 @@ static void pcpu_free_chunk(struct pcpu_
 {
 	if (!chunk)
 		return;
+#ifdef CONFIG_MEMCG_KMEM
+	pcpu_mem_free(chunk->obj_cgroups);
+#endif
 	pcpu_mem_free(chunk->md_blocks);
 	pcpu_mem_free(chunk->bound_map);
 	pcpu_mem_free(chunk->alloc_map);
@@ -1505,7 +1535,8 @@ static int pcpu_populate_chunk(struct pc
 			       int page_start, int page_end, gfp_t gfp);
 static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 				  int page_start, int page_end);
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp);
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp);
 static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
 static struct page *pcpu_addr_to_page(void *addr);
 static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
@@ -1547,6 +1578,77 @@ static struct pcpu_chunk *pcpu_chunk_add
 	return pcpu_get_page_chunk(pcpu_addr_to_page(addr));
 }
=20
+#ifdef CONFIG_MEMCG_KMEM
+static enum pcpu_chunk_type pcpu_memcg_pre_alloc_hook(size_t size, gfp_t g=
fp,
+						     struct obj_cgroup **objcgp)
+{
+	struct obj_cgroup *objcg;
+
+	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT) ||
+	    memcg_kmem_bypass())
+		return PCPU_CHUNK_ROOT;
+
+	objcg =3D get_obj_cgroup_from_current();
+	if (!objcg)
+		return PCPU_CHUNK_ROOT;
+
+	if (obj_cgroup_charge(objcg, gfp, size * num_possible_cpus())) {
+		obj_cgroup_put(objcg);
+		return PCPU_FAIL_ALLOC;
+	}
+
+	*objcgp =3D objcg;
+	return PCPU_CHUNK_MEMCG;
+}
+
+static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
+				       struct pcpu_chunk *chunk, int off,
+				       size_t size)
+{
+	if (!objcg)
+		return;
+
+	if (chunk) {
+		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] =3D objcg;
+	} else {
+		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+		obj_cgroup_put(objcg);
+	}
+}
+
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t=
 size)
+{
+	struct obj_cgroup *objcg;
+
+	if (!pcpu_is_memcg_chunk(pcpu_chunk_type(chunk)))
+		return;
+
+	objcg =3D chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT];
+	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] =3D NULL;
+
+	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+
+	obj_cgroup_put(objcg);
+}
+
+#else /* CONFIG_MEMCG_KMEM */
+static enum pcpu_chunk_type
+pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp, struct obj_cgroup **objc=
gp)
+{
+	return PCPU_CHUNK_ROOT;
+}
+
+static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
+				       struct pcpu_chunk *chunk, int off,
+				       size_t size)
+{
+}
+
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t=
 size)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 /**
  * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
@@ -1568,6 +1670,9 @@ static void __percpu *pcpu_alloc(size_t
 	gfp_t pcpu_gfp;
 	bool is_atomic;
 	bool do_warn;
+	enum pcpu_chunk_type type;
+	struct list_head *pcpu_slot;
+	struct obj_cgroup *objcg =3D NULL;
 	static int warn_limit =3D 10;
 	struct pcpu_chunk *chunk, *next;
 	const char *err;
@@ -1602,16 +1707,23 @@ static void __percpu *pcpu_alloc(size_t
 		return NULL;
 	}
=20
+	type =3D pcpu_memcg_pre_alloc_hook(size, gfp, &objcg);
+	if (unlikely(type =3D=3D PCPU_FAIL_ALLOC))
+		return NULL;
+	pcpu_slot =3D pcpu_chunk_list(type);
+
 	if (!is_atomic) {
 		/*
 		 * pcpu_balance_workfn() allocates memory under this mutex,
 		 * and it may wait for memory reclaim. Allow current task
 		 * to become OOM victim, in case of memory pressure.
 		 */
-		if (gfp & __GFP_NOFAIL)
+		if (gfp & __GFP_NOFAIL) {
 			mutex_lock(&pcpu_alloc_mutex);
-		else if (mutex_lock_killable(&pcpu_alloc_mutex))
+		} else if (mutex_lock_killable(&pcpu_alloc_mutex)) {
+			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
 			return NULL;
+		}
 	}
=20
 	spin_lock_irqsave(&pcpu_lock, flags);
@@ -1666,7 +1778,7 @@ restart:
 	}
=20
 	if (list_empty(&pcpu_slot[pcpu_nr_slots - 1])) {
-		chunk =3D pcpu_create_chunk(pcpu_gfp);
+		chunk =3D pcpu_create_chunk(type, pcpu_gfp);
 		if (!chunk) {
 			err =3D "failed to allocate new chunk";
 			goto fail;
@@ -1723,6 +1835,8 @@ area_found:
 	trace_percpu_alloc_percpu(reserved, is_atomic, size, align,
 			chunk->base_addr, off, ptr);
=20
+	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
+
 	return ptr;
=20
 fail_unlock:
@@ -1744,6 +1858,9 @@ fail:
 	} else {
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
+
+	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+
 	return NULL;
 }
=20
@@ -1803,8 +1920,8 @@ void __percpu *__alloc_reserved_percpu(s
 }
=20
 /**
- * pcpu_balance_workfn - manage the amount of free chunks and populated pa=
ges
- * @work: unused
+ * __pcpu_balance_workfn - manage the amount of free chunks and populated =
pages
+ * @type: chunk type
  *
  * Reclaim all fully free chunks except for the first one.  This is also
  * responsible for maintaining the pool of empty populated pages.  However,
@@ -1813,11 +1930,12 @@ void __percpu *__alloc_reserved_percpu(s
  * allocation causes the failure as it is possible that requests can be
  * serviced from already backed regions.
  */
-static void pcpu_balance_workfn(struct work_struct *work)
+static void __pcpu_balance_workfn(enum pcpu_chunk_type type)
 {
 	/* gfp flags passed to underlying allocators */
 	const gfp_t gfp =3D GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
 	LIST_HEAD(to_free);
+	struct list_head *pcpu_slot =3D pcpu_chunk_list(type);
 	struct list_head *free_head =3D &pcpu_slot[pcpu_nr_slots - 1];
 	struct pcpu_chunk *chunk, *next;
 	int slot, nr_to_pop, ret;
@@ -1915,7 +2033,7 @@ retry_pop:
=20
 	if (nr_to_pop) {
 		/* ran out of chunks to populate, create a new one and retry */
-		chunk =3D pcpu_create_chunk(gfp);
+		chunk =3D pcpu_create_chunk(type, gfp);
 		if (chunk) {
 			spin_lock_irq(&pcpu_lock);
 			pcpu_chunk_relocate(chunk, -1);
@@ -1928,6 +2046,20 @@ retry_pop:
 }
=20
 /**
+ * pcpu_balance_workfn - manage the amount of free chunks and populated pa=
ges
+ * @work: unused
+ *
+ * Call __pcpu_balance_workfn() for each chunk type.
+ */
+static void pcpu_balance_workfn(struct work_struct *work)
+{
+	enum pcpu_chunk_type type;
+
+	for (type =3D 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		__pcpu_balance_workfn(type);
+}
+
+/**
  * free_percpu - free percpu area
  * @ptr: pointer to area to free
  *
@@ -1941,8 +2073,9 @@ void free_percpu(void __percpu *ptr)
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
-	int off;
+	int size, off;
 	bool need_balance =3D false;
+	struct list_head *pcpu_slot;
=20
 	if (!ptr)
 		return;
@@ -1956,7 +2089,11 @@ void free_percpu(void __percpu *ptr)
 	chunk =3D pcpu_chunk_addr_search(addr);
 	off =3D addr - chunk->base_addr;
=20
-	pcpu_free_area(chunk, off);
+	size =3D pcpu_free_area(chunk, off);
+
+	pcpu_slot =3D pcpu_chunk_list(pcpu_chunk_type(chunk));
+
+	pcpu_memcg_free_hook(chunk, off, size);
=20
 	/* if there are more than one fully free chunks, wake up grim reaper */
 	if (chunk->free_bytes =3D=3D pcpu_unit_size) {
@@ -2267,6 +2404,7 @@ void __init pcpu_setup_first_chunk(const
 	int map_size;
 	unsigned long tmp_addr;
 	size_t alloc_size;
+	enum pcpu_chunk_type type;
=20
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
@@ -2384,13 +2522,18 @@ void __init pcpu_setup_first_chunk(const
 	 * empty chunks.
 	 */
 	pcpu_nr_slots =3D __pcpu_size_to_slot(pcpu_unit_size) + 2;
-	pcpu_slot =3D memblock_alloc(pcpu_nr_slots * sizeof(pcpu_slot[0]),
-				   SMP_CACHE_BYTES);
-	if (!pcpu_slot)
+	pcpu_chunk_lists =3D memblock_alloc(pcpu_nr_slots *
+					  sizeof(pcpu_chunk_lists[0]) *
+					  PCPU_NR_CHUNK_TYPES,
+					  SMP_CACHE_BYTES);
+	if (!pcpu_chunk_lists)
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
-		      pcpu_nr_slots * sizeof(pcpu_slot[0]));
-	for (i =3D 0; i < pcpu_nr_slots; i++)
-		INIT_LIST_HEAD(&pcpu_slot[i]);
+		      pcpu_nr_slots * sizeof(pcpu_chunk_lists[0]) *
+		      PCPU_NR_CHUNK_TYPES);
+
+	for (type =3D 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		for (i =3D 0; i < pcpu_nr_slots; i++)
+			INIT_LIST_HEAD(&pcpu_chunk_list(type)[i]);
=20
 	/*
 	 * The end of the static region needs to be aligned with the
--- a/mm/percpu-internal.h~mm-memcg-percpu-account-percpu-memory-to-memory-=
cgroups
+++ a/mm/percpu-internal.h
@@ -6,6 +6,25 @@
 #include <linux/percpu.h>
=20
 /*
+ * There are two chunk types: root and memcg-aware.
+ * Chunks of each type have separate slots list.
+ *
+ * Memcg-aware chunks have an attached vector of obj_cgroup pointers, whic=
h is
+ * used to store memcg membership data of a percpu object.  Obj_cgroups are
+ * ref-counted pointers to a memory cgroup with an ability to switch dynam=
ically
+ * to the parent memory cgroup.  This allows to reclaim a deleted memory c=
group
+ * without reclaiming of all outstanding objects, which hold a reference a=
t it.
+ */
+enum pcpu_chunk_type {
+	PCPU_CHUNK_ROOT,
+#ifdef CONFIG_MEMCG_KMEM
+	PCPU_CHUNK_MEMCG,
+#endif
+	PCPU_NR_CHUNK_TYPES,
+	PCPU_FAIL_ALLOC =3D PCPU_NR_CHUNK_TYPES
+};
+
+/*
  * pcpu_block_md is the metadata block struct.
  * Each chunk's bitmap is split into a number of full blocks.
  * All units are in terms of bits.
@@ -54,6 +73,9 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup	**obj_cgroups;	/* vector of object cgroups */
+#endif
=20
 	int			nr_pages;	/* # of pages served by this chunk */
 	int			nr_populated;	/* # of populated pages */
@@ -63,7 +85,7 @@ struct pcpu_chunk {
=20
 extern spinlock_t pcpu_lock;
=20
-extern struct list_head *pcpu_slot;
+extern struct list_head *pcpu_chunk_lists;
 extern int pcpu_nr_slots;
 extern int pcpu_nr_empty_pop_pages;
=20
@@ -106,6 +128,37 @@ static inline int pcpu_chunk_map_bits(st
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
=20
+#ifdef CONFIG_MEMCG_KMEM
+static inline enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chun=
k)
+{
+	if (chunk->obj_cgroups)
+		return PCPU_CHUNK_MEMCG;
+	return PCPU_CHUNK_ROOT;
+}
+
+static inline bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+{
+	return chunk_type =3D=3D PCPU_CHUNK_MEMCG;
+}
+
+#else
+static inline enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chun=
k)
+{
+	return PCPU_CHUNK_ROOT;
+}
+
+static inline bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+{
+	return false;
+}
+#endif
+
+static inline struct list_head *pcpu_chunk_list(enum pcpu_chunk_type chunk=
_type)
+{
+	return &pcpu_chunk_lists[pcpu_nr_slots *
+				 pcpu_is_memcg_chunk(chunk_type)];
+}
+
 #ifdef CONFIG_PERCPU_STATS
=20
 #include <linux/spinlock.h>
--- a/mm/percpu-km.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-km.c
@@ -44,7 +44,8 @@ static void pcpu_depopulate_chunk(struct
 	/* nada */
 }
=20
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp)
 {
 	const int nr_pages =3D pcpu_group_sizes[0] >> PAGE_SHIFT;
 	struct pcpu_chunk *chunk;
@@ -52,7 +53,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	unsigned long flags;
 	int i;
=20
-	chunk =3D pcpu_alloc_chunk(gfp);
+	chunk =3D pcpu_alloc_chunk(type, gfp);
 	if (!chunk)
 		return NULL;
=20
--- a/mm/percpu-stats.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgr=
oups
+++ a/mm/percpu-stats.c
@@ -34,11 +34,15 @@ static int find_max_nr_alloc(void)
 {
 	struct pcpu_chunk *chunk;
 	int slot, max_nr_alloc;
+	enum pcpu_chunk_type type;
=20
 	max_nr_alloc =3D 0;
-	for (slot =3D 0; slot < pcpu_nr_slots; slot++)
-		list_for_each_entry(chunk, &pcpu_slot[slot], list)
-			max_nr_alloc =3D max(max_nr_alloc, chunk->nr_alloc);
+	for (type =3D 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		for (slot =3D 0; slot < pcpu_nr_slots; slot++)
+			list_for_each_entry(chunk, &pcpu_chunk_list(type)[slot],
+					    list)
+				max_nr_alloc =3D max(max_nr_alloc,
+						   chunk->nr_alloc);
=20
 	return max_nr_alloc;
 }
@@ -129,6 +133,9 @@ static void chunk_map_stats(struct seq_f
 	P("cur_min_alloc", cur_min_alloc);
 	P("cur_med_alloc", cur_med_alloc);
 	P("cur_max_alloc", cur_max_alloc);
+#ifdef CONFIG_MEMCG_KMEM
+	P("memcg_aware", pcpu_is_memcg_chunk(pcpu_chunk_type(chunk)));
+#endif
 	seq_putc(m, '\n');
 }
=20
@@ -137,6 +144,7 @@ static int percpu_stats_show(struct seq_
 	struct pcpu_chunk *chunk;
 	int slot, max_nr_alloc;
 	int *buffer;
+	enum pcpu_chunk_type type;
=20
 alloc_buffer:
 	spin_lock_irq(&pcpu_lock);
@@ -202,18 +210,18 @@ alloc_buffer:
 		chunk_map_stats(m, pcpu_reserved_chunk, buffer);
 	}
=20
-	for (slot =3D 0; slot < pcpu_nr_slots; slot++) {
-		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
-			if (chunk =3D=3D pcpu_first_chunk) {
-				seq_puts(m, "Chunk: <- First Chunk\n");
-				chunk_map_stats(m, chunk, buffer);
-
-
-			} else {
-				seq_puts(m, "Chunk:\n");
-				chunk_map_stats(m, chunk, buffer);
+	for (type =3D 0; type < PCPU_NR_CHUNK_TYPES; type++) {
+		for (slot =3D 0; slot < pcpu_nr_slots; slot++) {
+			list_for_each_entry(chunk, &pcpu_chunk_list(type)[slot],
+					    list) {
+				if (chunk =3D=3D pcpu_first_chunk) {
+					seq_puts(m, "Chunk: <- First Chunk\n");
+					chunk_map_stats(m, chunk, buffer);
+				} else {
+					seq_puts(m, "Chunk:\n");
+					chunk_map_stats(m, chunk, buffer);
+				}
 			}
-
 		}
 	}
=20
--- a/mm/percpu-vm.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups
+++ a/mm/percpu-vm.c
@@ -328,12 +328,13 @@ static void pcpu_depopulate_chunk(struct
 	pcpu_free_pages(chunk, pages, page_start, page_end);
 }
=20
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	struct vm_struct **vms;
=20
-	chunk =3D pcpu_alloc_chunk(gfp);
+	chunk =3D pcpu_alloc_chunk(type, gfp);
 	if (!chunk)
 		return NULL;
=20
_
