Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB6EC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4585561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEHWsI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWsH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3A4613E8;
        Sat,  8 May 2021 22:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514025;
        bh=jOPCDKUYGf3W79kwKca3JDq4BG/WBJixdfpXP2lvefs=;
        h=Date:From:To:Subject:From;
        b=p7LPjiPmPJdMzyJ79izG6nO1AQskvjVY8mFBiQ2U4rFDD/rVImrC6v1L+8GyV+3O2
         6zOVzhg2kBTkVrJa8oVZAFQs2Ik1hJC+FdTkIr591L7t7vlIEp7F3/yTYDiL5E70SX
         X09WDhXfBjxuYd/b0zgEfkf5wmyy+x5pCnAWSZHQ=
Date:   Sat, 08 May 2021 15:47:05 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memoryc-use-helper-function-migration_entry_to_page.patch removed
 from -mm tree
Message-ID: <20210508224705.kX4XB7XC4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: use helper function migration_entry_to_page()
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-use-helper-function-migration_entry_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: use helper function migration_entry_to_page()

It's more recommended to use helper function migration_entry_to_page() to
get the page via migration entry.  We can also enjoy the PageLocked()
check there.

Link: https://lkml.kernel.org/r/20210318122722.13135-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: yuleixzhang <yulei.kernel@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-use-helper-function-migration_entry_to_page
+++ a/mm/huge_memory.c
@@ -1693,7 +1693,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
-			page = pfn_to_page(swp_offset(entry));
+			page = migration_entry_to_page(entry);
 			flush_needed = 0;
 		} else
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2101,7 +2101,7 @@ static void __split_huge_pmd_locked(stru
 		swp_entry_t entry;
 
 		entry = pmd_to_swp_entry(old_pmd);
-		page = pfn_to_page(swp_offset(entry));
+		page = migration_entry_to_page(entry);
 		write = is_write_migration_entry(entry);
 		young = false;
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


