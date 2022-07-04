Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5885DC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiGDBkt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiGDBkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655763DE
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFA34B8015B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC5AC341C6;
        Mon,  4 Jul 2022 01:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656898837;
        bh=qaaQoMfXu4e51aMSXCWJOjNE3aOpcBmhySrewsV539U=;
        h=Date:To:From:Subject:From;
        b=saJMyjtwQ/qPnPU3hKWbiJdmzPpf5MsTx8aH5e2njaMn2z3R93IuxxvWhKcIYePP5
         uuootW8m2Vg1EHbj54bFDJ4pZQ1x1eWu6siSZ1GQb8pdR1Y00F0vb/isyooGjkQtMr
         +ixHJREGfqwMzOdMlJF7uM2O3DoXgqtVkJx/Hjfc=
Date:   Sun, 03 Jul 2022 18:40:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch added to mm-unstable branch
Message-Id: <20220704014037.8CC5AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: enable memory error handling on 1GB hugepage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: enable memory error handling on 1GB hugepage
Date: Mon, 4 Jul 2022 10:33:12 +0900

Now error handling code is prepared, so remove the blocking code and
enable memory error handling on 1GB hugepage.

Link: https://lkml.kernel.org/r/20220704013312.2415700-10-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |   16 ----------------
 3 files changed, 18 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/include/linux/mm.h
@@ -3295,7 +3295,6 @@ enum mf_action_page_type {
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
-	MF_MSG_NON_PMD_HUGE,
 	MF_MSG_UNMAP_FAILED,
 	MF_MSG_DIRTY_SWAPCACHE,
 	MF_MSG_CLEAN_SWAPCACHE,
--- a/include/ras/ras_event.h~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/include/ras/ras_event.h
@@ -360,7 +360,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
-	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
 	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
 	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
 	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
--- a/mm/memory-failure.c~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -765,7 +765,6 @@ static const char * const action_page_ty
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
-	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
 	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
 	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
@@ -1868,21 +1867,6 @@ retry:
 
 	page_flags = head->flags;
 
-	/*
-	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
-	 * simply disable it. In order to make it work properly, we need
-	 * make sure that:
-	 *  - conversion of a pud that maps an error hugetlb into hwpoison
-	 *    entry properly works, and
-	 *  - other mm code walking over page table is aware of pud-aligned
-	 *    hwpoison entries.
-	 */
-	if (huge_page_size(page_hstate(head)) > PMD_SIZE) {
-		action_result(pfn, MF_MSG_NON_PMD_HUGE, MF_IGNORED);
-		res = -EBUSY;
-		goto out;
-	}
-
 	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

