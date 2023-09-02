Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F66FC83F33
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjIBWSH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbjIBWSF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:18:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EECCED
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F2DB808C7
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07525C433C7;
        Sat,  2 Sep 2023 22:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693080;
        bh=pHyHVIj42jPa9swnmspGv2vPhbsA7BGmQnJxbepJNYI=;
        h=Date:To:From:Subject:From;
        b=JkjcK2FZsxtzHpMOHG7K8GTPj11fjuchgjxHgRukBEzOUHimw1bvSKiT4aFmDhXtN
         zL1bDLSFdgR5XsQo8ThZOzDs8QQo/TQldAr2ZKGnzjcy5BlAhUCVa6wmk9aC7OEdYc
         6sbqJ0LRqT1TeiX7Ur8M7+ghqaGvhCLkOCfkdRIY=
Date:   Sat, 02 Sep 2023 15:17:59 -0700
To:     mm-commits@vger.kernel.org, xieyisheng1@huawei.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch removed from -mm tree
Message-Id: <20230902221800.07525C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: move up cond_resched() call in page scanning loop
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: move up cond_resched() call in page scanning loop
Date: Fri, 25 Aug 2023 12:49:47 -0400

Commit bde5f6bc68db ("kmemleak: add scheduling point to kmemleak_scan()")
added a cond_resched() call to the struct page scanning loop to prevent
soft lockup from happening.  However, soft lockup can still happen in that
loop in some corner cases when the pages that satisfy the "!(pfn & 63)"
check are skipped for some reasons.

Fix this corner case by moving up the cond_resched() check so that it will
be called every 64 pages unconditionally.

Link: https://lkml.kernel.org/r/20230825164947.1317981-1-longman@redhat.com
Fixes: bde5f6bc68db ("kmemleak: add scheduling point to kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop
+++ a/mm/kmemleak.c
@@ -1584,6 +1584,9 @@ static void kmemleak_scan(void)
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
 
+			if (!(pfn & 63))
+				cond_resched();
+
 			if (!page)
 				continue;
 
@@ -1594,8 +1597,6 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn & 63))
-				cond_resched();
 		}
 	}
 	put_online_mems();
_

Patches currently in -mm which might be from longman@redhat.com are


