Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F5EC27C47
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjJYXth (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbjJYXsv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768A6183
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41110C43391;
        Wed, 25 Oct 2023 23:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277729;
        bh=wFW0ObXiQkn8FXwKMH+e6bnvxXMGi1rR7i/MQetVEVM=;
        h=Date:To:From:Subject:From;
        b=KvirJ9XXDHwsBAgJV7QBDps5T3Wvrbkmc7DaMiCwJ99HdxoXkAnDdWUL2MFhxJY6X
         18qui3wV4pYc54CKFEkgbmEm1ua9gW+LLBXVvRk92mvlFzm5G4yMgk4EQwjquB5poc
         OCq+JHCjUyypWp9sEM0xHRpxZKsc1Bs0NbR0fODk=
Date:   Wed, 25 Oct 2023 16:48:48 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch removed from -mm tree
Message-Id: <20231025234849.41110C43391@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use folio_xchg_last_cpupid() in wp_page_reuse()
has been removed from the -mm tree.  Its filename was
     mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use folio_xchg_last_cpupid() in wp_page_reuse()
Date: Wed, 18 Oct 2023 22:08:05 +0800

Convert to use folio_xchg_last_cpupid() in wp_page_reuse(), and remove
page variable. Since now only normal and PMD-mapped page is handled by
numa balancing, it's enough to only update the entire folio's last cpupid.

Link: https://lkml.kernel.org/r/20231018140806.2783514-19-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-use-folio_xchg_last_cpupid-in-wp_page_reuse
+++ a/mm/memory.c
@@ -3019,19 +3019,20 @@ static inline void wp_page_reuse(struct
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = vmf->page;
 	pte_t entry;
 
 	VM_BUG_ON(!(vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(folio && folio_test_anon(folio) && !PageAnonExclusive(page));
 
-	/*
-	 * Clear the pages cpupid information as the existing
-	 * information potentially belongs to a now completely
-	 * unrelated process.
-	 */
-	if (page)
-		page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
+	if (folio) {
+		VM_BUG_ON(folio_test_anon(folio) &&
+			  !PageAnonExclusive(vmf->page));
+		/*
+		 * Clear the folio's cpupid information as the existing
+		 * information potentially belongs to a now completely
+		 * unrelated process.
+		 */
+		folio_xchg_last_cpupid(folio, (1 << LAST_CPUPID_SHIFT) - 1);
+	}
 
 	flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 	entry = pte_mkyoung(vmf->orig_pte);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


