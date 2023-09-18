Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FF9CD13D8
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 15:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjIRPqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjIRPqR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 11:46:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7092700
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 08:43:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838A3C433CB;
        Mon, 18 Sep 2023 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695051664;
        bh=PzhbLDeimZ+S5dvX2Q1QAiVb0/mn5fkLtv56CIvPMlg=;
        h=Date:To:From:Subject:From;
        b=dE2A87ITZa9JwPd3lZVoAhvc0CbnGEEhSGgdbY8itF5Y98xTBnW96W+xDzl+w0E+f
         yTwZ1LH+MDItslIbps2od6U7Ol+GuvsBKaDKLMN8AsG26px0AOlbQLv2OrEUL3CYyB
         hkuELbJAw7//5Wm+8A4f0uaNO+EWfhobnVvFk/CE=
Date:   Mon, 18 Sep 2023 08:41:03 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org, shy828301@gmail.com,
        ryan.roberts@arm.com, hughd@google.com, david@redhat.com,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-update-mlock_pte_range-to-handle-large-folio.patch added to mm-unstable branch
Message-Id: <20230918154104.838A3C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: update mlock_pte_range to handle large folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-update-mlock_pte_range-to-handle-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-update-mlock_pte_range-to-handle-large-folio.patch

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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm: mlock: update mlock_pte_range to handle large folio
Date: Mon, 18 Sep 2023 15:33:18 +0800

Current kernel only lock base size folio during mlock syscall.
Add large folio support with following rules:
  - Only mlock large folio when it's in VM_LOCKED VMA range
    and fully mapped to page table.

    fully mapped folio is required as if folio is not fully
    mapped to a VM_LOCKED VMA, if system is in memory pressure,
    page reclaim is allowed to pick up this folio, split it
    and reclaim the pages which are not in VM_LOCKED VMA.

  - munlock will apply to the large folio which is in VMA range
    or cross the VMA boundary.

    This is required to handle the case that the large folio is
    mlocked, later the VMA is split in the middle of large folio.

Link: https://lkml.kernel.org/r/20230918073318.1181104-4-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

--- a/mm/mlock.c~mm-mlock-update-mlock_pte_range-to-handle-large-folio
+++ a/mm/mlock.c
@@ -305,6 +305,58 @@ void munlock_folio(struct folio *folio)
 	local_unlock(&mlock_fbatch.lock);
 }
 
+static inline unsigned int folio_mlock_step(struct folio *folio,
+		pte_t *pte, unsigned long addr, unsigned long end)
+{
+	unsigned int count, i, nr = folio_nr_pages(folio);
+	unsigned long pfn = folio_pfn(folio);
+	pte_t ptent = ptep_get(pte);
+
+	if (!folio_test_large(folio))
+		return 1;
+
+	count = pfn + nr - pte_pfn(ptent);
+	count = min_t(unsigned int, count, (end - addr) >> PAGE_SHIFT);
+
+	for (i = 0; i < count; i++, pte++) {
+		pte_t entry = ptep_get(pte);
+
+		if (!pte_present(entry))
+			break;
+		if (pte_pfn(entry) - pfn >= nr)
+			break;
+	}
+
+	return i;
+}
+
+static inline bool allow_mlock_munlock(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, unsigned int step)
+{
+	/*
+	 * For unlock, allow munlock large folio which is partially
+	 * mapped to VMA. As it's possible that large folio is
+	 * mlocked and VMA is split later.
+	 *
+	 * During memory pressure, such kind of large folio can
+	 * be split. And the pages are not in VM_LOCKed VMA
+	 * can be reclaimed.
+	 */
+	if (!(vma->vm_flags & VM_LOCKED))
+		return true;
+
+	/* folio not in range [start, end), skip mlock */
+	if (!folio_within_range(folio, vma, start, end))
+		return false;
+
+	/* folio is not fully mapped, skip mlock */
+	if (step != folio_nr_pages(folio))
+		return false;
+
+	return true;
+}
+
 static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			   unsigned long end, struct mm_walk *walk)
 
@@ -314,6 +366,8 @@ static int mlock_pte_range(pmd_t *pmd, u
 	pte_t *start_pte, *pte;
 	pte_t ptent;
 	struct folio *folio;
+	unsigned int step = 1;
+	unsigned long start = addr;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -334,6 +388,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
+
 	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = ptep_get(pte);
 		if (!pte_present(ptent))
@@ -341,12 +396,19 @@ static int mlock_pte_range(pmd_t *pmd, u
 		folio = vm_normal_folio(vma, addr, ptent);
 		if (!folio || folio_is_zone_device(folio))
 			continue;
-		if (folio_test_large(folio))
-			continue;
+
+		step = folio_mlock_step(folio, pte, addr, end);
+		if (!allow_mlock_munlock(folio, vma, start, end, step))
+			goto next_entry;
+
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
+
+next_entry:
+		pte += step - 1;
+		addr += (step - 1) << PAGE_SHIFT;
 	}
 	pte_unmap(start_pte);
 out:
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_order0_folio-to-handle-order0-folio.patch
mm-add-functions-folio_in_range-and-folio_within_vma.patch
mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range.patch
mm-mlock-update-mlock_pte_range-to-handle-large-folio.patch

