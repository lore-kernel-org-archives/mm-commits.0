Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D528C54EBE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbjAIWNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237885AbjAIWNm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:13:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F159B1707F
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B9F7612C5
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E44C433EF;
        Mon,  9 Jan 2023 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302417;
        bh=FmVDKy8JWjjdB41w9pmQ4Fiq8w+ryfnsDlqUYe0o5+U=;
        h=Date:To:From:Subject:From;
        b=k2p8HW1T81GenrYcpdCYKzIBxb1nGEKfLb1q6IJa0lSj6DV/bPmkMIT5LuLMT86Uu
         omDBx4FG6xWYmjv9n0xQ4OVYm5GIGMNp2c3hxVn9UqBVbnfUzka02lQ/eanyxG0wOA
         gXlqUO0YYG8cd9y+d/GwDJS0rxobfKN6hUcSfWmk=
Date:   Mon, 09 Jan 2023 14:13:37 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch added to mm-unstable branch
Message-Id: <20230109221337.B7E44C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: rename 'damon_pa_access_chk_result->page_sz' to 'folio_sz'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: rename 'damon_pa_access_chk_result->page_sz' to 'folio_sz'
Date: Mon, 9 Jan 2023 21:33:33 +0000

DAMON's physical address space monitoring operations set is using folio
now.  Rename 'damon_pa_access_chk_result->page_sz' to reflect the fact.

Link: https://lkml.kernel.org/r/20230109213335.62525-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz
+++ a/mm/damon/paddr.c
@@ -80,7 +80,8 @@ static void damon_pa_prepare_access_chec
 }
 
 struct damon_pa_access_chk_result {
-	unsigned long page_sz;
+	/* size of the folio for the access checked physical memory address */
+	unsigned long folio_sz;
 	bool accessed;
 };
 
@@ -91,7 +92,7 @@ static bool __damon_pa_young(struct foli
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 
 	result->accessed = false;
-	result->page_sz = PAGE_SIZE;
+	result->folio_sz = PAGE_SIZE;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
@@ -103,7 +104,7 @@ static bool __damon_pa_young(struct foli
 			result->accessed = pmd_young(*pvmw.pmd) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
-			result->page_sz = HPAGE_PMD_SIZE;
+			result->folio_sz = HPAGE_PMD_SIZE;
 #else
 			WARN_ON_ONCE(1);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -118,11 +119,11 @@ static bool __damon_pa_young(struct foli
 	return !result->accessed;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *page_sz)
+static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct damon_pa_access_chk_result result = {
-		.page_sz = PAGE_SIZE,
+		.folio_sz = PAGE_SIZE,
 		.accessed = false,
 	};
 	struct rmap_walk_control rwc = {
@@ -157,25 +158,25 @@ static bool damon_pa_young(unsigned long
 	folio_put(folio);
 
 out:
-	*page_sz = result.page_sz;
+	*folio_sz = result.folio_sz;
 	return result.accessed;
 }
 
 static void __damon_pa_check_access(struct damon_region *r)
 {
 	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
+	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
 	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_page_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_page_sz)) {
+	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
+				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
 		if (last_accessed)
 			r->nr_accesses++;
 		return;
 	}
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_page_sz);
+	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
 	if (last_accessed)
 		r->nr_accesses++;
 
_

Patches currently in -mm which might be from sj@kernel.org are

include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch
mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch
mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch
mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch
mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch
mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch
mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch
scripts-spelling-add-a-few-more-typos.patch

