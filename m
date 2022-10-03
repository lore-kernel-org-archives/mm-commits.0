Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5ACC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJCVPj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiJCVOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A154CB6
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E729610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67466C433D6;
        Mon,  3 Oct 2022 21:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831371;
        bh=d8eGVYl5t63VN/YuqLxSpwWillrT7LsZ9Yy4t0nNv7k=;
        h=Date:To:From:Subject:From;
        b=xayFjJTMw6owq0Vrpq2sg3xliBnZa7xfJDKwjB3i4pziznGtRWpffODnG1l8tEGfq
         bfYH+WQ9/BaMMmA3mPvL+Y4+maZZ7lCNeJchdJFdQGKX0OhsoQCvtrMqstaYMbk7lG
         03CilDYcOER2eAO+5oCUgMGv/npBkqEd0qDyURPQ=
Date:   Mon, 03 Oct 2022 14:09:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch removed from -mm tree
Message-Id: <20221003210931.67466C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: add __init annotations to init_mem_debugging_and_hardening()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: add __init annotations to init_mem_debugging_and_hardening()
Date: Fri, 16 Sep 2022 15:22:46 +0800

It's only called by mm_init(). Add __init annotations to it.

Link: https://lkml.kernel.org/r/20220916072257.9639-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/page_alloc.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening
+++ a/include/linux/mm.h
@@ -3092,7 +3092,7 @@ extern int apply_to_existing_page_range(
 				   unsigned long address, unsigned long size,
 				   pte_fn_t fn, void *data);
 
-extern void init_mem_debugging_and_hardening(void);
+extern void __init init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
 extern void __kernel_poison_pages(struct page *page, int numpages);
 extern void __kernel_unpoison_pages(struct page *page, int numpages);
--- a/mm/page_alloc.c~mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening
+++ a/mm/page_alloc.c
@@ -903,7 +903,7 @@ static inline void clear_page_guard(stru
  * order of appearance. So we need to first gather the full picture of what was
  * enabled, and then make decisions.
  */
-void init_mem_debugging_and_hardening(void)
+void __init init_mem_debugging_and_hardening(void)
 {
 	bool page_poisoning_requested = false;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


