Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C26C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D289601FD
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbhICU5g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhICU52 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC9F610E5;
        Fri,  3 Sep 2021 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702587;
        bh=y5YfLhyvBOjGzFk5eU+/c9gTfsoyyh85zw36bJhOUv8=;
        h=Date:From:To:Subject:From;
        b=KZuFuKyaYgkUQ6wArsKzaZoHysUiuVx/kaJUGNHbQgI7LBflrZI1tpnLHZUhxi5fB
         i+n1L9feQpJknkahNjjxXsMalzKdg8gPEQnD0uWt5of50Fmvj8zK4wJWtXorD71VEI
         y+qrTRm6iHAU+heFj/nFHqVaVqlqrTfqSVyzsIMo=
Date:   Fri, 03 Sep 2021 13:56:27 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch removed
 from -mm tree
Message-ID: <20210903205627.2_ootNI8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: use helper PAGE_ALIGNED in populate_vma_page_range()
has been removed from the -mm tree.  Its filename was
     mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

