Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5CEC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636B861051
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhISWy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 18:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233129AbhISWy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 18:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C74D61028;
        Sun, 19 Sep 2021 22:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632092013;
        bh=lTFcEA6dSA2BIEGY19qLKqpTVbzw3RoRspDOM/B0nL4=;
        h=Date:From:To:Subject:From;
        b=x1H9u/LVYOfgq/chBqQRJ4z5m1scTCFz95scppLbuReyETMmGk5nYc/xVb8GMAoaq
         CJco17hOQDGbwE6cJ/lDSPLSCGym4ds2RIV6jHZPfoCN3DylszTpGmvvLPa1JOV+8p
         T492Lf1GuiXv71N36ddDH+r9qd5Pnv7tm1pQfUjU=
Date:   Sun, 19 Sep 2021 15:53:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        liushixin2@huawei.com
Subject:  +
 mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch added to -mm
 tree
Message-ID: <20210919225332.i522o%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch

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
Subject: mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix

add comments

Link: https://lkml.kernel.org/r/20210918084655.2696522-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix
+++ a/mm/vmstat.c
@@ -1070,7 +1070,12 @@ static void fill_contig_page_info(struct
 	for (order = 0; order < MAX_ORDER; order++) {
 		unsigned long blocks;
 
-		/* Count number of free blocks */
+		/*
+		 * Count number of free blocks.
+		 *
+		 * Access to nr_free is lockless as nr_free is used only for
+		 * diagnostic purposes. Use data_race to avoid KCSAN warning.
+		 */
 		blocks = data_race(zone->free_area[order].nr_free);
 		info->free_blocks_total += blocks;
 
@@ -1445,6 +1450,10 @@ static void frag_show_print(struct seq_f
 
 	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
 	for (order = 0; order < MAX_ORDER; ++order)
+		/*
+		 * Access to nr_free is lockless as nr_free is used only for
+		 * printing purposes. Use data_race to avoid KCSAN warning.
+		 */
 		seq_printf(m, "%6lu ", data_race(zone->free_area[order].nr_free));
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch
mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch

