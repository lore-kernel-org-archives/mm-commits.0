Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0264FC636D6
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjBTUpn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjBTUpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:45:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0251C5A9
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421ADB80DCB
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F84C433D2;
        Mon, 20 Feb 2023 20:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676925905;
        bh=xAi142y6p3HVdNAmbJq9tt7wJ37X7y2v0RyGj9tyP98=;
        h=Date:To:From:Subject:From;
        b=MJdKU4aK6bFf5Jf74fUh8EPhKhv/xb6qJDcbdbqgb/aYTzIB823QA6xQYCs2BTjKZ
         6JTBji7dXp/W9THIY9LQ/hAv15fcwd2ml4L9XTheMfqhiuBDLCa40iAoQdQC76Wq2T
         N5RS2pZXoAdgi66JveJk424Qj5pSiu+t/OyacSNs=
Date:   Mon, 20 Feb 2023 12:45:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-to-return-bool-for-isolate_movable_page-fix.patch removed from -mm tree
Message-Id: <20230220204505.D1F84C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-change-to-return-bool-for-isolate_movable_page-fix
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-isolate_movable_page-fix.patch

This patch was dropped because it was folded into mm-change-to-return-bool-for-isolate_movable_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-to-return-bool-for-isolate_movable_page-fix
Date: Thu Feb 16 02:41:42 PM PST 2023

remove unneeded comment, per Matthew

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory_hotplug.c~mm-change-to-return-bool-for-isolate_movable_page-fix
+++ a/mm/memory_hotplug.c
@@ -1672,7 +1672,7 @@ do_migrate_range(unsigned long start_pfn
 			isolated = isolate_lru_page(page);
 		else
 			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (isolated) { /* Success */
+		if (isolated) {
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-change-to-return-bool-for-isolate_movable_page.patch
include-linux-migrateh-remove-unneeded-externs.patch

