Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DA3C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 04:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4362860FC0
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 04:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhIOEKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 00:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbhIOEKt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 00:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3BE660F8F;
        Wed, 15 Sep 2021 04:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678970;
        bh=/3xLGpwPXthCyLRW8gA8OYZzQFWKdWyCFOJvyNo2RtQ=;
        h=Date:From:To:Subject:From;
        b=GyiWFwfbpYp4k+j3MTvEfD6+/AluRz/G6zoT7RXa0kT8c8ItEPLR/zXKyzwYP+3Vn
         urT32Fbd+dp7vsCwslNk4sxJ4yXWqWhf6Cr8hsWNPdubvnTcUBEPv/gv/TvL25lLtP
         AfVUlrYKHFadnH4ry9Y2S532Ez398ENMhpQ0HOW4=
Date:   Tue, 14 Sep 2021 21:09:30 -0700
From:   akpm@linux-foundation.org
To:     liushixin2@huawei.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org
Subject:  +
 mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch added to -mm
 tree
Message-ID: <20210915040930.W-yFG6VaX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: annotate data race for zone->free_area[order].nr_free
has been added to the -mm tree.  Its filename is
     mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/vmstat: annotate data race for zone->free_area[order].nr_free

KCSAN reports a data-race on v5.10 which also exists on mainline:

==================================================================
BUG: KCSAN: data-race in extfrag_for_order+0x33/0x2d0

race at unknown origin, with read to 0xffff9ee9bfffab48 of 8 bytes by task 34 on cpu 1:
 extfrag_for_order+0x33/0x2d0
 kcompactd+0x5f0/0xce0
 kthread+0x1f9/0x220
 ret_from_fork+0x22/0x30

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 34 Comm: kcompactd0 Not tainted 5.10.0+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
==================================================================

Access to zone->free_area[order].nr_free in extfrag_for_order()/frag_show_print()
is lockless. That's intentional and the stats are a rough estimate anyway.
Annotate them with data_race().

Link: https://lkml.kernel.org/r/20210908015606.3999871-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-annotate-data-race-for-zone-free_areanr_free
+++ a/mm/vmstat.c
@@ -1071,7 +1071,7 @@ static void fill_contig_page_info(struct
 		unsigned long blocks;
 
 		/* Count number of free blocks */
-		blocks = zone->free_area[order].nr_free;
+		blocks = data_race(zone->free_area[order].nr_free);
 		info->free_blocks_total += blocks;
 
 		/* Count free base pages */
@@ -1445,7 +1445,7 @@ static void frag_show_print(struct seq_f
 
 	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
 	for (order = 0; order < MAX_ORDER; ++order)
-		seq_printf(m, "%6lu ", zone->free_area[order].nr_free);
+		seq_printf(m, "%6lu ", data_race(zone->free_area[order].nr_free));
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch

