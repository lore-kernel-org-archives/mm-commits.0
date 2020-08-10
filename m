Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAD9C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55472206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027005;
	bh=efxnX8t+c96UsejfZotzfjoxhT//Br60kBeWk/OBJL8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QRNgIQtDf2Urae2d8n+wyUU6huROdAQoNJrJ4EbiDU3g+7RiEYvOHbJk2I3gxZUPG
	 enjSQ5oifYI6f5+Kh08Z3BIyC2L2V3oyIOjGg8IPCYPZXSeyaJK6Q2ps8qV866Lgwh
	 CW7T/3N1py2ln40XG4Bn3kzTc0qJWr0h/D6+r4mU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9806B206CD;
        Mon, 10 Aug 2020 02:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027003;
        bh=efxnX8t+c96UsejfZotzfjoxhT//Br60kBeWk/OBJL8=;
        h=Date:From:To:Subject:From;
        b=wi9/WfdeoPi1hG1U7PpIw5TB1EnaXpMi60EBPRBTveJjaeDWKx9/NbmRW3WlF/R29
         n0BkeJ8KH9QQ7XYVjYcLEr3LoJFIEiaTzdGjpjIczfQ3u8qLnP/ofWwowaJCzKpgJz
         cYMUfT8UNBPv6X0Ut8KdohuI7MYdu5YNZ6Vj2yrU=
Date:   Sun, 09 Aug 2020 19:36:43 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged] mm-memcg-slab-deprecate-memorykmemslabinfo.patch
 removed from -mm tree
Message-ID: <20200810023643.VIqY2TsFB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: deprecate memory.kmem.slabinfo
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-deprecate-memorykmemslabinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: deprecate memory.kmem.slabinfo

Deprecate memory.kmem.slabinfo.

An empty file will be presented if corresponding config options are
enabled.

The interface is implementation dependent, isn't present in cgroup v2, and
is generally useful only for core mm debugging purposes.  In other words,
it doesn't provide any value for the absolute majority of users.

A drgn-based replacement can be found in
tools/cgroup/memcg_slabinfo.py.  It does support cgroup v1 and v2,
mimics memory.kmem.slabinfo output and also allows to get any
additional information without a need to recompile the kernel.

If a drgn-based solution is too slow for a task, a bpf-based tracing tool
can be used, which can easily keep track of all slab allocations belonging
to a memory cgroup.

Link: http://lkml.kernel.org/r/20200623174037.3951353-11-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    3 ---
 mm/slab_common.c |   31 ++++---------------------------
 2 files changed, 4 insertions(+), 30 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-deprecate-memorykmemslabinfo
+++ a/mm/memcontrol.c
@@ -5114,9 +5114,6 @@ static struct cftype mem_cgroup_legacy_f
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 	{
 		.name = "kmem.slabinfo",
-		.seq_start = memcg_slab_start,
-		.seq_next = memcg_slab_next,
-		.seq_stop = memcg_slab_stop,
 		.seq_show = memcg_slab_show,
 	},
 #endif
--- a/mm/slab_common.c~mm-memcg-slab-deprecate-memorykmemslabinfo
+++ a/mm/slab_common.c
@@ -1561,35 +1561,12 @@ void dump_unreclaimable_slab(void)
 }
 
 #if defined(CONFIG_MEMCG_KMEM)
-void *memcg_slab_start(struct seq_file *m, loff_t *pos)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	mutex_lock(&slab_mutex);
-	return seq_list_start(&memcg->kmem_caches, *pos);
-}
-
-void *memcg_slab_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	return seq_list_next(p, &memcg->kmem_caches, pos);
-}
-
-void memcg_slab_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&slab_mutex);
-}
-
 int memcg_slab_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache,
-					  memcg_params.kmem_caches_node);
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-
-	if (p == memcg->kmem_caches.next)
-		print_slabinfo_header(m);
-	cache_show(s, m);
+	/*
+	 * Deprecated.
+	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 */
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

