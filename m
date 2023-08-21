Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02553EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjHUUk7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjHUUk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD372E60
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348FB631F2
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D265C433C7;
        Mon, 21 Aug 2023 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650397;
        bh=HAoPRReJYBk+sEudrvUv3MaCJkWxj7My3LMyWgr8J2Q=;
        h=Date:To:From:Subject:From;
        b=pIVIf+/zDmN9U/QfbpjVDKcMCPVv80XjXnWWV/HHGFzh0g+wrprQWgaIQjDJ7RY4U
         WNsMmirHIzfOz+/YcZzvBS/4JhalDXlkUhjn0H5wvkCX2CIkXuNwN4mACS90RwOTvA
         GxoMx4bWCVrbJzmez5vRYoHCrp24SZDjich48PdM=
Date:   Mon, 21 Aug 2023 13:39:57 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unneeded-variable-base.patch removed from -mm tree
Message-Id: <20230821203957.8D265C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unneeded variable base
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unneeded-variable-base.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: remove unneeded variable base
Date: Thu, 3 Aug 2023 19:49:34 +0800

Since commit 5d0a661d808f ("mm/page_alloc: use only one PCP list for
THP-sized allocations"), local variable base is just as same as order.  So
remove it.  No functional change intended.

Link: https://lkml.kernel.org/r/20230803114934.693989-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unneeded-variable-base
+++ a/mm/page_alloc.c
@@ -538,8 +538,6 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
-	int base = order;
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != pageblock_order);
@@ -549,7 +547,7 @@ static inline unsigned int order_to_pind
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 #endif
 
-	return (MIGRATE_PCPTYPES * base) + migratetype;
+	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
 
 static inline int pindex_to_order(unsigned int pindex)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

