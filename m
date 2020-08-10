Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51379C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181AD206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027007;
	bh=wHQnkdZj6eUd1CP2+3fsHhire2Neobnz7Zc1A69ByIw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Qe1QvTAujSh4nkoPzUGdJgQh+I/7jxKSsWVC5ic4YZm9cV8lbqnifk1uUewkXFL0l
	 gF5v6djI22kYvRr1/ZkvGar+yR/pIHAmxfc0LAq7TG/xM/tmhnAE59N2yVHsV52+86
	 cY7wtdKt0I6TguTK6tW/kPQ/7oTcQGYwU56Dwk50=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCgq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F717206C3;
        Mon, 10 Aug 2020 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027005;
        bh=wHQnkdZj6eUd1CP2+3fsHhire2Neobnz7Zc1A69ByIw=;
        h=Date:From:To:Subject:From;
        b=RrWBxkQqB5zXSSW5zJ1uQXZDV+ujqmcINH0GV6JL/zQME1KH72TRzzENa/eY8PBs+
         2CGgq7OgSm14xk8JdxNwdqi4Qm+SILBnLD8kEl07ShOetn/MooZutmjg/pwHPxqUNY
         p/8agx2nIlWrt2tJysqI1EpDhrQyd+qWIQwDvIVo=
Date:   Sun, 09 Aug 2020 19:36:45 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch removed from -mm
 tree
Message-ID: <20200810023645.nEoETHc5f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: move memcg_kmem_bypass() to memcontrol.h
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: move memcg_kmem_bypass() to memcontrol.h

To make the memcg_kmem_bypass() function available outside of the
memcontrol.c, let's move it to memcontrol.h.  The function is small and
nicely fits into static inline sort of functions.

It will be used from the slab code.

Link: http://lkml.kernel.org/r/20200623174037.3951353-12-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++++++++
 mm/memcontrol.c            |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -1440,6 +1440,18 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
+static inline bool memcg_kmem_bypass(void)
+{
+	if (in_interrupt())
+		return true;
+
+	/* Allow remote memcg charging in kthread contexts. */
+	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
+	     !current->active_memcg)
+		return true;
+	return false;
+}
+
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
--- a/mm/memcontrol.c~mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh
+++ a/mm/memcontrol.c
@@ -2945,18 +2945,6 @@ static void memcg_schedule_kmem_cache_cr
 	queue_work(memcg_kmem_cache_wq, &cw->work);
 }
 
-static inline bool memcg_kmem_bypass(void)
-{
-	if (in_interrupt())
-		return true;
-
-	/* Allow remote memcg charging in kthread contexts. */
-	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
-	     !current->active_memcg)
-		return true;
-	return false;
-}
-
 /**
  * memcg_kmem_get_cache: select the correct per-memcg cache for allocation
  * @cachep: the original global kmem cache
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

