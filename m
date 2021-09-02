Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3C6C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD98610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347823AbhIBVyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347727AbhIBVyo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F98610A2;
        Thu,  2 Sep 2021 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619626;
        bh=6JZSgG/1Cc6cC7JLrfjbC8YPtOtg1nVaTRX08D6/drI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=euKJXObnoXehB1leMP7Oq2dcg39PZgmuheIcwSyUhZ0kxXuvxeYgo7Q5qWqFXsQ8i
         8cR3Ce1SKlmC4/N88oZ58sptLEP/k/MlgA56To0tokyut9pbP+oNXfz/OOiE57uls2
         9lXdI37FSQ9qibtBeYPA3rTb36td16vDCUx6/jHY=
Date:   Thu, 02 Sep 2021 14:53:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 072/212] mm: gup: use helper PAGE_ALIGNED in
 populate_vma_page_range()
Message-ID: <20210902215345.YsVmhY1GZ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: use helper PAGE_ALIGNED in populate_vma_page_range()

Use helper PAGE_ALIGNED to check if address is aligned to PAGE_SIZE. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20210807093620.21347-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-use-helper-page_aligned-in-populate_vma_page_range
+++ a/mm/gup.c
@@ -1471,8 +1471,8 @@ long populate_vma_page_range(struct vm_a
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 
-	VM_BUG_ON(start & ~PAGE_MASK);
-	VM_BUG_ON(end   & ~PAGE_MASK);
+	VM_BUG_ON(!PAGE_ALIGNED(start));
+	VM_BUG_ON(!PAGE_ALIGNED(end));
 	VM_BUG_ON_VMA(start < vma->vm_start, vma);
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	mmap_assert_locked(mm);
_
