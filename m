Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9292EC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjAJX3T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjAJX3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:29:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F488659D
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:29:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD628B81A13
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA6CC433D2;
        Tue, 10 Jan 2023 23:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393355;
        bh=7hsMaFQJrJStipEqhn14kY0UNblSvcUwjjqpey+Xf5g=;
        h=Date:To:From:Subject:From;
        b=u74RBXIVRNxWAVbk4VeVH1WAaB2RVyZEu5AQQoM1OKvekrLyNeiFCyhceVCeVqg8b
         Y+ozjTGfLwpE/1A+rGRdfIoYXRvjesdnsG6pBENFKVMzqGN145hhMe+MjontGeME7z
         phLQKigrAbwMPZ55v0EpLxHLjoLgB+VQ9EWVS7cE=
Date:   Tue, 10 Jan 2023 15:29:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-move-list-validation-into-compact_zone.patch added to mm-unstable branch
Message-Id: <20230110232915.6DA6CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: move list validation into compact_zone()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-move-list-validation-into-compact_zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-move-list-validation-into-compact_zone.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/compaction.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

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

mm-compaction-remove-redundant-vm_bug_on-in-compact_zone.patch
mm-compaction-move-list-validation-into-compact_zone.patch
mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch
mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch
mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

