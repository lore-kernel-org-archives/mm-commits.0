Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39918C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5ABB20BED
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600222262;
	bh=xXfJ32CdFpyejTCwAJcxtdsGGLVCaA43bS9S4wwJivw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=R9K2YCscCnGH/wy9SSZPhLIYQLtZRh4cUOmt6viC+I+dxi6oueLMFDm9S33Pp4C+I
	 PENfeAT4+GJESrVmEfgkK5nlkpUnWQQHA6cR5+78qFrD9kiwuAUlNKKzm5+efLNhXF
	 bGHpstuSI09U45Zw5SFgfKh5nD4hNJgRUCUIVyMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgIPCLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgIPCLB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 22:11:01 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E36C206C9;
        Wed, 16 Sep 2020 02:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600222260;
        bh=xXfJ32CdFpyejTCwAJcxtdsGGLVCaA43bS9S4wwJivw=;
        h=Date:From:To:Subject:From;
        b=Wta6iK1oFf7XQ8R8WXx4/9KKq/cLPFP+ocFKD+UgisXolQJ43/4A5OkVrx+X3WiP8
         KAyLNJMca8IVdTTv7mZ9CiNmkHKkJCZTKnyS5nZhT4+3+xjsURxx7hLGt6P024UAeP
         Xbcq0Yqxg3wHA6bwRwYG8I6/mWZWSGTbIvYhv10g=
Date:   Tue, 15 Sep 2020 19:10:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, tj@kernel.org,
        shakeelb@google.com, mhocko@suse.com, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name,
        longman@redhat.com
Subject:  + mm-memcg-simplify-mem_cgroup_get_max-v4.patch added to
 -mm tree
Message-ID: <20200916021059.4ZynN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-simplify-mem_cgroup_get_max-v4
has been added to the -mm tree.  Its filename is
     mm-memcg-simplify-mem_cgroup_get_max-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-simplify-mem_cgroup_get_max-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-simplify-mem_cgroup_get_max-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm-memcg-simplify-mem_cgroup_get_max-v4

Link: https://lkml.kernel.org/r/20200914150928.7841-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-mem_cgroup_get_max-v4
+++ a/mm/memcontrol.c
@@ -1642,8 +1642,12 @@ unsigned long mem_cgroup_get_max(struct
 			max += min(READ_ONCE(memcg->swap.max),
 				   (unsigned long)total_swap_pages);
 	} else { /* v1 */
-		if (mem_cgroup_swappiness(memcg))
-			max = memcg->memsw.max;
+		if (mem_cgroup_swappiness(memcg)) {
+			/* Calculate swap excess capacity from memsw limit */
+			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
+
+			max += min(swap, (unsigned long)total_swap_pages);
+		}
 	}
 	return max;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-clean-up-obsolete-enum-charge_type.patch
mm-memcg-simplify-mem_cgroup_get_max.patch
mm-memcg-simplify-mem_cgroup_get_max-v4.patch
mm-memcg-unify-swap-and-memsw-page-counters.patch

