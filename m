Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE89C49EC9
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C5922D03
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgLOX7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbgLOXZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:39 -0500
Date:   Tue, 15 Dec 2020 15:23:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074584;
        bh=G7S0duJG1NfhM67ef1EWSz/o26GMIx3LOVGhuVo6COk=;
        h=From:To:Subject:From;
        b=hSY88ddkgNYJCYhmuIIKI0NGT4m87vXrxqJy1qLDsJRJVah7oECRHUtvIZ5p5z8RM
         lpUQclyEwtRUNB/t57HzEU9GfPRsOObia1rilM2GtoBvFSNOsXIwVHnn5yhQ+NwNKG
         6b1kqISUT6da806tVzUT6qcD3zjO2Od6OWpBP/pg=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        pankaj.gupta.linux@gmail.com, vbabka@suse.cz,
        yanfei.xu@windriver.com
Subject:  [merged]
 mm-compaction-rename-start_pfn-to-iteration_start_pfn-in-compact_zone.patch
 removed from -mm tree
Message-ID: <20201215232304.iOPH2F69W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: rename 'start_pfn' to 'iteration_start_pfn' in compact_zone()
has been removed from the -mm tree.  Its filename was
     mm-compaction-rename-start_pfn-to-iteration_start_pfn-in-compact_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/compaction: rename 'start_pfn' to 'iteration_start_pfn' in compact_zone()

There are two 'start_pfn' declared in compact_zone() which have different
meanings.  Rename the second one to 'iteration_start_pfn' to prevent
confusion.

Also, remove an useless semicolon.

Link: https://lkml.kernel.org/r/20201019115044.1571-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-rename-start_pfn-to-iteration_start_pfn-in-compact_zone
+++ a/mm/compaction.c
@@ -2275,7 +2275,7 @@ compact_zone(struct compact_control *cc,
 
 	while ((ret = compact_finished(cc)) == COMPACT_CONTINUE) {
 		int err;
-		unsigned long start_pfn = cc->migrate_pfn;
+		unsigned long iteration_start_pfn = cc->migrate_pfn;
 
 		/*
 		 * Avoid multiple rescans which can happen if a page cannot be
@@ -2287,7 +2287,7 @@ compact_zone(struct compact_control *cc,
 		 */
 		cc->rescan = false;
 		if (pageblock_start_pfn(last_migrated_pfn) ==
-		    pageblock_start_pfn(start_pfn)) {
+		    pageblock_start_pfn(iteration_start_pfn)) {
 			cc->rescan = true;
 		}
 
@@ -2311,8 +2311,7 @@ compact_zone(struct compact_control *cc,
 			goto check_drain;
 		case ISOLATE_SUCCESS:
 			update_cached = false;
-			last_migrated_pfn = start_pfn;
-			;
+			last_migrated_pfn = iteration_start_pfn;
 		}
 
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


