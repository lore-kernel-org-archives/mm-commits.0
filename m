Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B21C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C75A22515
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgLODNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgLODNV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:21 -0500
Date:   Mon, 14 Dec 2020 19:12:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001960;
        bh=vhHl8tIc83GrV7b4ghxVTJ5dV18UIaqEWRt8KanEEXc=;
        h=From:To:Subject:In-Reply-To:From;
        b=P6yh8ECkh8tR39WiSFigXwvnn4/plFCdg+zJiY55Ezw2z3d1Q5MdygkIS+U2FgM8a
         AVDuz+VN4tvVBkSXe+O0K2ndSqipQHtKOIbOIZLT+F+P/Q/UfKDK7T5VWZCBT55jG2
         Yy5PLVhyArIitb/NPtVPJcDsBUx2y/HZlE9majrE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        yanfei.xu@windriver.com
Subject:  [patch 159/200] mm/compaction: rename 'start_pfn' to
 'iteration_start_pfn' in compact_zone()
Message-ID: <20201215031239.YoS1twkKE%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
