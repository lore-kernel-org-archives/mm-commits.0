Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE02BC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F246136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhKEUqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhKEUqk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB3B61357;
        Fri,  5 Nov 2021 20:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145040;
        bh=ciS8U1tUGH4nWOs2ja52ZMQjueYLkoBeqBu+ryMcCuw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hbxLh4Kn+4JKLoUEJzYSm5uoPMHJchgXZqU5u0ePXSL2d8kOE4mTJtv0Epcqnox5Z
         w27lUA7Goqs9vFawNIFvh841r7t4dUw41tPH2/HbfJugusT0dNy7JLMqbVwwYI8kUD
         F2ytR68FDqa/WhSmDD/bUC2nhQIQldDxHKnRJ6ls=
Date:   Fri, 05 Nov 2021 13:43:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liushixin2@huawei.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 179/262] mm/vmstat: annotate data race for
 zone->free_area[order].nr_free
Message-ID: <20211105204359.98NCTdblm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[liushixin2@huawei.com: add comments]
  Link: https://lkml.kernel.org/r/20210918084655.2696522-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20210908015606.3999871-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-annotate-data-race-for-zone-free_areanr_free
+++ a/mm/vmstat.c
@@ -1070,8 +1070,13 @@ static void fill_contig_page_info(struct
 	for (order = 0; order < MAX_ORDER; order++) {
 		unsigned long blocks;
 
-		/* Count number of free blocks */
-		blocks = zone->free_area[order].nr_free;
+		/*
+		 * Count number of free blocks.
+		 *
+		 * Access to nr_free is lockless as nr_free is used only for
+		 * diagnostic purposes. Use data_race to avoid KCSAN warning.
+		 */
+		blocks = data_race(zone->free_area[order].nr_free);
 		info->free_blocks_total += blocks;
 
 		/* Count free base pages */
@@ -1446,7 +1451,11 @@ static void frag_show_print(struct seq_f
 
 	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
 	for (order = 0; order < MAX_ORDER; ++order)
-		seq_printf(m, "%6lu ", zone->free_area[order].nr_free);
+		/*
+		 * Access to nr_free is lockless as nr_free is used only for
+		 * printing purposes. Use data_race to avoid KCSAN warning.
+		 */
+		seq_printf(m, "%6lu ", data_race(zone->free_area[order].nr_free));
 	seq_putc(m, '\n');
 }
 
_
