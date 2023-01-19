Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF877C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjASBUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjASBS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F94F6923D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D40A2B81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74111C433F0;
        Thu, 19 Jan 2023 01:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090959;
        bh=IzhFvsPXHgIQ2mRtm3ahp5Q1hyiKT775sftP+3BvY+E=;
        h=Date:To:From:Subject:From;
        b=mtDR3ov5pt4FNzjhBzScW3134jH3nldzQR9qZBhVyvpOR9kUFYTkrXxQHEDMXwZ2W
         FYkvbT2qrd3JSLnAnq4JtURBEhdJVz03cwBi7l1ad+3FDx4hrOAdLaSG5s0yAamNPf
         JOS9qHKO/G0DswvmRlarz5po0U75t1+3GsbQryck=
Date:   Wed, 18 Jan 2023 17:15:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-unneeded-damon_get_page.patch removed from -mm tree
Message-Id: <20230119011559.74111C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: remove unneeded damon_get_page()
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unneeded-damon_get_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon: remove unneeded damon_get_page()
Date: Fri, 30 Dec 2022 15:08:48 +0800

After all damon_get_page() callers are converted to damon_get_folio(),
remove unneeded wrapper damon_get_page().

Link: https://lkml.kernel.org/r/20221230070849.63358-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/damon/ops-common.h~mm-damon-remove-unneeded-damon_get_page
+++ a/mm/damon/ops-common.h
@@ -8,13 +8,6 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
-static inline struct page *damon_get_page(unsigned long pfn)
-{
-	struct folio *folio = damon_get_folio(pfn);
-
-	/* when folio is NULL, return &(0->page) mean return NULL */
-	return &folio->page;
-}
 
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

