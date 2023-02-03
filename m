Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6A5C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBCGfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCGfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8A680F93
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4279EB82983
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E638BC433D2;
        Fri,  3 Feb 2023 06:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406128;
        bh=PgbJOKnFOkV7R68+/CvZ6DCCWKno67Yz54BORL/Pbf8=;
        h=Date:To:From:Subject:From;
        b=ZJRuOBIoMVU1LfZDo8H8JuFsOHqzng63gxWl+XeWwONvRRxHyzxQXvP1tWvueFbyi
         jc6BNppymr5NCm93q3QthQ/S4lkmKrl3jlJsRoL0mfIvj/dIdhfxmGc++YZig++7pm
         i6G1mu13Td9VgrwOC49Ak/TOT88ggYntAZIklam4=
Date:   Thu, 02 Feb 2023 22:35:27 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-move-list-validation-into-compact_zone.patch removed from -mm tree
Message-Id: <20230203063527.E638BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: move list validation into compact_zone()
has been removed from the -mm tree.  Its filename was
     mm-compaction-move-list-validation-into-compact_zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: move list validation into compact_zone()
Date: Tue, 10 Jan 2023 21:36:19 +0800

Move the cc.freepages and cc.migratepages list validation into compact_zone()
to remove some duplicate code.

Link: https://lkml.kernel.org/r/15cf54f7d762e87b04ac3cc74536f7d1ebbcd8cd.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-move-list-validation-into-compact_zone
+++ a/mm/compaction.c
@@ -2488,6 +2488,9 @@ out:
 
 	trace_mm_compaction_end(cc, start_pfn, end_pfn, sync, ret);
 
+	VM_BUG_ON(!list_empty(&cc->freepages));
+	VM_BUG_ON(!list_empty(&cc->migratepages));
+
 	return ret;
 }
 
@@ -2526,9 +2529,6 @@ static enum compact_result compact_zone_
 
 	ret = compact_zone(&cc, &capc);
 
-	VM_BUG_ON(!list_empty(&cc.freepages));
-	VM_BUG_ON(!list_empty(&cc.migratepages));
-
 	/*
 	 * Make sure we hide capture control first before we read the captured
 	 * page pointer, otherwise an interrupt could free and capture a page
@@ -2659,9 +2659,6 @@ static void proactive_compact_node(pg_da
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
-
-		VM_BUG_ON(!list_empty(&cc.freepages));
-		VM_BUG_ON(!list_empty(&cc.migratepages));
 	}
 }
 
@@ -2689,9 +2686,6 @@ static void compact_node(int nid)
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
-
-		VM_BUG_ON(!list_empty(&cc.freepages));
-		VM_BUG_ON(!list_empty(&cc.migratepages));
 	}
 }
 
@@ -2868,9 +2862,6 @@ static void kcompactd_do_work(pg_data_t
 				     cc.total_migrate_scanned);
 		count_compact_events(KCOMPACTD_FREE_SCANNED,
 				     cc.total_free_scanned);
-
-		VM_BUG_ON(!list_empty(&cc.freepages));
-		VM_BUG_ON(!list_empty(&cc.migratepages));
 	}
 
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


