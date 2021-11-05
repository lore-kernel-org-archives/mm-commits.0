Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DFCC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E7C61242
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKESqt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKESqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB426023D;
        Fri,  5 Nov 2021 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137849;
        bh=m+xeNHYaBmqjoAkHgF5NYQKooIU3Kn8A2lekesy4F0Q=;
        h=Date:From:To:Subject:From;
        b=0QiLGjEjcnlYf4P31ZT1CpptJXA5US3SHUCL4oFYG/K2O0XcHwWcBEL4t717di45J
         kJV/DLnUe2dYp9BnlAT2IlT/7PIADVPOatkw+MMS4BCG0TaG0oQ2h2S5b4ubx67umk
         MyXvGI6JwUeUi/g1cyDVTz9PjDeyBq3QM955AGWE=
Date:   Fri, 05 Nov 2021 11:44:08 -0700
From:   akpm@linux-foundation.org
To:     liushixin2@huawei.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org
Subject:  [folded-merged]
 mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch removed
 from -mm tree
Message-ID: <20211105184408.nGxxf9Hgf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-annotate-data-race-for-zone-free_areanr_free-fix.patch

This patch was dropped because it was folded into mm-vmstat-annotate-data-race-for-zone-free_areanr_free.patch

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
 
@@ -1446,6 +1451,10 @@ static void frag_show_print(struct seq_f
 
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

