Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A90EC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764D46101C
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhHGSny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGSny (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 14:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C8E60C41;
        Sat,  7 Aug 2021 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628361815;
        bh=GeDym/PxqGtccT2hgndp7XWCGFXszhzqrl+VATt/V5o=;
        h=Date:From:To:Subject:From;
        b=v491kik8+5PgI2wzsCmjbPkApPSxDyDs30ymR/sBwmL8F23hC6y4x7L+uIgRUIM6E
         AlTlSWfnz9p3Wcy0svPFbJGJsIrjLrngkjYYbDSfQZZ3/md06p5gy5ORFUzdwSUfQ+
         /VfF87/W5JMgoXDEtZ2/VozdMlspt4Jm33sdjT/s=
Date:   Sat, 07 Aug 2021 11:43:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com,
        linmiaohe@huawei.com
Subject:  +
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch added to
 -mm tree
Message-ID: <20210807184335.yMIze%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()
has been added to the -mm tree.  Its filename is
     mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch

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
Subject: mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()

When failed to try_grab_page, put_dev_pagemap() is missed.  So pgmap
refcnt will leak in this case.  Also we remove the check for pgmap against
NULL as it's also checked inside the put_dev_pagemap().

Link: https://lkml.kernel.org/r/20210807093620.21347-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge
+++ a/mm/gup.c
@@ -2253,14 +2253,14 @@ static int __gup_device_huge(unsigned lo
 		pages[*nr] = page;
 		if (unlikely(!try_grab_page(page, flags))) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
+			put_dev_pagemap(pgmap);
 			return 0;
 		}
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (pgmap)
-		put_dev_pagemap(pgmap);
+	put_dev_pagemap(pgmap);
 	return 1;
 }
 
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

