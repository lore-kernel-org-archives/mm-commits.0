Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2F8EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 22:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjGBWzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBWzQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 18:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292AD1B9
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 15:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F9360CE8
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 22:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAD4C433C8;
        Sun,  2 Jul 2023 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688338514;
        bh=dq1YiKic1TceqyTX+IL9ohh3mIma4S56OKsg2YUE/a8=;
        h=Date:To:From:Subject:From;
        b=rkIAlW1BNh/f+Jg4XajfJHzh8klWAiqZTiBZLW/zTuqgRHih+zTwz+hxU4CHUpfLv
         rqKnnUVdVPDeNDAkUaw7MVvkFRWJKEgl20MxsBgjNP4ZDyvxhL4B/YxkhZGem+xDK6
         Hc41YdmnFfGdsv/YUXXqKTTh4smi5bMK2f79tamo=
Date:   Sun, 02 Jul 2023 15:55:13 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch added to mm-unstable branch
Message-Id: <20230702225513.EBAD4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: remove unneeded page state check in shake_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded page state check in shake_page()
Date: Wed, 28 Jun 2023 09:49:29 +0800

Remove unneeded PageLRU(p) and is_free_buddy_page(p) check as slab caches
are not shrunk now.  This check can be added back when a lightweight range
based shrinker is available.

Link: https://lkml.kernel.org/r/20230628014929.3441386-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-page-state-check-in-shake_page
+++ a/mm/memory-failure.c
@@ -363,17 +363,14 @@ void shake_page(struct page *p)
 {
 	if (PageHuge(p))
 		return;
-
-	if (!PageSlab(p)) {
-		lru_add_drain_all();
-		if (PageLRU(p) || is_free_buddy_page(p))
-			return;
-	}
-
 	/*
 	 * TODO: Could shrink slab caches here if a lightweight range-based
 	 * shrinker will be available.
 	 */
+	if (PageSlab(p))
+		return;
+
+	lru_add_drain_all();
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch

