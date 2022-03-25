Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E35C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357400AbiCYBeD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357368AbiCYBca (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BDBD2FC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AA9B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE28BC340ED;
        Fri, 25 Mar 2022 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171855;
        bh=uY55cien4s3mr0D9Kyxw+aVZm8GNaAUPv4WuH0YwoR8=;
        h=Date:To:From:Subject:From;
        b=Vu/cRiFhQFFo/PFp+Ri5GZwK/xbUsIgbtG/4CZdxxegIO0By9gHFj06SUbrt9qh2P
         1ICdHUbpmant3UjfZu4qsO+0gBPaSZ7c+kiRSpZriePJkkdEJ7FK88oKx2vG3FvZss
         A74R5JjXerdNRAuudGPAjRiRFu9cF0B7FMSw/J6c=
Date:   Thu, 24 Mar 2022 18:30:54 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch removed from -mm tree
Message-Id: <20220325013054.EE28BC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()

userfaultfd calls shmem_mfill_atomic_pte() which does not do any cache
flushing for the target page.  Then the target page will be mapped to the
user space with a different address (user address), which might have an
alias issue with the kernel address used to copy the data from the user
to.  Insert flush_dcache_page() in non-zero-page case.  And replace
clear_highpage() with clear_user_highpage() which already considers the
cache maintenance.

Link: https://lkml.kernel.org/r/20220210123058.79206-6-songmuchun@bytedance.com
Fixes: 8d1039634206 ("userfaultfd: shmem: add shmem_mfill_zeropage_pte for userfaultfd support")
Fixes: 4c27fe4c4c84 ("userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte
+++ a/mm/shmem.c
@@ -2364,8 +2364,10 @@ int shmem_mfill_atomic_pte(struct mm_str
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
+
+			flush_dcache_page(page);
 		} else {		/* ZEROPAGE */
-			clear_highpage(page);
+			clear_user_highpage(page, dst_addr);
 		}
 	} else {
 		page = *pagep;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


