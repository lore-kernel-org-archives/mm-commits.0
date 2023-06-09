Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768F9C8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjFIX2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjFIX1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F753ABB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8902460D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F84C433EF;
        Fri,  9 Jun 2023 23:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353261;
        bh=c59QyQ6w/bLb/HeC1csBP0ezx6fV5a9ZTnvTV+S6Ico=;
        h=Date:To:From:Subject:From;
        b=RG+N/rcU2kXM0jIvCUYmnua8cdjXcde+yPTEnVqnt3jHwEeQIkkfLDM2nr7jj4znH
         84oShENJ6reFStYk/P+tdF3YoCLfuLx86uuZLXdB5wDd0fDTBWEH2GdZ//nsy4HrmQ
         1N+S05IswEEzN6hY6nbZKgX56cQE9BYm8l9lsqF8=
Date:   Fri, 09 Jun 2023 16:27:40 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-squash-page_is_consistent.patch removed from -mm tree
Message-Id: <20230609232740.E3F84C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: squash page_is_consistent()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-squash-page_is_consistent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: squash page_is_consistent()
Date: Tue, 16 May 2023 14:38:13 +0800

Squash the page_is_consistent() into bad_range() as there is only one
caller.

Link: https://lkml.kernel.org/r/20230516063821.121844-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-squash-page_is_consistent
+++ a/mm/page_alloc.c
@@ -517,13 +517,6 @@ static int page_outside_zone_boundaries(
 	return ret;
 }
 
-static int page_is_consistent(struct zone *zone, struct page *page)
-{
-	if (zone != page_zone(page))
-		return 0;
-
-	return 1;
-}
 /*
  * Temporary debugging check for pages not lying within a given zone.
  */
@@ -531,7 +524,7 @@ static int __maybe_unused bad_range(stru
 {
 	if (page_outside_zone_boundaries(zone, page))
 		return 1;
-	if (!page_is_consistent(zone, page))
+	if (zone != page_zone(page))
 		return 1;
 
 	return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


