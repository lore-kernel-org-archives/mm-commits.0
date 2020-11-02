Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1E7C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C8C22267
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604278983;
	bh=F8qcgTz7HUcYvdPD7ptp5gX98ePXCXt34pAN6eodv7g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KE+qG1EDemFxoBX8+2BEEX/0rnp9d7TqxtaM/V9hQNL15+Md+xRKxiYrfteHVAmzW
	 FbAQC11unDKDV34kNxxDB3rmaPw/KWEwV2Gql6hht2uxzy1+E3yufiOArUGPvP8o+n
	 x3Q1fqJmph070Bj8HEaEYcHEXv1f381YubynRfRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgKBBDC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:03:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF65B21D91;
        Mon,  2 Nov 2020 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604278982;
        bh=F8qcgTz7HUcYvdPD7ptp5gX98ePXCXt34pAN6eodv7g=;
        h=Date:From:To:Subject:From;
        b=LdyPIrsBvHPLk/jemwIevBfXzyYCR12cmNvKYwtMxMnGTzWfZMJCf2twY8hMlj2H/
         V/0ds/yAav6EU/JaV01+JAFd24IYG0+29npUKdf6R7VHHhvbXGwD7tPBix7D2+17fk
         maCpqaEmcRRWkqZJvR3RmL6fX80DzEcQLWt2VkjU=
Date:   Sun, 01 Nov 2020 17:03:01 -0800
From:   akpm@linux-foundation.org
To:     a.sahrawat@samsung.com, akpm@linux-foundation.org,
        maninder1.s@samsung.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        v.narang@samsung.com, vbabka@suse.cz
Subject:  [folded-merged]
 mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch removed from
 -mm tree
Message-ID: <20201102010301.ygPyV9qSo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch

This patch was dropped because it was folded into mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix

fix -stat.nr_lazyfree_fail as well, per Michal

Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix
+++ a/mm/vmscan.c
@@ -1516,7 +1516,8 @@ unsigned int reclaim_clean_pages_from_li
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
 			TTU_IGNORE_ACCESS, &stat, true);
 	list_splice(&clean_pages, page_list);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -(long)nr_reclaimed);
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
+			    -(long)nr_reclaimed);
 	/*
 	 * Since lazyfree pages are isolated from file LRU from the beginning,
 	 * they will rotate back to anonymous LRU in the end if it failed to
@@ -1526,7 +1527,7 @@ unsigned int reclaim_clean_pages_from_li
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_ANON,
 			    stat.nr_lazyfree_fail);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
-			    -stat.nr_lazyfree_fail);
+			    -(long)stat.nr_lazyfree_fail);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

