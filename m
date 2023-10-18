Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A4BCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbjJRVgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55A8186
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BC1C116A7;
        Wed, 18 Oct 2023 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664924;
        bh=MCVjzD33G35TBxg+WguDIHoUR/ZIJM0pemNcP7UYCso=;
        h=Date:To:From:Subject:From;
        b=pljhmhKrL/hcYdSc7zmbHKAnTQgxUKF+np+fkg2xEJJRLyLu7htUwlDUbhWBjjyth
         k7iFYcyLRdkx7sdmXv4QUxJYNpyhwn0/vZsLlRSlwSXpW8faqO9A8KSWdIJb2xVVN/
         YUfUet4ShnwDU3jpAl9mJ8R+gOz9SSMg8G89xGXk=
Date:   Wed, 18 Oct 2023 14:35:23 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch removed from -mm tree
Message-Id: <20231018213524.08BC1C116A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: adapt get_user_page_vma_remote() to never return NULL
has been removed from the -mm tree.  Its filename was
     mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
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
@@ -5815,7 +5815,7 @@ static int __access_remote_vm(struct mm_
 		struct page *page = get_user_page_vma_remote(mm, addr,
 							     gup_flags, &vma);
 
-		if (IS_ERR_OR_NULL(page)) {
+		if (IS_ERR(page)) {
 			/* We might need to expand the stack to access it */
 			vma = vma_lookup(mm, addr);
 			if (!vma) {
@@ -5829,7 +5829,6 @@ static int __access_remote_vm(struct mm_
 				continue;
 			}
 
-
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
_

Patches currently in -mm which might be from lstoakes@gmail.com are


