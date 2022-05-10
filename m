Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F2BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiEJAv5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiEJAv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:51:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2D26FA4A
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60EDB81A10
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B2C385C2;
        Tue, 10 May 2022 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652143678;
        bh=vIyB/1KOPHnfAydQT6aK3ZbWI0rLTM0qoML9m++2a8c=;
        h=Date:To:From:Subject:From;
        b=PD6PyCvn8ch0pP9ykTmRPqDmRekFx+bmEchjPXrDx4fftEZ2VGHpca/YQmEuUxsdW
         GaHL7qB0+EGUM5Wm3ll/akVPDVap214lqlgDFdmA6wjFGibzWgrTGcdrLfAO0WYh6w
         aOvZn5aQky2RYMpv27ptor5GBiqP9vVz8QLXiPy0=
Date:   Mon, 09 May 2022 17:47:57 -0700
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        ohkwon1043@gmail.com, mgorman@techsingularity.net,
        lakroforce@gmail.com, jsyoo5b@gmail.com, hannes@cmpxchg.org,
        dthex5d@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch removed from -mm tree
Message-Id: <20220510004758.521B2C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-cache-the-result-of-node_dirty_ok-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch

This patch was dropped because it was folded into mm-page_alloc-cache-the-result-of-node_dirty_ok.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-cache-the-result-of-node_dirty_ok-fix

rename last_pgdat_dirty_limit to last_pgdat_dirty_ok

Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ohhoon Kwon <ohkwon1043@gmail.com>
Cc: JaeSang Yoo <jsyoo5b@gmail.com>
Cc: Jiyoup Kim <lakroforce@gmail.com>
Cc: Donghyeok Kim <dthex5d@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cache-the-result-of-node_dirty_ok-fix
+++ a/mm/page_alloc.c
@@ -4022,7 +4022,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	bool last_pgdat_dirty_limit = false;
+	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 
 retry:
@@ -4063,10 +4063,10 @@ retry:
 		if (ac->spread_dirty_pages) {
 			if (last_pgdat != zone->zone_pgdat) {
 				last_pgdat = zone->zone_pgdat;
-				last_pgdat_dirty_limit = node_dirty_ok(zone->zone_pgdat);
+				last_pgdat_dirty_ok = node_dirty_ok(zone->zone_pgdat);
 			}
 
-			if (!last_pgdat_dirty_limit)
+			if (!last_pgdat_dirty_ok)
 				continue;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-cache-the-result-of-node_dirty_ok.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

