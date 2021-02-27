Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3466DC43381
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064A664F38
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhB0Ca6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhB0Cai (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B839A64F33;
        Sat, 27 Feb 2021 02:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393001;
        bh=2y/yAzef0XQeAjuHv8jUj+q2/leGlZ0r8FS/35Kwsa0=;
        h=Date:From:To:Subject:From;
        b=jxzZPhjvQ/O3O1ABXjl4DR+20wOOHAckB1xXntLPISITr7N66HJIqIjF5wYk2HIMZ
         0iBIufbZDD7i9XwaL9KuDiZdPLgWXBkioiVAUzt1SN6sYsCuzzA1glnApjlce5McbD
         xbn7U1GgFPtHrmSGDSQO0/znHJxy1jUMBb1abs4w=
Date:   Fri, 26 Feb 2021 18:30:00 -0800
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, bgeffon@google.com, hannes@cmpxchg.org,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, louhongxiang@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        richard.weiyang@linux.alibaba.com, sedat.dilek@gmail.com,
        shakeelb@google.com, vbabka@suse.cz, walken@google.com
Subject:  [merged]
 mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch removed from -mm
 tree
Message-ID: <20210227023000.05vS0ZjOx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix potential pte_unmap on an not mapped pte
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: fix potential pte_unmap on an not mapped pte

For PMD-mapped page (usually THP), pvmw->pte is NULL.  For PTE-mapped THP,
pvmw->pte is mapped.  But for HugeTLB pages, pvmw->pte is not mapped and
set to the relevant page table entry.  So in page_vma_mapped_walk_done(),
we may do pte_unmap() for HugeTLB pte which is not mapped.  Fix this by
checking pvmw->page against PageHuge before trying to do pte_unmap().

Link: https://lkml.kernel.org/r/20210127093349.39081-1-linmiaohe@huawei.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/include/linux/rmap.h
@@ -213,7 +213,8 @@ struct page_vma_mapped_walk {
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 {
-	if (pvmw->pte)
+	/* HugeTLB pte is set to the relevant page table entry without pte_mapped. */
+	if (pvmw->pte && !PageHuge(pvmw->page))
 		pte_unmap(pvmw->pte);
 	if (pvmw->ptl)
 		spin_unlock(pvmw->ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


