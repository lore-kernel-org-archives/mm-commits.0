Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB3DC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 04:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbiBDEtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBDEtL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 23:49:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A68EC061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 20:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B8DB61AAC
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 04:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B976C004E1;
        Fri,  4 Feb 2022 04:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950148;
        bh=ljC+ZB7/P+JNIOZfeDuwZx/G/aLrfvXi55fo2JuPMkc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=16uofj9/66KjMZ6UkbUWHKdubwUpkyJSMTpx/nyhq2WX3yc5iQ8exyc8z82KCehIB
         yu7wi8N1JvXRFaaIpg82tWqFYejKbNKA9qSgpP9xCjRP5euYGjM/0gDf43npfQIr8j
         lGwOZ3SOI0JDxSZUI/eDobIsgeC/DngSMug7eUcE=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:06 -0800
Date:   Thu, 03 Feb 2022 20:49:06 -0800
To:     vbabka@suse.cz, linux@roeck-us.net, francesco.dolcini@toradex.com,
        david@redhat.com, bot@kernelci.org, aisheng.dong@nxp.com,
        chenwandun@huawei.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 01/10] Revert "mm/page_isolation: unset migratetype directly for non Buddy page"
Message-Id: <20220204044907.2B976C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>
Subject: Revert "mm/page_isolation: unset migratetype directly for non Buddy page"

This reverts commit 721fb891ad0b3956d5c168b2931e3e5e4fb7ca40.

commit 721fb891ad0b ("mm/page_isolation: unset migratetype directly for
non Buddy page") will result memory that should in buddy disappear by
mistake.  move_freepages_block move all pages in pageblock instead of
pages indicated by input parameter, so if input pages is not in buddy but
other pages in pageblock is in buddy, it will result in page out of
control.

Link: https://lkml.kernel.org/r/20220126024436.13921-1-chenwandun@huawei.com
Fixes: 721fb891ad0b ("mm/page_isolation: unset migratetype directly for non Buddy page")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Dong Aisheng <aisheng.dong@nxp.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~revert-mm-page_isolation-unset-migratetype-directly-for-non-buddy-page
+++ a/mm/page_isolation.c
@@ -115,7 +115,7 @@ static void unset_migratetype_isolate(st
 	 * onlining - just onlined memory won't immediately be considered for
 	 * allocation.
 	 */
-	if (!isolated_page && PageBuddy(page)) {
+	if (!isolated_page) {
 		nr_pages = move_freepages_block(zone, page, migratetype, NULL);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
_
