Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F41BC43219
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJLW6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiJLW6K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25001285E3
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F341EB81BDD
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A442BC433D6;
        Wed, 12 Oct 2022 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615461;
        bh=lMMIrMoxCKuq4gdjjmiS/gBA5HQsmAsLfSLZk4nQARY=;
        h=Date:To:From:Subject:From;
        b=IFr6LrnbEA2TJSHO2A1Ks9ytB8PX6AYXjhCwaEpvp1Cs3L2rso2yRvAQmVOOhSKH4
         fuY9pY6IuUt4lMEr7loKzvLsZ+9CcnCHDpKAI/DEWfvo3j076H+FFsFZabsoWQ8AVH
         UqS7bJ4bGw5AgzGuTvRhei1TPxWN+z50RitXwNK0=
Date:   Wed, 12 Oct 2022 15:57:40 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        maobibo@loongson.cn, jcmvbkbc@gmail.com, david@redhat.com,
        chris@zankel.net, chenhuacai@loongson.cn,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-update-local-tlb-if-pte-entry-exists.patch removed from -mm tree
Message-Id: <20221012225741.A442BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: LoongArch: update local TLB if PTE entry exists
has been removed from the -mm tree.  Its filename was
     loongarch-update-local-tlb-if-pte-entry-exists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 arch/loongarch/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

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


