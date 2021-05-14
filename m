Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA76FC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9442861440
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhENWNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230024AbhENWNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:13:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3E0661453;
        Fri, 14 May 2021 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621030343;
        bh=l+5cqCO1U5td6fhlB8RNmG//+N2qF+YxehSxZjHU2tk=;
        h=Date:From:To:Subject:From;
        b=x455DiwBig8BoKri4IAFMLGiRlGmUqRZeGSH+zkYKGf8nZ2lIfEEwyqjDfQ1r+kbO
         22SlaxEcgNNVJXQUjuyarKYNLsOMsDY1Dv9gZm2t1jz0HsUOgFa+hZZum/sdjerN1W
         YWn0uQO0/W1QA+HivcN2FTP/XgGSvN7lwsm8Ywlo=
Date:   Fri, 14 May 2021 15:12:23 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-huge=5Fmemoryc-add-missing-read-only-thp-checking-in-t?=
 =?US-ASCII?Q?ransparent=5Fhugepage=5Fenabled-v4.patch?= added to -mm tree
Message-ID: <20210514221223.2dG2XZ2tu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch

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
Subject: mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4

define transhuge_vma_enabled next to transhuge_vma_suitable

Link: https://lkml.kernel.org/r/20210514093007.4117906-1-linmiaohe@huawei.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4
+++ a/include/linux/huge_mm.h
@@ -115,6 +115,21 @@ extern struct kobj_attribute shmem_enabl
 
 extern unsigned long transparent_hugepage_flags;
 
+static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
+		unsigned long haddr)
+{
+	/* Don't have to check pgoff for anonymous vma */
+	if (!vma_is_anonymous(vma)) {
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
+			return false;
+	}
+
+	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
+		return false;
+	return true;
+}
+
 static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
 					  unsigned long vm_flags)
 {
@@ -159,21 +174,6 @@ static inline bool __transparent_hugepag
 
 bool transparent_hugepage_active(struct vm_area_struct *vma);
 
-static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
-{
-	/* Don't have to check pgoff for anonymous vma */
-	if (!vma_is_anonymous(vma)) {
-		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR))
-			return false;
-	}
-
-	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
-		return false;
-	return true;
-}
-
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch

