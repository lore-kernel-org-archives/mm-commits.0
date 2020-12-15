Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A225C3526E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FA822D49
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgLPAAK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbgLOX0o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:44 -0500
Date:   Tue, 15 Dec 2020 15:18:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074291;
        bh=aqgYhvIv03ZgN39guNT3CMeClHO4fwoLSYOQ0mNmLsI=;
        h=From:To:Subject:From;
        b=ZdDeSRZ1NQuibRr4FrTyMcje9H7uldsA0khW/erc1gQpgQjBZBIK4ILA26qZHHFgS
         Prp3emAl43e5cqJ3Wvq0yr9QEVJ3Hc1tIfanCIRIYZv4qN+VgQb+/hI8iYdYY4Km00
         Uc0V8gs+4VX5jGmwM1fNCN2rRlTvHIOeBx8DPdrc=
From:   akpm@linux-foundation.org
To:     areber@redhat.com, chris@chrisdown.name,
        christian.brauner@ubuntu.com, elver@google.com, esyr@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, laoar.shao@gmail.com, mhocko@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org,
        shakeelb@google.com, songmuchun@bytedance.com, surenb@google.com,
        tglx@linutronix.de, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch removed
 from -mm tree
Message-ID: <20201215231810.3--gD_Ubn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix return of child memcg objcg for root memcg
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix return of child memcg objcg for root memcg

Consider the following memcg hierarchy.

                    root
                   /    \
                  A      B

If we failed to get the reference on objcg of memcg A, the
get_obj_cgroup_from_current can return the wrong objcg for the root
memcg.

Link: https://lkml.kernel.org/r/20201029164429.58703-1-songmuchun@bytedance.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Adrian Reber <areber@redhat.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg
+++ a/mm/memcontrol.c
@@ -2975,6 +2975,7 @@ __always_inline struct obj_cgroup *get_o
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
+		objcg = NULL;
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


