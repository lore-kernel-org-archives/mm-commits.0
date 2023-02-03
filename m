Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD19C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBCGfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjBCGfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4B48B305
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B9D61D9D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E608BC4339B;
        Fri,  3 Feb 2023 06:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406129;
        bh=9HDemhD55hykCthjOHnLKBfmJxSBs3uSHHKwo4S0Pwc=;
        h=Date:To:From:Subject:From;
        b=uG+xVZYCvrVRGIDvadh3lWbuV36W6dqJxGhMPSFR5ODUP0Xx1qmR/N7HuofUp5i3V
         BQ3bp+DZF8yTfv8NZAh3xWNw+ny06uHtf0SjjhpTkivikNpwcdKDFOcfYUj5E3xqJt
         YVG9clV+iN0XU3rB49pdx0vacO/oSOGHPGKyCR4E=
Date:   Thu, 02 Feb 2023 22:35:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch removed from -mm tree
Message-Id: <20230203063528.E608BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: count the migration scanned pages events for proactive compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: count the migration scanned pages events for proactive compaction
Date: Tue, 10 Jan 2023 21:36:20 +0800

The proactive compaction will reuse per-node kcompactd threads, so we
should also count the KCOMPACTD_MIGRATE_SCANNED and KCOMPACTD_FREE_SCANNED
events for proactive compaction.

Link: https://lkml.kernel.org/r/b7f1ece1adc17defa47e3667b5f9fd61f496517a.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-count-the-migration-scanned-pages-events-for-proactive-compaction
+++ a/mm/compaction.c
@@ -2659,6 +2659,11 @@ static void proactive_compact_node(pg_da
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
+
+		count_compact_events(KCOMPACTD_MIGRATE_SCANNED,
+				     cc.total_migrate_scanned);
+		count_compact_events(KCOMPACTD_FREE_SCANNED,
+				     cc.total_free_scanned);
 	}
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


