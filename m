Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B809C3526F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA4222CF7
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgLOX7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbgLOXXb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:31 -0500
Date:   Tue, 15 Dec 2020 15:21:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074509;
        bh=PRFgPLwbtdyUgMW5PmyYXh323HpMD+VwoeO2rvFRr5Y=;
        h=From:To:Subject:From;
        b=uaItZqtW14RNzIBu31HTIHIPexJRFTuj4Pw3PfadsxGpbwZ0q/5T56fkYRHD5kyS0
         TgYzmlS4rOnM3mZi7PCiqr7QOAe8dJbSx/zdPDNrQN/zvbNyEAttnM+vHYn6PBUOTr
         HRGDQ33YiaLqcbuSSiKY7rO07t7q2F9sZqTfyTJM=
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged] page-flags-remove-unused-__pageprivate.patch
 removed from -mm tree
Message-ID: <20201215232149.HOmGnBGD7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags.h: remove unused __[Set|Clear]PagePrivate
has been removed from the -mm tree.  Its filename was
     page-flags-remove-unused-__pageprivate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: include/linux/page-flags.h: remove unused __[Set|Clear]PagePrivate

They are not used anymore.

Link: https://lkml.kernel.org/r/20201009135914.64826-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~page-flags-remove-unused-__pageprivate
+++ a/include/linux/page-flags.h
@@ -363,8 +363,7 @@ PAGEFLAG(SwapBacked, swapbacked, PF_NO_T
  * for its own purposes.
  * - PG_private and PG_private_2 cause releasepage() and co to be invoked
  */
-PAGEFLAG(Private, private, PF_ANY) __SETPAGEFLAG(Private, private, PF_ANY)
-	__CLEARPAGEFLAG(Private, private, PF_ANY)
+PAGEFLAG(Private, private, PF_ANY)
 PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
 PAGEFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
 	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


