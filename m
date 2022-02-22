Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF35C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiBVEWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:22:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBVEWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:22:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B688B23
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C60615B4
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCCEC340E8;
        Tue, 22 Feb 2022 04:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645503235;
        bh=yfZKR2HFQTQuO0jGKuJmvuCYN0IdP15P2LjbTHhOQis=;
        h=Date:To:From:Subject:From;
        b=jpO2Czt86Eod+I/ooej2hjyhJEIs1gnT8T9s2kMmfWRx3x5O7BuYhGbIiNejpTzR1
         UHEv3nDsmrv5l5xI5U+2e0kdXGyZ0ute1K83sdg8Su4od/NRfbZfLNCZR6gIcnCB0h
         R6SZPwFf4mghcvlR5QV8uh4H26ES9P/52rQJuXa4=
Date:   Mon, 21 Feb 2022 20:13:55 -0800
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-helper-function-range_in_vma.patch added to -mm tree
Message-Id: <20220222041355.BDCCEC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use helper function range_in_vma()
has been added to the -mm tree.  Its filename is
     mm-use-helper-function-range_in_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-helper-function-range_in_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-helper-function-range_in_vma.patch

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
Subject: mm/memory.c: use helper function range_in_vma()

Use helper function range_in_vma() to check if address, address + size are
within the vma range.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220219021441.29173-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-use-helper-function-range_in_vma
+++ a/mm/memory.c
@@ -1715,7 +1715,7 @@ static void zap_page_range_single(struct
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
-	if (address < vma->vm_start || address + size > vma->vm_end ||
+	if (!range_in_vma(vma, address, address + size) ||
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
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
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

