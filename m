Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF729C05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 22:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjA2WDv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 17:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjA2WDu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 17:03:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C14014211
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 14:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109C3B80D1A
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 22:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBC5C433D2;
        Sun, 29 Jan 2023 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675029823;
        bh=yCv68iwyjMall+puo8iX+w3hXWL7WKELKDzugEDBd0k=;
        h=Date:To:From:Subject:From;
        b=wRoAbyHZUhQvmIWtnNblTCWdKQUTau1c3xQv2OjeuRv21sADAdf0eBCm4Lq73wgwa
         6aHHYhcFZhl9n6wHTctF9giKjyHMgfBz3RJfEdZBUvFmQCb+odsVTdCy7FX7hqHlx8
         78ZILsYRVbFUD36sUtDkocrwpIZSMRZQi1ts81c8=
Date:   Sun, 29 Jan 2023 14:03:42 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-continue-to-migrate-for-non-hugetlb-folios.patch added to mm-unstable branch
Message-Id: <20230129220343.9CBC5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: continue to migrate for non-hugetlb folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-continue-to-migrate-for-non-hugetlb-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-continue-to-migrate-for-non-hugetlb-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/migrate: continue to migrate for non-hugetlb folios
Date: Sun, 29 Jan 2023 11:39:10 +0800

migrate_hugetlbs() returns -ENOMEM when there are not enough hugetlbs,
however there may be free non-hugetlb folios available, so continue to
migrate for non-hugetlb folios.

Nowdays the only negative return value of migrate_hugetlbs is -ENOMEM. 
Keep compatibility for coming negative return values instead of ignore
the return value.

Link: https://lkml.kernel.org/r/20230129033910.1327277-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-continue-to-migrate-for-non-hugetlb-folios
+++ a/mm/migrate.c
@@ -1939,7 +1939,8 @@ int migrate_pages(struct list_head *from
 
 	rc_gather = migrate_hugetlbs(from, get_new_page, put_new_page, private,
 				     mode, reason, &stats, &ret_folios);
-	if (rc_gather < 0)
+	/* There may be free non-hugetlb folios available, continue to migrate. */
+	if (rc_gather < 0 && rc_gather != -ENOMEM)
 		goto out;
 again:
 	nr_pages = 0;
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-migrate-continue-to-migrate-for-non-hugetlb-folios.patch

