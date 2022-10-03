Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9CFC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJCVO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJCVMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFB15245B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70306B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C58C433C1;
        Mon,  3 Oct 2022 21:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831263;
        bh=4pqaO4D4XAhkXAgHqzZeTXmwtCkVPaBKotKdHUCtk+k=;
        h=Date:To:From:Subject:From;
        b=t1ZMwyspvG+N5YNnqxvtUPWbP3vU3Lph//WDt4Tw59TDBmBo3MLDAEreI29bznSJQ
         PyXPXqM0GQ4BImmCfAfPjNYdD1CO2oPfZtFnyJeRMog8vm5Wn4+LINl/DNVVjSI0Ug
         940aT+xl4X/k4lxucX9OQY3SvAfTBPfnf08bwlnU=
Date:   Mon, 03 Oct 2022 14:07:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch removed from -mm tree
Message-Id: <20221003210743.21C58C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc.c: document bulkfree_pcp_prepare() return value
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: document bulkfree_pcp_prepare() return value
Date: Tue Sep 13 03:30:38 PM PDT 2022

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_allocc-document-bulkfree_pcp_prepare-return-value
+++ a/mm/page_alloc.c
@@ -1501,6 +1501,7 @@ static bool free_pcp_prepare(struct page
 	return free_pages_prepare(page, order, true, FPI_NONE);
 }
 
+/* return true if this page has an inappropriate state */
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

