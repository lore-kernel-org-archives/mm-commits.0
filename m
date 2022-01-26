Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F7BC5AC75
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 03:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiAZDPO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 22:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiAZDPO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 22:15:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C49C06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 19:15:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888CF61702
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 03:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D72C340E3;
        Wed, 26 Jan 2022 03:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643166913;
        bh=MQFcfFGhdNYraAWU5amK0Bd6SisHmIZUXCfhC0SMuAA=;
        h=Date:From:To:Subject:From;
        b=tc6cgAQlph8UcKrw/L7QoN8KpzEH0uaSv14L6rR6Hx6PooINe09OT+rnyyV369ui8
         IhKTFdtof+wDnfWz9m/bvoblZtlkSenc1FEB4OU9e/xrFOmroq3q7jX2iM55jabC0t
         gXBX1JXmw5d1L0LTQYREiw1HJHi3F4rJl41TwK8Q=
Date:   Tue, 25 Jan 2022 19:15:12 -0800
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, bot@kernelci.org, chenwandun@huawei.com,
        david@redhat.com, francesco.dolcini@toradex.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?revert-mm-page=5Fisolation-unset-migratetype-directly-for-?=
 =?US-ASCII?Q?non-buddy-page.patch?= added to -mm tree
Message-ID: <20220126031512.yNAjAFNbX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/page_isolation: unset migratetype directly for non Buddy page"
has been added to the -mm tree.  Its filename is
     revert-mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from chenwandun@huawei.com are

revert-mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

