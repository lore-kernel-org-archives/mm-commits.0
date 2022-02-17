Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B5CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 03:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiBQDDD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 22:03:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiBQDDC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 22:03:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6991FA22E
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 19:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7101561CFE
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 03:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2338C004E1;
        Thu, 17 Feb 2022 03:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066967;
        bh=mv2e8xf/zALQyjrbBVokTO/l3o02cZ/glyqrn01Anrc=;
        h=Date:To:From:Subject:From;
        b=nULPdXaOH/Krj9GBJQTeScg+3Sals3fd+6pkQhrhTaOKCm+XfIwQfBP8TOX9c/ZKd
         eNVmeILyYeC2/kPriWqt1lsQPIfgAV90C5ZA2nN1y9AF1aYFoWMq2StBrJgLXu5oVQ
         FUycaoeN0IhVDGaZO57sy5gfaWG6FqrNqHJL7qKA=
Date:   Wed, 16 Feb 2022 19:02:47 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch added to -mm tree
Message-Id: <20220217030247.C2338C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: catch unexpected -EFAULT from vma_address()
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch

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
Subject: mm/memory-failure.c: catch unexpected -EFAULT from vma_address()

It's unexpected to walk the page table when vma_address() return -EFAULT. 
But dev_pagemap_mapping_shift() is called only when vma associated to the
error page is found already in collect_procs_{file,anon}, so vma_address()
should not return -EFAULT except with some bug, as Naoya pointed out.  We
can use VM_BUG_ON_VMA() to catch this bug here.

Link: https://lkml.kernel.org/r/20220216091431.39406-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failurec-catch-unexpected-efault-from-vma_address
+++ a/mm/memory-failure.c
@@ -315,6 +315,7 @@ static unsigned long dev_pagemap_mapping
 	pmd_t *pmd;
 	pte_t *pte;
 
+	VM_BUG_ON_VMA(address == -EFAULT, vma);
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
 		return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

