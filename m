Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE41C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357384AbiCYBeI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357383AbiCYBcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9ACBD8B7
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79815B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180B7C340EE;
        Fri, 25 Mar 2022 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171856;
        bh=6wShLKWwZ57Jm+uan/ndDs87DZEDKeaj/YAjxvRxP6o=;
        h=Date:To:From:Subject:From;
        b=Xez2GaJsjZbarZefiWGOUm1DHc2jGtFQDWIW9oeIIyapRJEZIXO4IQSSXaAn+VLeH
         b3Ptg4KCm9qYxnooieV+WsignOpIcX02p6UOfaMtT5n5YS2DLBrTxlQZAmli3BcAwg
         BwhijOFVM+2U3hj10WG/C9P9u6jKNQ9gprNI/1bk=
Date:   Thu, 24 Mar 2022 18:30:55 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch removed from -mm tree
Message-Id: <20220325013056.180B7C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

userfaultfd calls mcopy_atomic_pte() and __mcopy_atomic() which do not do
any cache flushing for the target page.  Then the target page will be
mapped to the user space with a different address (user address), which
might have an alias issue with the kernel address used to copy the data
from the user to.  Fix this by insert flush_dcache_page() after
copy_from_user() succeeds.

Link: https://lkml.kernel.org/r/20220210123058.79206-7-songmuchun@bytedance.com
Fixes: b6ebaedb4cb1 ("userfaultfd: avoid mmap_sem read recursion in mcopy_atomic")
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic
+++ a/mm/userfaultfd.c
@@ -150,6 +150,8 @@ static int mcopy_atomic_pte(struct mm_st
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -625,6 +627,7 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


