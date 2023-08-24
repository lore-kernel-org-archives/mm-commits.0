Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F702C3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbjHXXKU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244066AbjHXXKT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BDDE58
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 316A4639D8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C3BC433C8;
        Thu, 24 Aug 2023 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918616;
        bh=uhrAjgGSODrpR+X3KI8u8AyNC/cFuwVZJkTJdxd4G/k=;
        h=Date:To:From:Subject:From;
        b=KUY7JDLQ3tZwnEg5E6SEkvJlbALc00srYiOp3AfJtPWGouIZ9xl9LwkVg1jzY0xWq
         fmq7OK2iHe4Yaw/8MisvdBJL1hRStGa3+C/GNjdWRaScOFilpdnp4Pl/qSdcv3uDlQ
         OOEIaEBX3aGrLO1wqLscnVWi/vckP8RN4V0b1/hk=
Date:   Thu, 24 Aug 2023 16:10:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        michal.simek@amd.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] microblaze-implement-the-new-page-table-range-api-fix.patch removed from -mm tree
Message-Id: <20230824231016.88C3BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: microblaze: mark flush_dcache_folio() inline
has been removed from the -mm tree.  Its filename was
     microblaze-implement-the-new-page-table-range-api-fix.patch

This patch was dropped because it was folded into microblaze-implement-the-new-page-table-range-api.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: microblaze: mark flush_dcache_folio() inline
Date: Thu, 10 Aug 2023 16:19:26 +0200

The newly added flush_dcache_folio() causes a harmless warning that turns
into a build failure with CONFIG_WERROR:

arch/microblaze/include/asm/cacheflush.h:77:13: error: 'flush_dcache_folio' defined but not used [-Werror=unused-function]

Mark it as inline to avoid this.

Link: https://lkml.kernel.org/r/20230810141947.1236730-9-arnd@kernel.org
Fixes: 1330c94f53996 ("microblaze: implement the new page table range API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/cacheflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/microblaze/include/asm/cacheflush.h~microblaze-implement-the-new-page-table-range-api-fix
+++ a/arch/microblaze/include/asm/cacheflush.h
@@ -74,7 +74,7 @@ do { \
 	flush_dcache_range((unsigned) (addr), (unsigned) (addr) + PAGE_SIZE); \
 } while (0);
 
-static void flush_dcache_folio(struct folio *folio)
+static inline void flush_dcache_folio(struct folio *folio)
 {
 	unsigned long addr = folio_pfn(folio) << PAGE_SHIFT;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

microblaze-implement-the-new-page-table-range-api.patch

