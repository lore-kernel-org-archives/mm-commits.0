Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E472DC5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbjAIWNp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbjAIWNi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:13:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC91DF31
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:13:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B80856145B
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8C6C433D2;
        Mon,  9 Jan 2023 22:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302415;
        bh=KBdk1GRm6HR2yu/egJfMq1WuTJDouDztdtuy3wHgwkQ=;
        h=Date:To:From:Subject:From;
        b=SYKmNiP4vw0qdcHj+QHyxtwj77la6zRpqoQiRIJ1Ch6xPfG1jx2ah3VzVuqzciz1P
         M7c8Pm+1kuFdjNak/E9ePLT5iEg9c380pVPiD3tEna+zeQSNizy8F0dAto00T+ltDu
         oJ1O4g2OAt/wf4pKG5BMbk6kysHbRk5gCgbQj+0A=
Date:   Mon, 09 Jan 2023 14:13:35 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch added to mm-unstable branch
Message-Id: <20230109221335.CA8C6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: record appropriate folio size when the access is not found
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch

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
Subject: mm/damon/vaddr: record appropriate folio size when the access is not found
Date: Mon, 9 Jan 2023 21:33:32 +0000

DAMON virtual address spaces monitoring operations set doesn't set folio
size of the access checked address if access is not found.  It could
result in unnecessary and inefficient repeated check.  Appropriately set
the size regardless of access check result.

Link: https://lkml.kernel.org/r/20230109213335.62525-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found
+++ a/mm/damon/vaddr.c
@@ -452,10 +452,9 @@ static int damon_young_pmd_entry(pmd_t *
 			goto huge_out;
 		if (pmd_young(*pmd) || !folio_test_idle(folio) ||
 					mmu_notifier_test_young(walk->mm,
-						addr)) {
-			*priv->folio_sz = HPAGE_PMD_SIZE;
+						addr))
 			priv->young = true;
-		}
+		*priv->folio_sz = HPAGE_PMD_SIZE;
 		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
@@ -474,10 +473,9 @@ regular_page:
 	if (!folio)
 		goto out;
 	if (pte_young(*pte) || !folio_test_idle(folio) ||
-			mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->folio_sz = folio_size(folio);
+			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
+	*priv->folio_sz = folio_size(folio);
 	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -504,10 +502,9 @@ static int damon_young_hugetlb_entry(pte
 	folio_get(folio);
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
-	    mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->folio_sz = huge_page_size(h);
+	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	}
+	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
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

