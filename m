Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC4CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbiI2OGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiI2OGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:06:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC141616CA
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4296614D1
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07770C433C1;
        Thu, 29 Sep 2022 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460398;
        bh=b/EZuimJ371gzOEJmEG/hMaMuailRmfU2TEFLyzTfjI=;
        h=Date:To:From:Subject:From;
        b=tWF32LqNdP52tYPaqKFx0D6kzB3YBqIL83WwD8uIgIynQn2r/QCozfZ65wroDRINr
         1LCZEcibWEKCOfYhSmiQxd+sYO6X0SFUCWEyRtqQg/kX5oFzvHzjHNMVlxVOJkemJ+
         MtEquxpFt7GhIm3DAsQ+T/TbJE/l8WD8RLQAH4SA=
Date:   Thu, 29 Sep 2022 07:06:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        maobibo@loongson.cn, jcmvbkbc@gmail.com, david@redhat.com,
        chris@zankel.net, chenhuacai@loongson.cn,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-update-local-tlb-if-pte-entry-exists.patch added to mm-unstable branch
Message-Id: <20220929140638.07770C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: LoongArch: update local TLB if PTE entry exists
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-update-local-tlb-if-pte-entry-exists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-update-local-tlb-if-pte-entry-exists.patch

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
Subject: LoongArch: update local TLB if PTE entry exists
Date: Thu, 29 Sep 2022 19:23:18 +0800

Currently, the implementation of update_mmu_tlb() is empty if
__HAVE_ARCH_UPDATE_MMU_TLB is not defined.  Then if two threads
concurrently fault at the same page, the second thread that did not win
the race will give up and do nothing.  In the LoongArch architecture, this
second thread will trigger another fault, and only updates its local TLB.

Instead of triggering another fault, it's better to implement
update_mmu_tlb() to directly update the local TLB of the second thread. 
Just do it.

Link: https://lkml.kernel.org/r/20220929112318.32393-3-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/loongarch/include/asm/pgtable.h~loongarch-update-local-tlb-if-pte-entry-exists
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -412,6 +412,9 @@ static inline void update_mmu_cache(stru
 	__update_tlb(vma, address, ptep);
 }
 
+#define __HAVE_ARCH_UPDATE_MMU_TLB
+#define update_mmu_tlb	update_mmu_cache
+
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmdp)
 {
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

