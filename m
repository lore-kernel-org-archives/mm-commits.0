Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E2DC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A68A20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266072;
	bh=D8haDM+dwR8l1Yh48Lz66RvR2tEciaKBYilBSCEysV0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vyv2MzmnwxV9lgS2w2Z+3IuXQZUFEJLa/b9HyV2lHwpFyI5OXr8UnM1gHlMbFmhGi
	 YoKRrr1J0UqhUUf/PBv2kvtS9SU2cJf1eJzlVGvmQpxJnpLo32wY/2z2epavF6Tg6O
	 p+MboxEe1t0Cje8gNyasxN5o9cxPGhJenL966/oU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLVBM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVBK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7DC2078B;
        Wed, 12 Aug 2020 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266069;
        bh=D8haDM+dwR8l1Yh48Lz66RvR2tEciaKBYilBSCEysV0=;
        h=Date:From:To:Subject:From;
        b=TfngRq2ZUbMxZAU0ncmy74O1nA0yqA5mYwYtoGnUBFFJ860m4TafpxUB/G5zCzkm9
         QlieOCEgj9Buy7JuJLuhIN/3JaNqh5Yfc+H2fYmHhsJ8h+MQ/CNxXvyeq6cuytkv4J
         rjQhhPdhPrz5cST8cl3qzhuHy4DWF6MYbZyg9ui4=
Date:   Wed, 12 Aug 2020 14:01:08 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, cuibixuan@huawei.com, dennis@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch removed from -mm
 tree
Message-ID: <20200812210108.aTAeVO1nl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/percpu: per-memcg percpu memory statistics
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/percpu: per-memcg percpu memory statistics

Percpu memory can represent a noticeable chunk of the total memory
consumption, especially on big machines with many CPUs.  Let's track
percpu memory usage for each memcg and display it in memory.stat.

A percpu allocation is usually scattered over multiple pages (and nodes),
and can be significantly smaller than a page.  So let's add a byte-sized
counter on the memcg level: MEMCG_PERCPU_B.  Byte-sized vmstat infra
created for slabs can be perfectly reused for percpu case.

[guro@fb.com: v3]
  Link: http://lkml.kernel.org/r/20200623184515.4132564-4-guro@fb.com
Link: http://lkml.kernel.org/r/20200608230819.832349-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
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

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 include/linux/memcontrol.h              |    8 ++++++++
 mm/memcontrol.c                         |    4 +++-
 mm/percpu.c                             |   10 ++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcg-percpu-per-memcg-per=
cpu-memory-statistics
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1274,6 +1274,10 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used for storing in-kernel data
 		structures.
=20
+	  percpu
+		Amount of memory used for storing per-cpu kernel
+		data structures.
+
 	  sock
 		Amount of memory used in network transmission buffers
=20
--- a/include/linux/memcontrol.h~mm-memcg-percpu-per-memcg-percpu-memory-st=
atistics
+++ a/include/linux/memcontrol.h
@@ -32,6 +32,7 @@ struct kmem_cache;
 enum memcg_stat_item {
 	MEMCG_SWAP =3D NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
+	MEMCG_PERCPU_B,
 	MEMCG_NR_STAT,
 };
=20
@@ -339,6 +340,13 @@ struct mem_cgroup {
=20
 extern struct mem_cgroup *root_mem_cgroup;
=20
+static __always_inline bool memcg_stat_item_in_bytes(int idx)
+{
+	if (idx =3D=3D MEMCG_PERCPU_B)
+		return true;
+	return vmstat_item_in_bytes(idx);
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return (memcg =3D=3D root_mem_cgroup);
--- a/mm/memcontrol.c~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/mm/memcontrol.c
@@ -781,7 +781,7 @@ void __mod_memcg_state(struct mem_cgroup
 	if (mem_cgroup_disabled())
 		return;
=20
-	if (vmstat_item_in_bytes(idx))
+	if (memcg_stat_item_in_bytes(idx))
 		threshold <<=3D PAGE_SHIFT;
=20
 	x =3D val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
@@ -1488,6 +1488,8 @@ static char *memory_stat_format(struct m
 	seq_buf_printf(&s, "slab %llu\n",
 		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
 			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B)));
+	seq_buf_printf(&s, "percpu %llu\n",
+		       (u64)memcg_page_state(memcg, MEMCG_PERCPU_B));
 	seq_buf_printf(&s, "sock %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
 		       PAGE_SIZE);
--- a/mm/percpu.c~mm-memcg-percpu-per-memcg-percpu-memory-statistics
+++ a/mm/percpu.c
@@ -1610,6 +1610,11 @@ static void pcpu_memcg_post_alloc_hook(s
=20
 	if (chunk) {
 		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] =3D objcg;
+
+		rcu_read_lock();
+		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+				size * num_possible_cpus());
+		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
 		obj_cgroup_put(objcg);
@@ -1628,6 +1633,11 @@ static void pcpu_memcg_free_hook(struct
=20
 	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
=20
+	rcu_read_lock();
+	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
+			-(size * num_possible_cpus()));
+	rcu_read_unlock();
+
 	obj_cgroup_put(objcg);
 }
=20
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

