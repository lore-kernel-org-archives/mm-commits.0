Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCB4C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE30224B0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLODHK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgLODGs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:48 -0500
Date:   Mon, 14 Dec 2020 19:06:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001593;
        bh=M0bGpBzvIWDYVFC3o78I25RTIutApyRVzkRwwKDOgZI=;
        h=From:To:Subject:In-Reply-To:From;
        b=sn4ruzB/I0ncDwO52YR+APKJB5TUDvV7TlEYs3DBp6bb2NRu6Rac921qPBOJ30afa
         WRZjTPPNHr289lEB40Mk8ImHvEVchjDjCTUFluAC8h5/obfhCnAlpFESHEhvtfvlu2
         uosKelnFJMXn3+Etfi8x9Etzb4FKqwjR2F/SUR1E=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, areber@redhat.com, chris@chrisdown.name,
        christian.brauner@ubuntu.com, elver@google.com, esyr@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, shakeelb@google.com,
        songmuchun@bytedance.com, surenb@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 058/200] mm: memcg/slab: fix return of child memcg
 objcg for root memcg
Message-ID: <20201215030631.R7W-snAn0%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
