Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC9DC001B3
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 17:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjGCRi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjGCRi6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jul 2023 13:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6763E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 10:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC8760FEF
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 17:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2283C433C7;
        Mon,  3 Jul 2023 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688405936;
        bh=46Qso/1IOtnqCLd7Ql0uessHykF45N/dEsMYH9asLeM=;
        h=Date:To:From:Subject:From;
        b=BvHIJLr0lisqquP5+9f35j24L54QYCYxf3McGfsaYNjYh7B4/gAECxhmxbzJYHkQe
         Be2hkpd/LkNaMumEW2kiTf7h/rD97BjaeJx3kszGLhem73R8CgHzmAjJFnAUsQypRF
         CdUE+IPtYa04wOKNXfex3c6MbkJZmQKgFj3qBEoI=
Date:   Mon, 03 Jul 2023 10:38:56 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-support-unsharing-ksm-placed-zero-pages.patch added to mm-unstable branch
Message-Id: <20230703173856.A2283C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: support unsharing KSM-placed zero pages
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-support-unsharing-ksm-placed-zero-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-support-unsharing-ksm-placed-zero-pages.patch

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: support unsharing KSM-placed zero pages
Date: Tue, 13 Jun 2023 11:09:28 +0800

Patch series "ksm: support tracking KSM-placed zero-pages", v10.

The core idea of this patch set is to enable users to perceive the number
of any pages merged by KSM, regardless of whether use_zero_page switch has
been turned on, so that users can know how much free memory increase is
really due to their madvise(MERGEABLE) actions.  But the problem is, when
enabling use_zero_pages, all empty pages will be merged with kernel zero
pages instead of with each other as use_zero_pages is disabled, and then
these zero-pages are no longer monitored by KSM.

The motivations to do this is seen at:
https://lore.kernel.org/lkml/202302100915227721315@zte.com.cn/

In one word, we hope to implement the support for KSM-placed zero pages
tracking without affecting the feature of use_zero_pages, so that app
developer can also benefit from knowing the actual KSM profit by getting
KSM-placed zero pages to optimize applications eventually when
/sys/kernel/mm/ksm/use_zero_pages is enabled.


This patch (of 5):

When use_zero_pages of ksm is enabled, madvise(addr, len,
MADV_UNMERGEABLE) and other ways (like write 2 to /sys/kernel/mm/ksm/run)
to trigger unsharing will *not* actually unshare the shared zeropage as
placed by KSM (which is against the MADV_UNMERGEABLE documentation).  As
these KSM-placed zero pages are out of the control of KSM, the related
counts of ksm pages don't expose how many zero pages are placed by KSM
(these special zero pages are different from those initially mapped zero
pages, because the zero pages mapped to MADV_UNMERGEABLE areas are
expected to be a complete and unshared page).

To not blindly unshare all shared zero_pages in applicable VMAs, the patch
use pte_mkdirty (related with architecture) to mark KSM-placed zero pages.
Thus, MADV_UNMERGEABLE will only unshare those KSM-placed zero pages.

In addition, we'll reuse this mechanism to reliably identify KSM-placed
ZeroPages to properly account for them (e.g., calculating the KSM profit
that includes zeropages) in the latter patches.

The patch will not degrade the performance of use_zero_pages as it doesn't
change the way of merging empty pages in use_zero_pages's feature.

Link: https://lkml.kernel.org/r/202306131104554703428@zte.com.cn
Link: https://lkml.kernel.org/r/20230613030928.185882-1-yang.yang29@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    6 ++++++
 mm/ksm.c            |   11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/ksm.h~ksm-support-unsharing-ksm-placed-zero-pages
+++ a/include/linux/ksm.h
@@ -26,6 +26,12 @@ int ksm_disable(struct mm_struct *mm);
 
 int __ksm_enter(struct mm_struct *mm);
 void __ksm_exit(struct mm_struct *mm);
+/*
+ * To identify zeropages that were mapped by KSM, we reuse the dirty bit
+ * in the PTE. If the PTE is dirty, the zeropage was mapped by KSM when
+ * deduplicating memory.
+ */
+#define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
--- a/mm/ksm.c~ksm-support-unsharing-ksm-placed-zero-pages
+++ a/mm/ksm.c
@@ -448,7 +448,8 @@ static int break_ksm_pmd_entry(pmd_t *pm
 		if (is_migration_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 	}
-	ret = page && PageKsm(page);
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	ret = (page && PageKsm(page)) || is_ksm_zero_pte(*pte);
 	pte_unmap_unlock(pte, ptl);
 	return ret;
 }
@@ -1222,8 +1223,12 @@ static int replace_page(struct vm_area_s
 		page_add_anon_rmap(kpage, vma, addr, RMAP_NONE);
 		newpte = mk_pte(kpage, vma->vm_page_prot);
 	} else {
-		newpte = pte_mkspecial(pfn_pte(page_to_pfn(kpage),
-					       vma->vm_page_prot));
+		/*
+		 * Use pte_mkdirty to mark the zero page mapped by KSM, and then
+		 * we can easily track all KSM-placed zero pages by checking if
+		 * the dirty bit in zero page's PTE is set.
+		 */
+		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
 		 * not anonymous. We need to do proper accounting otherwise we
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-support-unsharing-ksm-placed-zero-pages.patch
ksm-count-all-zero-pages-placed-by-ksm.patch
ksm-add-ksm-zero-pages-for-each-process.patch
ksm-consider-ksm-placed-zeropages-when-calculating-ksm-profit.patch
selftest-add-a-testcase-of-ksm-zero-pages.patch

