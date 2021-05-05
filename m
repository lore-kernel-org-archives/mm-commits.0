Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06830C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC64C61404
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhEEBfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhEEBfG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 497E261401;
        Wed,  5 May 2021 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178449;
        bh=wc1M8MZVW96SWiWQQdhFVZJ00j8B2025UXfgNBlxvq4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IUKObkr4qLJ/AAO3IkGaZYz9ylS2asfNjNaBalLdOi3XgjNv0sKQbm6n3CLpPSRGa
         KoK8hGIx0dNh7cGQJ0UcVCg4aIRs3ke6vt0JWRwDbCNUjJXdQRXp8NrImuBobsQz5e
         ReVtYZyx0Rxi7xJc3+TlpVoqzXsRB0F/HIb/g++o=
Date:   Tue, 04 May 2021 18:34:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [patch 027/143] mm/huge_memory.c: use helper function
 migration_entry_to_page()
Message-ID: <20210505013408.q1CoDJJvf%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
