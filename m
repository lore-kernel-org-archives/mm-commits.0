Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49F0C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357370AbiCYBdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357367AbiCYBcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9476847AD3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26BA661929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77299C340ED;
        Fri, 25 Mar 2022 01:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171851;
        bh=1bWm8fcduBlJEwedGXU5vDywMcylaat+Trrvd04xC7s=;
        h=Date:To:From:Subject:From;
        b=mSBLCapiagwOEA6fsnFOx3Mz4Ri6orGnrx5iun5vMybN5+Fu15MYyzx6VyNxfAwvE
         F7Dy+K0uEG6/66y+IYlBRcGemd6mZSO8b58rgvdG733kfsBxUAi21QN12ZBPQklVCF
         eOjXLu9MIPe5zSSnrCYIy7xGFNTVNKITgCaBA8H0=
Date:   Thu, 24 Mar 2022 18:30:50 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch removed from -mm tree
Message-Id: <20220325013051.77299C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix missing cache flush for all tail pages of compound page
has been removed from the -mm tree.  Its filename was
     mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: fix missing cache flush for all tail pages of compound page

The D-cache maintenance inside move_to_new_page() only consider one page,
there is still D-cache maintenance issue for tail pages of compound page
(e.g.  THP or HugeTLB).

THP migration is only enabled on x86_64, ARM64 and powerpc, while powerpc
and arm64 need to maintain the consistency between I-Cache and D-Cache,
which depends on flush_dcache_page() to maintain the consistency between
I-Cache and D-Cache.

But there is no issues on arm64 and powerpc since they already considers
the compound page cache flushing in their icache flush function.  HugeTLB
migration is enabled on arm, arm64, mips, parisc, powerpc, riscv, s390 and
sh, while arm has handled the compound page cache flush in
flush_dcache_page(), but most others do not.

In theory, the issue exists on many architectures.  Fix this by not using
flush_dcache_folio() since it is not backportable.

Link: https://lkml.kernel.org/r/20220210123058.79206-3-songmuchun@bytedance.com
Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page
+++ a/mm/migrate.c
@@ -916,9 +916,12 @@ static int move_to_new_page(struct page
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_page(newpage);
+		if (likely(!is_zone_device_page(newpage))) {
+			int i, nr = compound_nr(newpage);
 
+			for (i = 0; i < nr; i++)
+				flush_dcache_page(newpage + i);
+		}
 	}
 out:
 	return rc;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


