Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36C1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C22610D1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhIPTMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231517AbhIPTMq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E5E36108F;
        Thu, 16 Sep 2021 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819485;
        bh=YeZbeH+s6dC/itbL1VIGvdl4LE8NmpKw3dmgaXNuW1E=;
        h=Date:From:To:Subject:From;
        b=TpbtMl3L2xK0GFkbnLNXW2Mn7czK9sJaLvGjabMnceXnBCYmHZhm0GDfds16KjAnb
         WjVCgog8avEQcQ97WXVQRwbpRGSFYIYcni7Xk8S65fT2nS5aQrd09BgcIZUXFrJV7n
         XVWuZkpMUbm7JoerCTJ0Xmg9nxIjHGXOAGqJ17AU=
Date:   Thu, 16 Sep 2021 12:11:24 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, geert+renesas@glider.be, gonsolo@gmail.com,
        juri.lelli@redhat.com, matt@codeblueprint.co.uk, mgorman@suse.de,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        vbabka@suse.cz, vincent.guittot@linaro.org, ysato@users.osdn.me
Subject:  +
 mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch added to -mm
 tree
Message-ID: <20210916191124.FOopixgUz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move node_reclaim_distance to fix NUMA without SMP
has been added to the -mm tree.  Its filename is
     mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm: move node_reclaim_distance to fix NUMA without SMP

Patch series "Fix NUMA without SMP".

SuperH is the only architecture which still supports NUMA without SMP, for
good reasons (various memories scattered around the address space, each
with varying latencies).  This series fixes two build errors due to
variables and functions used by the NUMA code being provided by SMP-only
source files or sections.


This patch (of 2):

If CONFIG_NUMA=y, but CONFIG_SMP=n (e.g. sh/migor_defconfig):

    sh4-linux-gnu-ld: mm/page_alloc.o: in function `get_page_from_freelist':
    page_alloc.c:(.text+0x2c24): undefined reference to `node_reclaim_distance'

Fix this by moving the declaration of node_reclaim_distance from an
SMP-only to a generic file.

Link: https://lkml.kernel.org/r/cover.1631781495.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/6432666a648dde85635341e6c918cee97c97d264.1631781495.git.geert+renesas@glider.be
Fixes: a55c7454a8c887b2 ("sched/topology: Improve load balancing on AMD EPYC systems")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: Gon Solo <gonsolo@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/topology.c |    1 -
 mm/page_alloc.c         |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/topology.c~mm-move-node_reclaim_distance-to-fix-numa-without-smp
+++ a/kernel/sched/topology.c
@@ -1481,7 +1481,6 @@ static int			sched_domains_curr_level;
 int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
 static struct cpumask		***sched_domains_numa_masks;
-int __read_mostly		node_reclaim_distance = RECLAIM_DISTANCE;
 
 static unsigned long __read_mostly *sched_numa_onlined_nodes;
 #endif
--- a/mm/page_alloc.c~mm-move-node_reclaim_distance-to-fix-numa-without-smp
+++ a/mm/page_alloc.c
@@ -3958,6 +3958,8 @@ bool zone_watermark_ok_safe(struct zone
 }
 
 #ifdef CONFIG_NUMA
+int __read_mostly node_reclaim_distance = RECLAIM_DISTANCE;
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
_

Patches currently in -mm which might be from geert+renesas@glider.be are

mm-move-node_reclaim_distance-to-fix-numa-without-smp.patch
mm-move-fold_vm_numa_events-to-fix-numa-without-smp.patch

