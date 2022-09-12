Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76036ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiILDca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiILDa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C73CCE06
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E43A6119D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9616EC433D7;
        Mon, 12 Sep 2022 03:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953374;
        bh=viZ3jGeQWrkElP762OOjvc14Q02RhZubviDTRLTGjjY=;
        h=Date:To:From:Subject:From;
        b=SMCj4jb9o3RbbAiJnMn/EjxRn/Sy9OylWOtY+KwicPY8LGNW4wWJx5lfhyfdKx+qu
         Wp7Nzs/6oejDLLEczI2czXrbOaSP3A/lySLjxgQNdCWf2N72kmYhiSON6V8ox3yBDr
         JVqXR3hlmE2J7TSJlbPCQXsU20H4CHwRpYOlWYJ8=
Date:   Sun, 11 Sep 2022 20:29:33 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch removed from -mm tree
Message-Id: <20220912032934.9616EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: remove redundant pgtable check in set_huge_zero_page()
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: remove redundant pgtable check in set_huge_zero_page()
Date: Thu, 18 Aug 2022 16:27:48 +0800

When the pgtable is NULL in the set_huge_zero_page(), we should not
increment the count of PTE page table pages by calling mm_inc_nr_ptes(). 
Otherwise we may receive the following warning when the mm exits:

	BUG: non-zero pgtables_bytes on freeing mm

Now we can't observe the above warning since only
do_huge_pmd_anonymous_page() invokes set_huge_zero_page() and the pgtable
can not be NULL.

Therefore, instead of moving mm_inc_nr_ptes() to the non-NULL branch of
pgtable, it is better to remove the redundant pgtable check directly.

Link: https://lkml.kernel.org/r/20220818082748.40021-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page
+++ a/mm/huge_memory.c
@@ -770,8 +770,7 @@ static void set_huge_zero_page(pgtable_t
 		return;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
-	if (pgtable)
-		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot-fix.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch

