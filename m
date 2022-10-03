Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E66C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiJCVPv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiJCVOJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F1C1181A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F304611E0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88576C433B5;
        Mon,  3 Oct 2022 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831379;
        bh=9hh/aqxTZwMK5ZW/oK1ibv8m41yTMo/205GRJSjGKzQ=;
        h=Date:To:From:Subject:From;
        b=FdOLZEhPbT5fI4xYRUdrhqmgDfFXWRr7WGv27nvHDQ82nwaUK4K3IofmWNuRVSeq9
         mZQK+mPV/N6LeJO+ylqakG34kL4s6gtQOEinVHq//Jsai6BesFvgvTenbr3TIgXMUn
         00hV7ibXZMD29LDbw0ljUwaYskwMaQBp09BYF2BE=
Date:   Mon, 03 Oct 2022 14:09:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-helper-macro-sz_1km.patch removed from -mm tree
Message-Id: <20221003210939.88576C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use helper macro SZ_1{K,M}
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-helper-macro-sz_1km.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: use helper macro SZ_1{K,M}
Date: Fri, 16 Sep 2022 15:22:53 +0800

Use helper macro SZ_1K and SZ_1M to do the size conversion.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220916072257.9639-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-helper-macro-sz_1km
+++ a/mm/page_alloc.c
@@ -7056,7 +7056,7 @@ static int zone_batchsize(struct zone *z
 	 * size is striking a balance between allocation latency
 	 * and zone lock contention.
 	 */
-	batch = min(zone_managed_pages(zone) >> 10, (1024 * 1024) / PAGE_SIZE);
+	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
 	batch /= 4;		/* We effectively *= 4 below */
 	if (batch < 1)
 		batch = 1;
@@ -8531,8 +8531,8 @@ void __init mem_init_print_info(void)
 #endif
 		")\n",
 		K(nr_free_pages()), K(physpages),
-		codesize >> 10, datasize >> 10, rosize >> 10,
-		(init_data_size + init_code_size) >> 10, bss_size >> 10,
+		codesize / SZ_1K, datasize / SZ_1K, rosize / SZ_1K,
+		(init_data_size + init_code_size) / SZ_1K, bss_size / SZ_1K,
 		K(physpages - totalram_pages() - totalcma_pages),
 		K(totalcma_pages)
 #ifdef	CONFIG_HIGHMEM
@@ -9057,8 +9057,8 @@ void *__init alloc_large_system_hash(con
 		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
-		if (PAGE_SHIFT < 20)
-			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
+		if (PAGE_SIZE < SZ_1M)
+			numentries = round_up(numentries, SZ_1M / PAGE_SIZE);
 
 #if __BITS_PER_LONG > 32
 		if (!high_limit) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


