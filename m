Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC77EE7AD78
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjJCRPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjJCRPZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:15:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA64FA7
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:15:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498CCC433C8;
        Tue,  3 Oct 2023 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696353320;
        bh=ODujUVY3nQ67kkAW05fQMzmm1YYSh+1n/M/uQ6kQYRo=;
        h=Date:To:From:Subject:From;
        b=jA3hxjF6fHYSjs90nEDSy+1GtUKszlZWSyL1r4JhHqXi++EFwjQ+ptpZ3zFkPYAax
         0u9cp7pd3P0rZ86Zo/+gdYN77H2Wq6KBHJZiFl9mjnuv5G+KxCh6LJIUGvFkL4gzNJ
         g3PDm5d5KQ8TCbMc8h264TFgNOp6CK3hRMPdnMtA=
Date:   Tue, 03 Oct 2023 10:15:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch added to mm-unstable branch
Message-Id: <20231003171520.498CCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: adapt get_user_page_vma_remote() to never return NULL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: adapt get_user_page_vma_remote() to never return NULL
Date: Tue, 3 Oct 2023 00:14:54 +0100

get_user_pages_remote() will never return 0 except in the case of
FOLL_NOWAIT being specified, which we explicitly disallow.

This simplifies error handling for the caller and avoids the awkwardness
of dealing with both errors and failing to pin.  Failing to pin here is an
error.

Link: https://lkml.kernel.org/r/00319ce292d27b3aae76a0eb220ce3f528187508.1696288092.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/mte.c |    4 ++--
 include/linux/mm.h      |   12 +++++++++---
 kernel/events/uprobes.c |    4 ++--
 mm/memory.c             |    3 +--
 4 files changed, 14 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/mte.c~mm-gup-adapt-get_user_page_vma_remote-to-never-return-null
+++ a/arch/arm64/kernel/mte.c
@@ -411,8 +411,8 @@ static int __access_remote_tags(struct m
 		struct page *page = get_user_page_vma_remote(mm, addr,
 							     gup_flags, &vma);
 
-		if (IS_ERR_OR_NULL(page)) {
-			err = page == NULL ? -EIO : PTR_ERR(page);
+		if (IS_ERR(page)) {
+			err = PTR_ERR(page);
 			break;
 		}
 
--- a/include/linux/mm.h~mm-gup-adapt-get_user_page_vma_remote-to-never-return-null
+++ a/include/linux/mm.h
@@ -2425,6 +2425,9 @@ long pin_user_pages_remote(struct mm_str
 			   unsigned int gup_flags, struct page **pages,
 			   int *locked);
 
+/*
+ * Retrieves a single page alongside its VMA. Does not support FOLL_NOWAIT.
+ */
 static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
 						    unsigned long addr,
 						    int gup_flags,
@@ -2432,12 +2435,15 @@ static inline struct page *get_user_page
 {
 	struct page *page;
 	struct vm_area_struct *vma;
-	int got = get_user_pages_remote(mm, addr, 1, gup_flags, &page, NULL);
+	int got;
+
+	if (WARN_ON_ONCE(unlikely(gup_flags & FOLL_NOWAIT)))
+		return ERR_PTR(-EINVAL);
+
+	got = get_user_pages_remote(mm, addr, 1, gup_flags, &page, NULL);
 
 	if (got < 0)
 		return ERR_PTR(got);
-	if (got == 0)
-		return NULL;
 
 	vma = vma_lookup(mm, addr);
 	if (WARN_ON_ONCE(!vma)) {
--- a/kernel/events/uprobes.c~mm-gup-adapt-get_user_page_vma_remote-to-never-return-null
+++ a/kernel/events/uprobes.c
@@ -474,8 +474,8 @@ retry:
 		gup_flags |= FOLL_SPLIT_PMD;
 	/* Read the page with vaddr into memory */
 	old_page = get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
-	if (IS_ERR_OR_NULL(old_page))
-		return old_page ? PTR_ERR(old_page) : 0;
+	if (IS_ERR(old_page))
+		return PTR_ERR(old_page);
 
 	ret = verify_opcode(old_page, vaddr, &opcode);
 	if (ret <= 0)
--- a/mm/memory.c~mm-gup-adapt-get_user_page_vma_remote-to-never-return-null
+++ a/mm/memory.c
@@ -5905,7 +5905,7 @@ static int __access_remote_vm(struct mm_
 		struct page *page = get_user_page_vma_remote(mm, addr,
 							     gup_flags, &vma);
 
-		if (IS_ERR_OR_NULL(page)) {
+		if (IS_ERR(page)) {
 			/* We might need to expand the stack to access it */
 			vma = vma_lookup(mm, addr);
 			if (!vma) {
@@ -5919,7 +5919,6 @@ static int __access_remote_vm(struct mm_
 				continue;
 			}
 
-
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

