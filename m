Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0BCC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJLW6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiJLW6E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB81285E0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF21EB819BB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74824C433C1;
        Wed, 12 Oct 2022 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615460;
        bh=U8y3Klk59Fk2QWMIEXwySHXdY7IdPMicQjz4T5LgrUo=;
        h=Date:To:From:Subject:From;
        b=oNDC58jEbN/gBRMz8ZJwRvu4C7jFBT1uTx4iwH41YnG1sUZMsai0eqQV3u4tNBOt0
         4AnN3YJVHFxHJc9jcbhhOca/3/gTSGi/fGvubMJALzcLM9pwGc+n9dtO+fYQYm5iX9
         CM6yXhaOEzNRbgcnM70evaNvbPOPT+Ggfghmqj64=
Date:   Wed, 12 Oct 2022 15:57:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        maobibo@loongson.cn, jcmvbkbc@gmail.com, david@redhat.com,
        chris@zankel.net, chenhuacai@loongson.cn,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-update_mmu_tlb-on-the-second-thread.patch removed from -mm tree
Message-Id: <20221012225740.74824C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use update_mmu_tlb() on the second thread
has been removed from the -mm tree.  Its filename was
     mm-use-update_mmu_tlb-on-the-second-thread.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: use update_mmu_tlb() on the second thread
Date: Thu, 29 Sep 2022 19:23:17 +0800

As message in commit 7df676974359 ("mm/memory.c: Update local TLB if PTE
entry exists") said, we should update local TLB only on the second thread.
So in the do_anonymous_page() here, we should use update_mmu_tlb()
instead of update_mmu_cache() on the second thread.

As David pointed out, this is a performance improvement, not a
correctness fix.

Link: https://lkml.kernel.org/r/20220929112318.32393-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-use-update_mmu_tlb-on-the-second-thread
+++ a/mm/memory.c
@@ -4134,7 +4134,7 @@ static vm_fault_t do_anonymous_page(stru
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 	if (!pte_none(*vmf->pte)) {
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_tlb(vma, vmf->address, vmf->pte);
 		goto release;
 	}
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

loongarch-update-local-tlb-if-pte-entry-exists.patch

