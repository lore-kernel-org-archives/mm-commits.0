Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9226DC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450BC64F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhBYTgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhBYTfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A326064FB8;
        Thu, 25 Feb 2021 19:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280721;
        bh=h/E70AAnwem5ZDd3Ld8R3DFRv2pcVjmFJhW2hiRWSDI=;
        h=Date:From:To:Subject:From;
        b=pAhIfkcQEY5FdkEDv0Y9rygwc3FaVBvORogg9fwzxUstYGV/DL8wIQqkQN8QqQpKj
         VgrpYncN2QZm4nEUxfLsIfmrQqhGOpJx9GbIP3bOPBlhIBe8TpbqvEYqBMNMnObG4a
         TGOrt4ac3kq41l/3XbuRJOUaQIHK2yRSAJ8kLutk=
Date:   Thu, 25 Feb 2021 11:18:41 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch removed
 from -mm tree
Message-ID: <20210225191841.T4r9AiCTa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked

The VM_BUG_ON_PAGE(!PageLocked(page), page) is also done in PageMovable.
Remove this explicitly one.

Link: https://lkml.kernel.org/r/20210109081420.46030-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked
+++ a/mm/compaction.c
@@ -137,7 +137,6 @@ EXPORT_SYMBOL(__SetPageMovable);
 
 void __ClearPageMovable(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	/*
 	 * Clear registered address_space val with keeping PAGE_MAPPING_MOVABLE
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

