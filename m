Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42705C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A97A64F35
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB0Cau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhB0Ca1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7808664F2D;
        Sat, 27 Feb 2021 02:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392994;
        bh=6Ls7GBlRAoYQLPnQuov5i1og97bYk7xQamqBIdYuFKk=;
        h=Date:From:To:Subject:From;
        b=KTwpuIVkcjT+juYiOKTCeupe+r7gB98qx20YbXu3kx5abSOUVg/PCpsM4dgH4Y2WE
         xr4q5c9AZspUy38ltByaK87lHlTEz4DRYH7Pe2jIUdbtNRsmyLBl6O+aEcmlHt8/Ro
         hXRsIYykUZ2E99NTahtMK55qBmwZ0wBBodZ4gspk=
Date:   Fri, 26 Feb 2021 18:29:54 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch removed from
 -mm tree
Message-ID: <20210227022954.YyuO3BG-I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix obsolete comment in __page_check_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: fix obsolete comment in __page_check_anon_rmap()

Commit 21333b2b66b8 ("ksm: no debug in page_dup_rmap()") has reverted
page_dup_rmap() to an inline atomic_inc of mapcount.  So page_dup_rmap()
does not call __page_check_anon_rmap() anymore.

Link: https://lkml.kernel.org/r/20210128110209.50857-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -1086,8 +1086,7 @@ static void __page_check_anon_rmap(struc
 	 * be set up correctly at this point.
 	 *
 	 * We have exclusion against page_add_anon_rmap because the caller
-	 * always holds the page locked, except if called from page_dup_rmap,
-	 * in which case the page is already known to be setup.
+	 * always holds the page locked.
 	 *
 	 * We have exclusion against page_add_new_anon_rmap because those pages
 	 * are initially only visible via the pagetables, and the pte is locked
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


