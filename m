Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97395C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbiHXRsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiHXRsh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:48:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6C782879
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C853360C90
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD49C433D6;
        Wed, 24 Aug 2022 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661363315;
        bh=PcHWa86mMCl8F2vIK4o/c0abOWl1sdb0P/OobyyH2uE=;
        h=Date:To:From:Subject:From;
        b=rdEy38boPJbuMq48+pnpFXq4Dga3JVWXE5+GZgkgeAK3a0vBcmBXJVZ2Mm7t9pPRG
         LtYk7Onb3gkXkKHLjEjE/DVm3onoYFyVqytUg2jrSB/vBsXWkHRl0NF6kXajxv6pG7
         Jl7rWbmGF9neMmXRGTBAHkYN9COkXY1GyVSo9z04=
Date:   Wed, 24 Aug 2022 10:48:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, osalvador@suse.de,
        mike.kravetz@oracle.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page.patch removed from -mm tree
Message-Id: <20220824174835.1CD49C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page
has been removed from the -mm tree.  Its filename was
     bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page
Date: Thu, 18 Aug 2022 21:21:04 +0800

The vmemmap pages is marked by kmemleak when allocated from memblock. 
Remove it from kmemleak when free the page.  Otherwise, when we reuse the
page, kmemleak may report such an error and then stop working.

 kmemleak: Cannot insert 0xffff98fb6eab3d40 into the object search tree (overlaps existing)
 kmemleak: Kernel memory leak detector disabled
 kmemleak: Object 0xffff98fb6be00000 (size 335544320):
 kmemleak:   comm "swapper", pid 0, jiffies 4294892296
 kmemleak:   min_count = 0
 kmemleak:   count = 0
 kmemleak:   flags = 0x1
 kmemleak:   checksum = 0
 kmemleak:   backtrace:

Link: https://lkml.kernel.org/r/20220818132104.2144770-1-liushixin2@huawei.com
Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/bootmem_info.h~bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page
+++ a/include/linux/bootmem_info.h
@@ -3,6 +3,7 @@
 #define __LINUX_BOOTMEM_INFO_H
 
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 
 /*
  * Types for free bootmem stored in page->lru.next. These have to be in
@@ -38,9 +39,10 @@ static inline void free_bootmem_page(str
 	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
 
-	if (magic == SECTION_INFO || magic == MIX_SECTION_INFO)
+	if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
+		kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 		put_page_bootmem(page);
-	else
+	} else
 		VM_BUG_ON_PAGE(1, page);
 }
 #else
_

Patches currently in -mm which might be from liushixin2@huawei.com are

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

