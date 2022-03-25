Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D40C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344486AbiCYBeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357548AbiCYBdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CD6BF014
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA709B8272C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C80AC340EC;
        Fri, 25 Mar 2022 01:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171903;
        bh=vSrlPexRmMvkKv/IuNjeYBUniH0vyvBVfSeRkSHIuPU=;
        h=Date:To:From:Subject:From;
        b=z56Hx59I5DQiKUlLGPO36wXgnk2Jp13fef4/q34gYUHzHVXquG9o1RoSfbtU/Y2Pt
         qpQdLX54KJMFtf2zunQ6PDsNp9pvSJ5wSi3M4HiQVxkVes5SJm+fiu5bTkkX6zwyyA
         d9Hmzms3g2MPWAQJ3NHbbRGWjDA8KBKECkl1mEX0=
Date:   Thu, 24 Mar 2022 18:31:42 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch removed from -mm tree
Message-Id: <20220325013143.5C80AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev

Since commit 03e5ac2fc3bf ("mm: fix crash when using XFS on loopback"),
page_mapping() can handle the Slab pages.  So remove this unnecessary
PageSlab check and obsolete comment.

Link: https://lkml.kernel.org/r/20220218090118.1105-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev
+++ a/mm/memory-failure.c
@@ -130,12 +130,6 @@ static int hwpoison_filter_dev(struct pa
 	    hwpoison_filter_dev_minor == ~0U)
 		return 0;
 
-	/*
-	 * page_mapping() does not accept slab pages.
-	 */
-	if (PageSlab(p))
-		return -EINVAL;
-
 	mapping = page_mapping(p);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

