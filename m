Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B0FC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 106E92247F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgLODQl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:11:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001863;
        bh=L6Jzxo1YgPIFSIb6EAmKAWzbBNYVLYL38uAYjEcn35A=;
        h=From:To:Subject:In-Reply-To:From;
        b=ie/Y2mcaQWl4zrd2oEBQYbLfkYz08JSuvY0oPmaXGsu68wTUsEx9/ganStqq+m49u
         IegzI8XcP62gnWzuXrAorLtGWJeE15p2UAlydKiOTCdmPjiS9vWlgdyWuet6MrsDA+
         dxJAB/zTAUk10AACy0AebDuBxADuw2xcF7jZ0ljs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 130/200] include/linux/page-flags.h: remove unused
 __[Set|Clear]PagePrivate
Message-ID: <20201215031102.yFuSA6mb-%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
