Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA7BC12002
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776BF613DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhGPXHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 19:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhGPXHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 19:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7F66109E;
        Fri, 16 Jul 2021 23:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626476650;
        bh=mt1+mHn9CM2H40a5ZPMy8jfMMn/H8DZYb0TEelJcBYo=;
        h=Date:From:To:Subject:From;
        b=jOu4OAk1U4SVExR2Ew4Fq3BOZkKCaCEts4diZZ0JZq99+cwrR2l1GIu52RR1fv0wQ
         /OPXbtC/ytw4eDtHDmtM8pNxSMsaJwSJx4EepaWqToyBuNnv3IB3FVvwkRsEsBgJnJ
         mvNduZn9gqqCo+4ff4TyaQigtNjS4IBJyMdJFSLs=
Date:   Fri, 16 Jul 2021 16:04:09 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        m.szyprowski@samsung.com, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        yangyingliang@huawei.com, ying.huang@intel.com
Subject:  + memcg-infrastructure-to-flush-memcg-stats-v5.patch
 added to -mm tree
Message-ID: <20210716230409.ihUziw7UR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-infrastructure-to-flush-memcg-stats-v5
has been added to the -mm tree.  Its filename is
     memcg-infrastructure-to-flush-memcg-stats-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-infrastructure-to-flush=
-memcg-stats-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-infrastructure-to-flush=
-memcg-stats-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg-infrastructure-to-flush-memcg-stats-v5

fix sleep-in-wrong context bug

Link: https://lkml.kernel.org/r/20210716212137.1391164-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-infrastructure-to-flush-memcg-stats-v5
+++ a/mm/memcontrol.c
@@ -5358,7 +5358,7 @@ void mem_cgroup_flush_stats(void)
 	if (!spin_trylock(&stats_flush_lock))
 		return;
=20
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	spin_unlock(&stats_flush_lock);
 }
=20
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch

