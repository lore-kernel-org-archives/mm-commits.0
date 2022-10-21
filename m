Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE11DC38A2D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJUUFT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJUUFR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:05:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF284EE897
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE17EB82CF8
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776BDC433C1;
        Fri, 21 Oct 2022 20:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382712;
        bh=H4pOlTKc+5yqf2ER8RMfGH4SI/jq0tYZ7LxUlx3dihU=;
        h=Date:To:From:Subject:From;
        b=HMzDl2PwBTIQWDGHPGQFTx0o5RT1rzeFCpDMehUWPmz6p2Y6I2tFK/s+Newlr7Jgd
         cs8TpjCp0UgxUU2OOO5v2GG/HLXgZJPg7XIcoHRXevuH3LhEMAQWdKZpsm+ExkkYy3
         uzsSMt64QsO2XHbR9+aZhreEo1SpRheIJqIxO2OU=
Date:   Fri, 21 Oct 2022 13:05:11 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-make-put_ref_page-more-useful.patch added to mm-unstable branch
Message-Id: <20221021200512.776BDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: make put_ref_page() more useful
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-make-put_ref_page-more-useful.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-make-put_ref_page-more-useful.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: make put_ref_page() more useful
Date: Fri, 21 Oct 2022 16:46:09 +0800

Pass pfn/flags to put_ref_page(), then check MF_COUNT_INCREASED and drop
refcount to make the code look cleaner.

Link: https://lkml.kernel.org/r/20221021084611.53765-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-put_ref_page-more-useful
+++ a/mm/memory-failure.c
@@ -1913,17 +1913,25 @@ static inline unsigned long free_raw_hwp
 }
 #endif	/* CONFIG_HUGETLB_PAGE */
 
+/* Drop the extra refcount in case we come from madvise() */
+static void put_ref_page(unsigned long pfn, int flags)
+{
+	struct page *page;
+
+	if (!(flags & MF_COUNT_INCREASED))
+		return;
+
+	page = pfn_to_page(pfn);
+	if (page)
+		put_page(page);
+}
+
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
 	int rc = -ENXIO;
 
-	if (flags & MF_COUNT_INCREASED)
-		/*
-		 * Drop the extra refcount in case we come from madvise().
-		 */
-		put_page(page);
+	put_ref_page(pfn, flags);
 
 	/* device metadata space is not recoverable */
 	if (!pgmap_pfn_valid(pgmap, pfn))
@@ -2516,12 +2524,6 @@ static int soft_offline_in_use_page(stru
 	return ret;
 }
 
-static void put_ref_page(struct page *page)
-{
-	if (page)
-		put_page(page);
-}
-
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
@@ -2550,19 +2552,17 @@ int soft_offline_page(unsigned long pfn,
 {
 	int ret;
 	bool try_again = true;
-	struct page *page, *ref_page = NULL;
+	struct page *page;
 
 	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
-	if (flags & MF_COUNT_INCREASED)
-		ref_page = pfn_to_page(pfn);
 
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
 	if (!page) {
-		put_ref_page(ref_page);
+		put_ref_page(pfn, flags);
 		return -EIO;
 	}
 
@@ -2570,7 +2570,7 @@ int soft_offline_page(unsigned long pfn,
 
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
-		put_ref_page(ref_page);
+		put_ref_page(pfn, flags);
 		mutex_unlock(&mf_mutex);
 		return 0;
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch
mm-memory-failure-make-put_ref_page-more-useful.patch
mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch
mm-memory-failure-make-action_result-return-int.patch

