Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E27C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbjHKXAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D333598
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB6B166B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB8DC433C7;
        Fri, 11 Aug 2023 22:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794776;
        bh=qyQ+676pMb7zRHWYpiezDdDXGF5BQ3Uvrl6NEDPLoE8=;
        h=Date:To:From:Subject:From;
        b=NWOZqz/V+NwdvEEv2ol8k6Byoc1IqB9CEs+5Vp63pjLNPMZEEc30H2I6Fut9+LzDV
         Sax49hAuLdPQPtIDzRMTgb3ECnhPz/S7dmheT6zfOFgS+IIID+uEfaNs8oY1fFM6Zw
         L0t8ZzUViz8xXUXhdCjJdLnCR+FhYsQvwWiGNhlg=
Date:   Fri, 11 Aug 2023 15:59:35 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-use-the-correct-type-of-list-for-free-pages.patch removed from -mm tree
Message-Id: <20230811225936.4BB8DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: use the correct type of list for free pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-the-correct-type-of-list-for-free-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: use the correct type of list for free pages
Date: Fri, 7 Jul 2023 16:51:46 +0800

Use the page->buddy_list instead of page->lru to clarify the correct type
of list for free pages.

Link: https://lkml.kernel.org/r/b21cd8e2e32b9a1d9bc9e43ebf8acaf35e87f8df.1688715750.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-the-correct-type-of-list-for-free-pages
+++ a/mm/compaction.c
@@ -1500,7 +1500,7 @@ static void fast_isolate_freepages(struc
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry_reverse(freepage, freelist, lru) {
+		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
 			unsigned long pfn;
 
 			order_scanned++;
@@ -1883,7 +1883,7 @@ static unsigned long fast_find_migratebl
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry(freepage, freelist, lru) {
+		list_for_each_entry(freepage, freelist, buddy_list) {
 			unsigned long free_pfn;
 
 			if (nr_scanned++ >= limit) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


