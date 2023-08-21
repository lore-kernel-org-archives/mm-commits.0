Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267C3EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjHUUZv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjHUUZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B43FE3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B86634FC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B14C433C8;
        Mon, 21 Aug 2023 20:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692649546;
        bh=wVgD+t5wCPCIaFwuJEelWbjvQeLuWgttjdjbTwy8UGE=;
        h=Date:To:From:Subject:From;
        b=YiogRCclXSdkOlmKjUjGyTJykw6m3bp22QECqUmybQu6fnUTdyBqnWQSuCq/MIrSf
         REoC4i/kVYvQuUjJ45hWGeNTOSm0ZWhV28uGaWqLHrse5aeBweXyLQn8pAyofc6jq9
         eAMyrJT0GO9QDSyOnhnzFX3sDjGhBiIWSFFoznhw=
Date:   Mon, 21 Aug 2023 13:25:45 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kill-frontswap-fix.patch removed from -mm tree
Message-Id: <20230821202546.19B14C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kill frontswap fix
has been removed from the -mm tree.  Its filename was
     mm-kill-frontswap-fix.patch

This patch was dropped because it was folded into mm-kill-frontswap.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: kill frontswap fix
Date: Wed, 19 Jul 2023 10:21:49 -0400

remove obsolete comment, per Yosry

Link: https://lkml.kernel.org/r/20230719142832.GA932528@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-kill-frontswap-fix
+++ a/mm/zswap.c
@@ -1425,7 +1425,6 @@ bool zswap_load(struct page *page)
 	spin_lock(&tree->lock);
 	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
-		/* entry was written back */
 		spin_unlock(&tree->lock);
 		return false;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch

