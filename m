Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDCEC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbjKJRma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbjKJRly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98186446C8
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B4CC433C8;
        Fri, 10 Nov 2023 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637147;
        bh=3c/PwcBNU+43KkF83M1ojH5Cr/KALAu8g1qXxvXebVU=;
        h=Date:To:From:Subject:From;
        b=yA5nMv90jfPHt7WjrGgpIBTF+mrS0aFMV/JQ6VxpOQ+gyTW9uJqJpRgWMhLDkLQ9T
         SR3PZYOmTQMRHv++qubQLNjVTbzgHsOforOI92XsU4CjaUZpSU09TXhsULhxyhmsgp
         31jjRB6rbpxWoiPUndqssxD3yFid5CFt0nVpE6XI=
Date:   Fri, 10 Nov 2023 09:25:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-respect-folio-head-page-flag-placement.patch added to mm-unstable branch
Message-Id: <20231110172547.31B4CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/page: respect folio head-page flag placement
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-page-respect-folio-head-page-flag-placement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-respect-folio-head-page-flag-placement.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs/proc/page: respect folio head-page flag placement
Date: Fri, 10 Nov 2023 11:33:20 +0800

kpageflags reads page-flags directly from the page, even when the
respective flag is only updated on the headpage of a folio.

Since most flags are stored in head flags, make k = folio->flags, and add
new p = page->flags used for per-page flags.

Based upon a patch by Gregory Price.

Link: https://lkml.kernel.org/r/20231110033324.2455523-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-respect-folio-head-page-flag-placement
+++ a/fs/proc/page.c
@@ -110,8 +110,7 @@ static inline u64 kpf_copy_bit(u64 kflag
 u64 stable_page_flags(struct page *page)
 {
 	struct folio *folio;
-	u64 k;
-	u64 u;
+	u64 k, p, u;
 
 	/*
 	 * pseudo flag: KPF_NOPAGE
@@ -121,7 +120,8 @@ u64 stable_page_flags(struct page *page)
 		return 1 << KPF_NOPAGE;
 
 	folio = page_folio(page);
-	k = page->flags;
+	k = folio->flags;
+	p = page->flags;
 	u = 0;
 
 	/*
@@ -202,7 +202,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+	u |= kpf_copy_bit(p, KPF_HWPOISON,	PG_hwpoison);
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
@@ -211,13 +211,13 @@ u64 stable_page_flags(struct page *page)
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_MAPPEDTODISK,	PG_mappedtodisk);
-	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
-	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
-	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
+	u |= kpf_copy_bit(p, KPF_PRIVATE,	PG_private);
+	u |= kpf_copy_bit(p, KPF_PRIVATE_2,	PG_private_2);
+	u |= kpf_copy_bit(p, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
-	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
-	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
+	u |= kpf_copy_bit(p, KPF_ARCH_2,	PG_arch_2);
+	u |= kpf_copy_bit(p, KPF_ARCH_3,	PG_arch_3);
 #endif
 
 	return u;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch

