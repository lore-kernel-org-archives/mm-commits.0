Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88621C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiGDBkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGDBk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:40:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01AC62DF
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9234DB80CED
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485AAC341C6;
        Mon,  4 Jul 2022 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656898824;
        bh=Gz6s4iUkJo/ybcWvtSMQofJetA508/EEh+vLPCaPni8=;
        h=Date:To:From:Subject:From;
        b=w+I0UXWtiEFk/tpyLfxdrS+/4v0tlxtsCSZf9pUNe92PQn6e7t2yBw9aNElEJNrP7
         oQ5S9iF4VaBhYp+LwUSM/xNSqkIvdT8Hyy1ooGpVnTbm+jfCb+WYCoAM/OmUb/xL7K
         OWQ7nnq4v6d4nlHIqIKbRF9utzGav9a6wHmUPQEM=
Date:   Sun, 03 Jul 2022 18:40:23 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch added to mm-unstable branch
Message-Id: <20220704014024.485AAC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch

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
Subject: mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
Date: Mon, 4 Jul 2022 10:33:06 +0900

follow_pud_mask() does not support non-present pud entry now.  As long as
I tested on x86_64 server, follow_pud_mask() still simply returns
no_page_table() for non-present_pud_entry() due to pud_bad(), so no severe
user-visible effect should happen.  But generally we should call
follow_huge_pud() for non-present pud entry for 1GB hugetlb page.

Update pud_huge() and follow_huge_pud() to handle non-present pud entries.
The changes are similar to previous works for pud entries commit
e66f17ff7177 ("mm/hugetlb: take page table lock in follow_huge_pmd()") and
commit cbef8478bee5 ("mm/hugetlb: pmd_huge() returns true for non-present
hugepage").

Link: https://lkml.kernel.org/r/20220704013312.2415700-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    8 +++++++-
 mm/hugetlb.c              |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry
+++ a/arch/x86/mm/hugetlbpage.c
@@ -30,9 +30,15 @@ int pmd_huge(pmd_t pmd)
 		(pmd_val(pmd) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
 }
 
+/*
+ * pud_huge() returns 1 if @pud is hugetlb related entry, that is normal
+ * hugetlb entry or non-present (migration or hwpoisoned) hugetlb entry.
+ * Otherwise, returns 0.
+ */
 int pud_huge(pud_t pud)
 {
-	return !!(pud_val(pud) & _PAGE_PSE);
+	return !pud_none(pud) &&
+		(pud_val(pud) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
--- a/mm/hugetlb.c~mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry
+++ a/mm/hugetlb.c
@@ -6993,10 +6993,38 @@ struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 		pud_t *pud, int flags)
 {
-	if (flags & (FOLL_GET | FOLL_PIN))
+	struct page *page = NULL;
+	spinlock_t *ptl;
+	pte_t pte;
+
+	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
-	return pte_page(*(pte_t *)pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
+retry:
+	ptl = huge_pte_lock(hstate_sizelog(PUD_SHIFT), mm, (pte_t *)pud);
+	if (!pud_huge(*pud))
+		goto out;
+	pte = huge_ptep_get((pte_t *)pud);
+	if (pte_present(pte)) {
+		page = pud_page(*pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
+		if (WARN_ON_ONCE(!try_grab_page(page, flags))) {
+			page = NULL;
+			goto out;
+		}
+	} else {
+		if (is_hugetlb_entry_migration(pte)) {
+			spin_unlock(ptl);
+			__migration_entry_wait(mm, (pte_t *)pud, ptl);
+			goto retry;
+		}
+		/*
+		 * hwpoisoned entry is treated as no_page_table in
+		 * follow_page_mask().
+		 */
+	}
+out:
+	spin_unlock(ptl);
+	return page;
 }
 
 struct page * __weak
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

