Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDAEC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiLLCQy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiLLCOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E5EBF51
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDFE6B80B3C
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E4C433EF;
        Mon, 12 Dec 2022 02:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811280;
        bh=ZF7tUh0O+4I5KJszq6XBPFFmYvPwTwG5E7giAdBCnAA=;
        h=Date:To:From:Subject:From;
        b=mLL5Z1rOXu7XElzQEZFaiBYIU79ssEPYzwUrv6SwuDMlScj7fkBLhx3UqkY7NkKdO
         sz2qoABMWPNkuVmRXUCzuJ0s46lMRCknYIj01o7c+TC4YKw3hzV00jzQBMqdnzSBvJ
         5rrXAgauT9OrTCJZGAJEWJkObn4KwurbHrpnmA54=
Date:   Sun, 11 Dec 2022 18:14:39 -0800
To:     mm-commits@vger.kernel.org, wonder_rock@126.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-update-comments-in-__free_pages_ok.patch removed from -mm tree
Message-Id: <20221212021440.836E4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: update comments in __free_pages_ok()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-update-comments-in-__free_pages_ok.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deyan Wang <wonder_rock@126.com>
Subject: mm/page_alloc: update comments in __free_pages_ok()
Date: Thu, 1 Dec 2022 21:50:45 +0800

Add a comment to explain why we call get_pfnblock_migratetype() twice in
__free_pages_ok().

Link: https://lkml.kernel.org/r/20221201135045.31663-1-wonder_rock@126.com
Signed-off-by: Deyan Wang <wonder_rock@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-update-comments-in-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -1702,6 +1702,11 @@ static void __free_pages_ok(struct page
 	if (!free_pages_prepare(page, order, true, fpi_flags))
 		return;
 
+	/*
+	 * Calling get_pfnblock_migratetype() without spin_lock_irqsave() here
+	 * is used to avoid calling get_pfnblock_migratetype() under the lock.
+	 * This will reduce the lock holding time.
+	 */
 	migratetype = get_pfnblock_migratetype(page, pfn);
 
 	spin_lock_irqsave(&zone->lock, flags);
_

Patches currently in -mm which might be from wonder_rock@126.com are


