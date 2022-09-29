Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE670C07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiI2EFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiI2EFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:05:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6F4C88B9
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 02B2DCE1F7B
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EDAC433D7;
        Thu, 29 Sep 2022 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424347;
        bh=39s5jqlZZcJ2CY0jO6Xfy54mFNIfyaw6YE04rmGojws=;
        h=Date:To:From:Subject:From;
        b=YCqnQliEak2zgLwHr66Pa4lMhyIyuKRrchSY9QmXnnbk6WRiwUsu8zMT1M/UAQMkq
         Qu2L1fxb+tDaHOYtiHKEn7fGzd0KTyXOnupa7ZWk3gacnb/njhKQ6eNUI6On7GsusB
         BHDbkAWp9+W4YMguFvm+/zjL43ZMYNHPv1i/NRfs=
Date:   Wed, 28 Sep 2022 21:05:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch removed from -mm tree
Message-Id: <20220929040546.C7EDAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch

This patch was dropped because it was folded into mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix
Date: Tue Sep 13 03:37:49 PM PDT 2022

don't use bool as int

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix
+++ a/mm/page_alloc.c
@@ -1441,8 +1441,8 @@ static __always_inline bool free_pages_p
 		page->mapping = NULL;
 	if (memcg_kmem_enabled() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
-	if (check_free)
-		bad += free_page_is_bad(page);
+	if (check_free && free_page_is_bad(page))
+		bad++;
 	if (bad)
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

