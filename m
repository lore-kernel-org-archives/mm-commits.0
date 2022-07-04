Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ED3C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiGDBNM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiGDBMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:12:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649B62F5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86D7FB803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D5AC341C6;
        Mon,  4 Jul 2022 01:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897063;
        bh=iBD+FuWqyWPuMHdME5cXyoxoigPcvEXhCRhxPSfHd4s=;
        h=Date:To:From:Subject:From;
        b=sJrKLgl/1z8T3CNgjgPCiPjS7qHw9tlF9BxY2ra0axl4kDnF9ksbBhihyW5uboP10
         tdWslyI2hgr7mlQkIoA0KNJ4dhQfoW8EFWSBp/up0+b2rGoVtmlqrb1nQKKwv2str/
         mk1Bbdt8fWegzOhXaYqM6pYaQ3GqEGoJdXGwhTzg=
Date:   Sun, 03 Jul 2022 18:11:02 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch removed from -mm tree
Message-Id: <20220704011103.16D5AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: remove unneeded return value of khugepaged_add_pte_mapped_thp()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: remove unneeded return value of khugepaged_add_pte_mapped_thp()
Date: Sat, 25 Jun 2022 17:28:15 +0800

The return value of khugepaged_add_pte_mapped_thp() is always 0 and also
ignored.  Remove it to clean up the code.

Link: https://lkml.kernel.org/r/20220625092816.4856-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp
+++ a/mm/khugepaged.c
@@ -1371,8 +1371,8 @@ static void collect_mm_slot(struct mm_sl
  * Notify khugepaged that given addr of the mm is pte-mapped THP. Then
  * khugepaged should try to collapse the page table.
  */
-static int khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
-					 unsigned long addr)
+static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
+					  unsigned long addr)
 {
 	struct mm_slot *mm_slot;
 
@@ -1383,7 +1383,6 @@ static int khugepaged_add_pte_mapped_thp
 	if (likely(mm_slot && mm_slot->nr_pte_mapped_thp < MAX_PTE_MAPPED_THP))
 		mm_slot->pte_mapped_thp[mm_slot->nr_pte_mapped_thp++] = addr;
 	spin_unlock(&khugepaged_mm_lock);
-	return 0;
 }
 
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

