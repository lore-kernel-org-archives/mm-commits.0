Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3E4C2D0A3
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 00:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D69F22076D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 00:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604018644;
	bh=LsouIRCeSwptER7pu8Tv/wSkXuSB+e5qcVFBmY5IPYU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TkD1MlvKH3WCbk8dGmi+rZb866Tkdy5EYlXWWnp3dHEdqB4f38tAZUsQtPDnAdFcl
	 dvjOUsJj4DBLRKh8Z1ZKCIZlTSdtvqy121pHh96v/vhFLb/pyEM2sjKqnGOLfN6SYB
	 /TcvpcZTyi/17KZBUL8Z84oqqjFdQ6FmPmQBh8Ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgJ3AoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Oct 2020 20:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgJ3AoE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Oct 2020 20:44:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B4B20691;
        Fri, 30 Oct 2020 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604018643;
        bh=LsouIRCeSwptER7pu8Tv/wSkXuSB+e5qcVFBmY5IPYU=;
        h=Date:From:To:Subject:From;
        b=U3iFoRol1lD8q1bgcei0fqCCf66Ib/+UJfGnHojKdmvGJcxu3JPLgovgCKbgfkAQF
         hsZGjZ6uDiTwsugwd6mr/X7SPDgoeyH9OHv4mBcfsmDqEy2GgpyS0HHNJpp0cTqfxG
         eLtm9aQTKmVPLRkd6/EvROhCPtwM9ktQ4RjFUTnQ=
Date:   Thu, 29 Oct 2020 17:44:01 -0700
From:   akpm@linux-foundation.org
To:     areber@redhat.com, chris@chrisdown.name,
        christian.brauner@ubuntu.com, elver@google.com, esyr@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, laoar.shao@gmail.com, mhocko@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org,
        shakeelb@google.com, songmuchun@bytedance.com, surenb@google.com,
        tglx@linutronix.de, vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch added to
 -mm tree
Message-ID: <20201030004401.WzgVa3UV3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix return of child memcg objcg for root memcg
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix return of child memcg objcg for root memcg

Consider the following memcg hierarchy.

                    root
                   /    \
                  A      B

If we failed to get the reference on objcg of memcg A, the
get_obj_cgroup_from_current can return the wrong objcg for the root memcg.

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
@@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_o
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
+		objcg = NULL;
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch

