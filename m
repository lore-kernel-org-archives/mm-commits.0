Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E4EC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA3C2073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026984;
	bh=ZfFCn/oVQSWJDeLw53qfOJ4qCI6hM4GnvIaqKmJ3Id8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1ulFIU5zy93aTxfZS5wwSamdiPRlVfQPyl20GMZo1ScLFhc4ta/hduykX+SavVIOD
	 PQeWgdaw+mDOimAZUSiq+wSxuyHA7eUDpInuXj9CkQEFpiFEfOfrFNO69pCY1tZMI1
	 3EaRd8vM1R47B04vn2ii2rQBLPFCjwRItngySHXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663762065D;
        Mon, 10 Aug 2020 02:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026983;
        bh=ZfFCn/oVQSWJDeLw53qfOJ4qCI6hM4GnvIaqKmJ3Id8=;
        h=Date:From:To:Subject:From;
        b=BEbTHNCLI1wUv5fcac01l4/2FmrpuqAJLBYGRZZg5+XMDF9CZAdUYrUhZkKcnoZgr
         7iNWpR/s0q9tT3nbjuy2VZe5xLCOo1K0eF/Pc/sz8OSqmBr2sd8Eaokc0QODqbk8p5
         fo/dtJ3GREpGbdwHLr+/FfZEQ9uHqL0amN13fBEA=
Date:   Sun, 09 Aug 2020 19:36:23 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, shakeelb@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-kmem-make-memcg_kmem_enabled-irreversible.patch removed from -mm tree
Message-ID: <20200810023623.vvynP2JYU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: make memcg_kmem_enabled() irreversible
has been removed from the -mm tree.  Its filename was
     mm-kmem-make-memcg_kmem_enabled-irreversible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: make memcg_kmem_enabled() irreversible

Historically the kernel memory accounting was an opt-in feature, which
could be enabled for individual cgroups.  But now it's not true, and it's
on by default both on cgroup v1 and cgroup v2.  And as long as a user has
at least one non-root memory cgroup, the kernel memory accounting is on. 
So in most setups it's either always on (if memory cgroups are in use and
kmem accounting is not disabled), either always off (otherwise).

memcg_kmem_enabled() is used in many places to guard the kernel memory
accounting code.  If memcg_kmem_enabled() can reverse from returning true
to returning false (as now), we can't rely on it on release paths and have
to check if it was on before.

If we'll make memcg_kmem_enabled() irreversible (always returning true
after returning it for the first time), it'll make the general logic more
simple and robust.  It also will allow to guard some checks which
otherwise would stay unguarded.

Link: http://lkml.kernel.org/r/20200702180926.1330769-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-make-memcg_kmem_enabled-irreversible
+++ a/mm/memcontrol.c
@@ -3416,7 +3416,8 @@ static int memcg_online_kmem(struct mem_
 	if (memcg_id < 0)
 		return memcg_id;
 
-	static_branch_inc(&memcg_kmem_enabled_key);
+	static_branch_enable(&memcg_kmem_enabled_key);
+
 	/*
 	 * A memory cgroup is considered kmem-online as soon as it gets
 	 * kmemcg_id. Setting the id after enabling static branching will
@@ -3486,11 +3487,6 @@ static void memcg_free_kmem(struct mem_c
 	/* css_alloc() failed, offlining didn't happen */
 	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
 		memcg_offline_kmem(memcg);
-
-	if (memcg->kmem_state == KMEM_ALLOCATED) {
-		WARN_ON(!list_empty(&memcg->kmem_caches));
-		static_branch_dec(&memcg_kmem_enabled_key);
-	}
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
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

