Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13931C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLUVUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLUVUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:20:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A062E0C8
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D688F60CD4
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31913C433EF;
        Wed, 21 Dec 2022 21:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657631;
        bh=Wmur3ppZMfJDEqEC6VHDzxS1E8AG8ZMgA1drg3XoTLI=;
        h=Date:To:From:Subject:From;
        b=BMU+O5xDlaAWwwpniDw3iGRj6X158G4CaHu8O7L4AORsvd0rEZfIoJOU/UQeNcuae
         5I7BzcyZ1C/BbL8inXmJSWx/leioOH6u8sQaa0cSd7FiMAalmWhC+Cq6nB9XpDnf4z
         1S+OkvRnkJW75soLrL3ksFwPhuCeSxHtcDQRTJGc=
Date:   Wed, 21 Dec 2022 13:20:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-vm_normal_folio.patch added to mm-unstable branch
Message-Id: <20221221212031.31913C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: add vm_normal_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-add-vm_normal_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-add-vm_normal_folio.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/memory: add vm_normal_folio()
Date: Wed, 21 Dec 2022 10:08:45 -0800

Patch series "Convert deactivate_page() to folio_deactivate()", v4.

Deactivate_page() has already been converted to use folios.  This patch
series modifies the callers of deactivate_page() to use folios.  It also
introduces vm_normal_folio() to assist with folio conversions, and
converts deactivate_page() to folio_deactivate() which takes in a folio.


This patch (of 4):

Introduce a wrapper function called vm_normal_folio().  This function
calls vm_normal_page() and returns the folio of the page found, or null if
no page is found.

This function allows callers to get a folio from a pte, which will
eventually allow them to completely replace their struct page variables
with struct folio instead.

Link: https://lkml.kernel.org/r/20221221180848.20774-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20221221180848.20774-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   10 ++++++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vm_normal_folio
+++ a/include/linux/mm.h
@@ -1968,6 +1968,8 @@ static inline bool can_do_mlock(void) {
 extern int user_shm_lock(size_t, struct ucounts *);
 extern void user_shm_unlock(size_t, struct ucounts *);
 
+struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte);
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
--- a/mm/memory.c~mm-memory-add-vm_normal_folio
+++ a/mm/memory.c
@@ -625,6 +625,16 @@ out:
 	return pfn_to_page(pfn);
 }
 
+struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
+			    pte_t pte)
+{
+	struct page *page = vm_normal_page(vma, addr, pte);
+
+	if (page)
+		return page_folio(page);
+	return NULL;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch

