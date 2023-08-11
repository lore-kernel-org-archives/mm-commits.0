Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB21C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjHKWah (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjHKWag (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DD9CE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6C265754
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E9C433C7;
        Fri, 11 Aug 2023 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793035;
        bh=7q9qnRpdxPK+RyYbNYjbeubsHBrTWsNjyO8F89S3fyM=;
        h=Date:To:From:Subject:From;
        b=IN8LUW5UK7JLoplvuRcEoXHoQFnrzO84f/CSxqz42MMfl/c1vkuBZwQiQt3Qd3Je4
         f6OPt3B1NfFc+PsafHjB8ptHbI/e98Vo2e2da6R1+oq3bh5uwFE1c0KcEepjl4TePk
         X9VzIik4X4LDHxAg/AM1ETE5I8uUoFrKRJV5lkf4=
Date:   Fri, 11 Aug 2023 15:30:34 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch removed from -mm tree
Message-Id: <20230811223035.854E9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock(): fix2
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2.patch

This patch was dropped because it was folded into mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock(): fix2
Date: Sat, 5 Aug 2023 20:59:27 -0700 (PDT)

Use ptep_clear() instead of pte_clear(): when CONFIG_PAGE_TABLE_CHECK=y,
ptep_clear() adds some accounting, missing which would cause a BUG later.

Link: https://lkml.kernel.org/r/e0197433-8a47-6a65-534d-eda26eeb78b0@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Closes: https://lore.kernel.org/linux-mm/0df84f9f-e9b0-80b1-4c9e-95abc1a73a96@bytedance.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix2
+++ a/mm/khugepaged.c
@@ -1655,7 +1655,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		pte_clear(mm, addr, pte);
+		ptep_clear(mm, addr, pte);
 		page_remove_rmap(page, vma, false);
 		nr_ptes++;
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

