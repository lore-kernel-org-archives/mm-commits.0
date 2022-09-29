Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF80EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiI2OGk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiI2OGj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:06:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E02160E51
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88FEA614CB
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37B6C433D6;
        Thu, 29 Sep 2022 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460396;
        bh=y11YjNXQPuT499jUdPZNFO+dh2VPrVdu3MS2/8/zXT0=;
        h=Date:To:From:Subject:From;
        b=PoBhv20iTOXRxWff7rtytX39XNE6E4zqnu/Qna5qRt7wj48D8XrcMHvc26wxICBmM
         VEVRNBpShs52vOjaH1HZkDReb2b+qusXT5jBX9czliMkiXmo8yvUXLDg1ASOq77TKY
         iIrctv+wi5Jq3fJR4S3H9TSvP9FRPWHxLcirJU3U=
Date:   Thu, 29 Sep 2022 07:06:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        maobibo@loongson.cn, jcmvbkbc@gmail.com, david@redhat.com,
        chris@zankel.net, chenhuacai@loongson.cn,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-update_mmu_tlb-on-the-second-thread.patch added to mm-unstable branch
Message-Id: <20220929140635.C37B6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use update_mmu_tlb() on the second thread
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-update_mmu_tlb-on-the-second-thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-update_mmu_tlb-on-the-second-thread.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: use update_mmu_tlb() on the second thread
Date: Thu, 29 Sep 2022 19:23:17 +0800

As message in commit 7df676974359 ("mm/memory.c: Update local TLB if PTE
entry exists") said, we should update local TLB only on the second thread.
So in the do_anonymous_page() here, we should use update_mmu_tlb()
instead of update_mmu_cache() on the second thread.

Link: https://lkml.kernel.org/r/20220929112318.32393-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-use-update_mmu_tlb-on-the-second-thread
+++ a/mm/memory.c
@@ -4136,7 +4136,7 @@ static vm_fault_t do_anonymous_page(stru
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 	if (!pte_none(*vmf->pte)) {
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_tlb(vma, vmf->address, vmf->pte);
 		goto release;
 	}
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch
mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch

