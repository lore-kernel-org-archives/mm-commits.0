Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A44C56201
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C12522202
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604035556;
	bh=6/kvG/hH4eE8UFUIKUDLboPCyZBdBC4GYZnKNpMpW+c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wqcfM8LTpx/omv9c3/8kFwhIx6HGixRHC471tXsSOmSnOMK5WSt5JmMF6ra+5Fivo
	 qCxg/+adSbSTeNxaKaKsqjH4JgkSS+EGLR7kaKgJ32coOA6K8D6ijtFz4h4KopIGQB
	 pW/3JORhoLWg0Vi0i2DPYlkIQmpVpmflRajqceuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3FZz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgJ3FZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Oct 2020 01:25:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E05B221FF;
        Fri, 30 Oct 2020 05:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604035554;
        bh=6/kvG/hH4eE8UFUIKUDLboPCyZBdBC4GYZnKNpMpW+c=;
        h=Date:From:To:Subject:From;
        b=WRXMaAg6ua1ggRUFgsBG4XWn+T1FXSFJjw3FvSozPx6JyPvnz18ptuqTWvQI7Eo2T
         VgNk2O1VgH8savXccm5DtEO0OZ8O7Zmz2cA4fjSt4KTVq+xSfvoMOpF2ta4jfAW7fI
         f7vBXu6kwei+tLSBAe6LlmL6wtFqhM6TwgEwDGTY=
Date:   Thu, 29 Oct 2020 22:25:53 -0700
From:   akpm@linux-foundation.org
To:     a.sahrawat@samsung.com, akpm@linux-foundation.org,
        maninder1.s@samsung.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        v.narang@samsung.com, vbabka@suse.cz
Subject:  +
 mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch added to -mm
 tree
Message-ID: <20201030052553.26v1O7R58%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

