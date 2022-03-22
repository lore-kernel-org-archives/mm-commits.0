Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063ABC43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbiCVVqY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiCVVqS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0CC5F8F0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D65B81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D0FC340EC;
        Tue, 22 Mar 2022 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985473;
        bh=ufU2dBdaV6hQjERzZES5W1c91mKRaDKZ44CKgjOy4ek=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=b8QpBTuK/8KnsZ+HMy9OLdYQqvzvU5OHR7SjRMaRvtgAZSKUswv2+ZN6bqxnMosvs
         /UDyUQgbB+w58as6oI5yGw/B4LkHWDY1IxL5XKRLeh8AryWPPp5sZdoSNmH4QeIlBl
         sDCpLR0yUWRpnR4gAwRZthr4gaNqyeHtip/Z/IGk=
Date:   Tue, 22 Mar 2022 14:44:33 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 119/227] mm/memory-failure.c: remove unnecessary PageTransTail check
Message-Id: <20220322214433.A3D0FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: remove unnecessary PageTransTail check

When we reach here, we're guaranteed to have non-compound page as thp is
already splited.  Remove this unnecessary PageTransTail check.

Link: https://lkml.kernel.org/r/20220218090118.1105-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-unnecessary-pagetranstail-check
+++ a/mm/memory-failure.c
@@ -1844,7 +1844,7 @@ try_again:
 	 * page_lock. We need wait writeback completion for this page or it
 	 * may trigger vfs BUG while evict inode.
 	 */
-	if (!PageTransTail(p) && !PageLRU(p) && !PageWriteback(p))
+	if (!PageLRU(p) && !PageWriteback(p))
 		goto identify_page_state;
 
 	/*
_
