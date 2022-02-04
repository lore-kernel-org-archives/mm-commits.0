Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302A9C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 17:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377189AbiBDR4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiBDR4o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2022 12:56:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11650C061714
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 09:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2028B83874
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 17:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5A8C340F3;
        Fri,  4 Feb 2022 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643997401;
        bh=ljC+ZB7/P+JNIOZfeDuwZx/G/aLrfvXi55fo2JuPMkc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=iVFRSLVS4zTx/ESaCCgL/qi5VM47ASBWcx6WB5A+9A57VSRnCRlZ+a/Uatm6HXK13
         PID+hD6Ad9F6nSQxr1401nbqkAK1ukGa8EzDM1Ojo915tAXuCqK2peTgQiZuYm+iyv
         GUs+gDPdnDihqJTN/YmknJxQxf9cHU0Cei2OI/2w=
Received: by hp1 (sSMTP sendmail emulation); Fri, 04 Feb 2022 09:56:39 -0800
Date:   Fri, 04 Feb 2022 09:56:39 -0800
To:     vbabka@suse.cz, linux@roeck-us.net, francesco.dolcini@toradex.com,
        david@redhat.com, bot@kernelci.org, aisheng.dong@nxp.com,
        chenwandun@huawei.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 01/10] Revert "mm/page_isolation: unset migratetype directly for non Buddy page"
Message-Id: <20220204175639.DD5A8C340F3@smtp.kernel.org>
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
