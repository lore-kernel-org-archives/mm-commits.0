Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E179DC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7482224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709123;
	bh=2/Pi+fADzTmA0k2y8EIrvUCr2GLvgOIZ9pHMCpVur4I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nYL4Q8clFFbH5MYp8rd+giSMmJ3jb0M6ym3gVmxFmg0+NJtzeWcOYooC3xrlrFvW3
	 dURvsBPiCIJ9eeDUsFKD0HpnA9vSSXVj13HAm/6rxKgIeNysgvS0nzPJrfMBkt8/yk
	 +pDAktUMnUgTw1bQ+xHyM8jmU5ITTHjcoQeN8dJQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbgJNU6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB19D22248;
        Wed, 14 Oct 2020 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709122;
        bh=2/Pi+fADzTmA0k2y8EIrvUCr2GLvgOIZ9pHMCpVur4I=;
        h=Date:From:To:Subject:From;
        b=1vdFXCu0YzDOZy0Mz1JTk2eSU6ztagE5ii1FTy51nSBQgEhQwR+nexTSrOUFTUnv5
         LFmTllN+6UqkuoRhUpNMXX1idxX+poax3tmFg75zjwv/37S/MFDYJFT5Gyehiv+436
         jiVKwMwfqWrwbb8e9vsKSohlEvTSw77j0JVl/SVg=
Date:   Wed, 14 Oct 2020 13:58:41 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch removed from
 -mm tree
Message-ID: <20201014205841.3s1c-eP0e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dump_page: rename head_mapcount() --> head_compound_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm, dump_page: rename head_mapcount() --> head_compound_mapcount()

Rename head_pincount() --> head_compound_pincount().  These names are more
accurate (or less misleading) than the original ones.

Link: https://lkml.kernel.org/r/20200807183358.105097-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/debug.c         |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/include/linux/mm.h
@@ -791,7 +791,7 @@ static inline void *kvcalloc(size_t n, s
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
-static inline int head_mapcount(struct page *head)
+static inline int head_compound_mapcount(struct page *head)
 {
 	return atomic_read(compound_mapcount_ptr(head)) + 1;
 }
@@ -805,7 +805,7 @@ static inline int compound_mapcount(stru
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
-	return head_mapcount(page);
+	return head_compound_mapcount(page);
 }
 
 /*
@@ -918,7 +918,7 @@ static inline bool hpage_pincount_availa
 	return PageCompound(page) && compound_order(page) > 1;
 }
 
-static inline int head_pincount(struct page *head)
+static inline int head_compound_pincount(struct page *head)
 {
 	return atomic_read(compound_pincount_ptr(head));
 }
@@ -927,7 +927,7 @@ static inline int compound_pincount(stru
 {
 	VM_BUG_ON_PAGE(!hpage_pincount_available(page), page);
 	page = compound_head(page);
-	return head_pincount(page);
+	return head_compound_pincount(page);
 }
 
 static inline void set_compound_order(struct page *page, unsigned int order)
--- a/mm/debug.c~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/mm/debug.c
@@ -102,12 +102,12 @@ void __dump_page(struct page *page, cons
 		if (hpage_pincount_available(page)) {
 			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head),
-					head_pincount(head));
+					head_compound_mapcount(head),
+					head_compound_pincount(head));
 		} else {
 			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head));
+					head_compound_mapcount(head));
 		}
 	}
 	if (PageKsm(page))
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

