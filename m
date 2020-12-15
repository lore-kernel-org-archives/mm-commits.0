Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F92C352A2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8287B22EBE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgLOX7a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727463AbgLOXZF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:05 -0500
Date:   Tue, 15 Dec 2020 15:22:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074534;
        bh=GCTh4gBzt6GIK9XZ9zjIMrNWUICBCB5H1SLwz6IIMFI=;
        h=From:To:Subject:From;
        b=idklpStPj5VyqesexX/DbJzKOpR1LhcGHdOYoVKLhA1iW/h95P9B8rVP5omzPVEcE
         TwWCqAAlNMxwHnJyB1l+wtiTcglbnG97rIEMTIuTtkb69b/w6gN5BbX+0BB4G9L8oR
         St6RrzVGJZUnqK4im+7Jf47/MKlzVNiYJVkcD+Mk=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  [merged] mmhwpoison-drop-unneeded-pcplist-draining.patch
 removed from -mm tree
Message-ID: <20201215232214.UBsZipADu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drop unneeded pcplist draining
has been removed from the -mm tree.  Its filename was
     mmhwpoison-drop-unneeded-pcplist-draining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: drop unneeded pcplist draining

memory_failure and soft_offline_path paths now drain pcplists by calling
get_hwpoison_page.

memory_failure flags the page as HWPoison before, so that page cannot
longer go into a pcplist, and soft_offline_page only flags a page as
HWPoison if 1) we took the page off a buddy freelist 2) the page was
in-use and we migrated it 3) was a clean pagecache.

Because of that, a page cannot longer be poisoned and be in a pcplist.

Link: https://lkml.kernel.org/r/20201013144447.6706-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining
+++ a/mm/madvise.c
@@ -877,7 +877,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct zone *zone;
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -922,10 +921,6 @@ static int madvise_inject_error(int beha
 			return ret;
 	}
 
-	/* Ensure that all poisoned pages are removed from per-cpu lists */
-	for_each_populated_zone(zone)
-		drain_all_pages(zone);
-
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from osalvador@suse.de are


