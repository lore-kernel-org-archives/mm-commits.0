Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2C5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383820AbiEMTYc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383822AbiEMTXP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3C23D4B9
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2A3B83193
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF9C34113;
        Fri, 13 May 2022 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469724;
        bh=rFKnE71Wy53vNsVQB5Zaz0drsprymyG3C/qX8rFBtSQ=;
        h=Date:To:From:Subject:From;
        b=sLi1zyngE0ohE7JK9mR33Qji82M6sPo4bHHWY4eUVb9Abb5oAM51u9QIYRLtNPA8T
         Lu5u0QvZtIs5QhGxvRuWOrPTm8+mWbHuAdzZH8ENrTVbOPcgBQcVlgj3R85xT5S3NG
         mUKmxUo5lB6sFdLz27k+KJuP/V0qnOaaEBb5XRrE=
Date:   Fri, 13 May 2022 12:22:04 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_mapping_flags.patch removed from -mm tree
Message-Id: <20220513192204.B1BF9C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_mapping_flags()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_mapping_flags.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_mapping_flags()

This is the equivalent of PageMappingFlags and is needed for converting
mm/migrate.c to folios.

Link: https://lkml.kernel.org/r/20220504182857.4013401-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/page-flags.h~mm-add-folio_mapping_flags
+++ a/include/linux/page-flags.h
@@ -650,6 +650,11 @@ __PAGEFLAG(Reported, reported, PF_NO_COM
 #define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
+static __always_inline bool folio_mapping_flags(struct folio *folio)
+{
+	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
+}
+
 static __always_inline int PageMappingFlags(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

