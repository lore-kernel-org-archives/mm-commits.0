Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C512AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiGHAyY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbiGHAyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D3770E75
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C20560AF9
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D57C341C0;
        Fri,  8 Jul 2022 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657241660;
        bh=0zhKw67azLAML2nVaApBpfhnEEYNdC21KP2Fz3v/gOA=;
        h=Date:To:From:Subject:From;
        b=RsxnC3woF1TeOZa4IIFp4a/SDMHixkNsU3rgnOISOFoieu8EsAggv71SlNo2ZWAyG
         kHBbu1iLdwevjnYBkhW3rfmg3dyJO9RRwI9zfdIxl1i0Ijc2WiZ987VTFz5t3kJFh8
         3ZepZw4Kkw3THo7ampakGPNSNjeOavchBwXaxkAs=
Date:   Thu, 07 Jul 2022 17:54:20 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch removed from -mm tree
Message-Id: <20220708005420.C5D57C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch

This patch was dropped because an updated version will be merged

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
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
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
@@ -6994,10 +6994,38 @@ struct page * __weak
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

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

