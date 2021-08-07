Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934BDC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7745761058
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhHGSn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGSn5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 14:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8508E6101C;
        Sat,  7 Aug 2021 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628361819;
        bh=FthHlyjWoRL1sD5OyzaCjZl5A/0gv5XJNA7tHgQNn6A=;
        h=Date:From:To:Subject:From;
        b=Xtn5uLCcELA/KfKH5D3bzdceuUHpijaV+6mwFgi2yAq3Q0J6Kokbf1Sf+zfZEoT8H
         Q7jxgingNO+YQsChCET9Ivw4gkTDrBWUAGm2OTlQ/RaHVRn+i3kBLdtLc9VTqBK/eJ
         JNU3erCYNKSNyTkkg9kREr70vh43FX8UsMIKNv8A=
Date:   Sat, 07 Aug 2021 11:43:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com,
        linmiaohe@huawei.com
Subject:  +
 mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch added to -mm
 tree
Message-ID: <20210807184339.DCVyv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: use helper PAGE_ALIGNED in populate_vma_page_range()
has been added to the -mm tree.  Its filename is
     mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: use helper PAGE_ALIGNED in populate_vma_page_range()

Use helper PAGE_ALIGNED to check if address is aligned to PAGE_SIZE. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20210807093620.21347-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
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

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

