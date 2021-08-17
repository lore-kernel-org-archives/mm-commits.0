Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6386C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 925C460F35
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhHQBSq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 21:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhHQBSo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 21:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8810B60ED5;
        Tue, 17 Aug 2021 01:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629163092;
        bh=+3UTn59kT2jdz8NFmiYhLW4JOxyWQOoDiUMMsp0Gn28=;
        h=Date:From:To:Subject:From;
        b=rqQoMG10DxnntWwtOI9UaYPHru2S31NIw5bhWEbBw1cuzURlvZfF+tBvJbmKmJ/Wg
         yFiVnl5u8cRy6yG20R8Af+v0tcnweWwXvS4jvjywU6ATCbmP5fHzZGFmbJ5e8igZoD
         M40jMnUg+u11w+AnApMdznEWTjeDGwrYrkpMdX0g=
Date:   Mon, 16 Aug 2021 18:18:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com
Subject:  +
 mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch added to -mm tree
Message-ID: <20210817011812.UMAEl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix potential pte_unmap_unlock pte error
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: fix potential pte_unmap_unlock pte error

If the first pte is equal to poisoned_pfn, i.e.  check_hwpoisoned_entry()
return 1, the wrong ptep - 1 would be passed to pte_unmap_unlock().

Link: https://lkml.kernel.org/r/20210814105131.48814-3-linmiaohe@huawei.com
Fixes: ad9c59c24095 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/memory-failure.c
@@ -632,7 +632,7 @@ static int hwpoison_pte_range(pmd_t *pmd
 {
 	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
 	int ret = 0;
-	pte_t *ptep;
+	pte_t *ptep, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmdp, walk->vma);
@@ -645,14 +645,15 @@ static int hwpoison_pte_range(pmd_t *pmd
 	if (pmd_trans_unstable(pmdp))
 		goto out;
 
-	ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp, addr, &ptl);
+	mapped_pte = ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp,
+						addr, &ptl);
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		ret = check_hwpoisoned_entry(*ptep, addr, PAGE_SHIFT,
 					     hwp->pfn, &hwp->tk);
 		if (ret == 1)
 			break;
 	}
-	pte_unmap_unlock(ptep - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 out:
 	cond_resched();
 	return ret;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

