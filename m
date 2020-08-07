Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8955C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FFC22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781265;
	bh=kcYw7rdPT7nf8C8LR4PoU61MLtrCwNXJJnbBH6t2mX4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lJtj0j5GYhoR1p6SqioFIYy35AOMCYZgwj5JEfr1f0FTzy6lGmbDP2e0mA/Bhc6/5
	 KIG060FdaM9iqUb3VGRR/Xqgf5Eme6N6ZA401Dl/nnSiWm9YgxlM6yyyhevvJ1MvlP
	 yY9qsF8vGFDWQF8gnhsrUNye5NHUYQjIQZ8eE91g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGVF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C700C2177B;
        Fri,  7 Aug 2020 06:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781264;
        bh=kcYw7rdPT7nf8C8LR4PoU61MLtrCwNXJJnbBH6t2mX4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h2Oibxo1DIBLXBYBgK4jvJ8t64MYQPYJgdQMZAtyk5NwgIagFLwp1YI7u9UUxcOdu
         uUwaU0fzXfCgjd4ylzIBLXEQPFfKFbuK45u0zRU1yi/CiLd/U7TeRjpjTftlkx6flD
         37CcQ9++8jHDqtZduEwH3F3IZ6aqqz6itwdWKInk=
Date:   Thu, 06 Aug 2020 23:21:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 071/163] mm: memcg/slab: deprecate
 memory.kmem.slabinfo
Message-ID: <20200807062103.qn4835jCL%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
