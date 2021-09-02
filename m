Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130BCC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E622360FDA
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346355AbhIBVOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhIBVOr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519AB6102A;
        Thu,  2 Sep 2021 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617228;
        bh=UmlkT1/Nx0k5JwNPSQ+AzJW3oRTE7doWAtPikOLG56o=;
        h=Date:From:To:Subject:From;
        b=RJRYh0Iqt9UwG4oQeJHZw6c0Hof3jbu62w65MFld0MJVMpCFkRtLoVwxJeAt2GJ/G
         jn5u6FOPvYDJ++mNZ/VNgSRjqHewfHjH58VW/xfBbgTle4f0Id7qK2ceL2DJR/ohkV
         +P0UeEOT0tHtzF90wCy253M+qy6984Yr7mCPypxs=
Date:   Thu, 02 Sep 2021 14:13:47 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        m.szyprowski@samsung.com, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        yangyingliang@huawei.com, ying.huang@intel.com
Subject:  [folded-merged]
 memcg-infrastructure-to-flush-memcg-stats-v5.patch removed from -mm tree
Message-ID: <20210902211347.BH7sfl6HH%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     memcg-infrastructure-to-flush-memcg-stats-v5.patch

This patch was dropped because it was folded into memcg-infrastructure-to-f=
lush-memcg-stats.patch

------------------------------------------------------
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg-infrastructure-to-flush-memcg-stats-v5

fix sleep-in-wrong context bug

Link: https://lkml.kernel.org/r/20210716212137.1391164-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
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
@@ -5350,7 +5350,7 @@ void mem_cgroup_flush_stats(void)
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

writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-cleanup-racy-sum-avoidance-code.patch
memcg-make-memcg-event_list_lock-irqsafe.patch

