Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E410C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiCVVlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiCVVlW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BC65E766
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 334C1608CC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE1AC340EE;
        Tue, 22 Mar 2022 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985193;
        bh=8VA4dRateZukIxcuU24dYBOu+ngWksQajNF7aIpezC4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=J8wiKzZ+B9gGFOqH3UcgpGnjCYk1SLA7vLgYLhLLI5C/49Uyu+gJt5MDu547i2x5x
         Hl9oFk9678TZXubc2BxJclUZS7g4K2YtSv0a13w4ip1CnNlPRK4MhB39/TE9A1IDcI
         2cCQSP8ijvJlEVF+c1rFypSKc9QIV5tGv0YQPS5Q=
Date:   Tue, 22 Mar 2022 14:39:52 -0700
To:     libang.linuxer@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 027/227] mm/swap: fix confusing comment in folio_mark_accessed
Message-Id: <20220322213953.8DE1AC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/swap: fix confusing comment in folio_mark_accessed

For unevictable pages, we don't need mark them.

Link: https://lkml.kernel.org/r/20220311141519.59948-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-folio_mark_accessed
+++ a/mm/swap.c
@@ -425,7 +425,7 @@ void folio_mark_accessed(struct folio *f
 		/*
 		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
 		 * this list is never rotated or maintained, so marking an
-		 * evictable page accessed has no effect.
+		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
 		/*
_
