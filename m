Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EBAC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB13964F24
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhBXUFj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhBXUEQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:04:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9557B64F25;
        Wed, 24 Feb 2021 20:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197000;
        bh=QbJ3YkkYDTvv4Gjc+7xdeNRdcykXss4NT5t1rXlDarc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pLq4hV5A7vEkHiF/euckUdd5jVV+pmj2A7zuyLwni4UTqq2URMxcKdCfN8IZZRrgr
         WncEjrkm3je5pbGOqfAavQ46HAcfoOnaszgd/XYA1XdyUB40QIqT6IPyHNCgptSNrr
         ks+aPuRtqwXb9FeGJ4fJbxYoEpAzfB278EkIQCmo=
Date:   Wed, 24 Feb 2021 12:03:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        feng.tang@intel.com, gregkh@linuxfoundation.org, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        neilb@suse.de, pankaj.gupta@cloud.ionos.com, rafael@kernel.org,
        rdunlap@infradead.org, samitolvanen@google.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 057/173] mm: memcontrol: fix NR_ANON_THPS
 accounting in charge moving
Message-ID: <20210224200319.BJzkKisOt%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix NR_ANON_THPS accounting in charge moving

Patch series "Convert all THP vmstat counters to pages", v6.

This patch series is aimed to convert all THP vmstat counters to pages.

The unit of some vmstat counters are pages, some are bytes, some are
HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
counters to the userspace, we have to know the unit of the vmstat counters
is which one. When the unit is bytes or kB, both clearly distinguishable
by the B/KB suffix. But for the THP vmstat counters, we may make mistakes.

For example, the below is some bug fix for the THP vmstat counters:

  - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
  - The first commit in this series ("fix NR_ANON_THPS accounting in charge moving")

This patch series can make the code clear. And make all the unit of the THP
vmstat counters in pages. Finally, the unit of the vmstat counters are
pages, kB and bytes. The B/KB suffix can tell us that the unit is bytes
or kB. The rest which is without suffix are pages.

In this series, I changed the following vmstat counters unit from HPAGE_PMD_NR
to pages. However, there is no change to the print format of output to user
space.

  - NR_ANON_THPS
  - NR_FILE_THPS
  - NR_SHMEM_THPS
  - NR_SHMEM_PMDMAPPED
  - NR_FILE_PMDMAPPED

Doing this also can make the statistics more accuracy for the THP vmstat
counters. This series is consistent with 8f182270dfec ("mm/swap.c: flush lru
pvecs on compound page arrival").

Because we use struct per_cpu_nodestat to cache the vmstat counters, which
leads to inaccurate statistics especially THP vmstat counters. In the systems
with hundreds of processors it can be GBs of memory. For example, for a 96
CPUs system, the threshold is the maximum number of 125. And the per cpu
counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth of
memory in one go) so skipping the batching seems like sensible. Although every
THP stats update overflows the per-cpu counter, resorting to atomic global
updates. But it can make the statistics more accuracy for the THP vmstat
counters. From this point of view, I think that do this converting is
reasonable.

Thanks Hugh for mentioning this. This was inspired by Johannes and Roman.
Thanks to them.


This patch (of 7):

The unit of NR_ANON_THPS is HPAGE_PMD_NR already.  So it should inc/dec by
one rather than nr_pages.

Link: https://lkml.kernel.org/r/20201228164110.2838-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20201228164110.2838-2-songmuchun@bytedance.com
Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rafael. J. Wysocki <rafael@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving
+++ a/mm/memcontrol.c
@@ -5652,10 +5652,8 @@ static int mem_cgroup_move_account(struc
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
 			if (PageTransHuge(page)) {
-				__mod_lruvec_state(from_vec, NR_ANON_THPS,
-						   -nr_pages);
-				__mod_lruvec_state(to_vec, NR_ANON_THPS,
-						   nr_pages);
+				__dec_lruvec_state(from_vec, NR_ANON_THPS);
+				__inc_lruvec_state(to_vec, NR_ANON_THPS);
 			}
 
 		}
_
