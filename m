Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49276C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjASBUM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjASBS2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F84689DE
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4527B61B20
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C38FC433EF;
        Thu, 19 Jan 2023 01:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090953;
        bh=e49I1/mdzOlLPJ0udhvdHWjC9TPQyruBT+awtgM+PA8=;
        h=Date:To:From:Subject:From;
        b=kk9cVQQtI+wLQR9rFd3wRGuykSyauJOswU5Nc6EFlGSoxc5Vy1P+xuNrmjNXQww3z
         BO+UNC5AuXjtTxyVST4CRibwa27pwY5tRXNjScKIMrI38lXbeQtVMm3Jv2toSxmBPE
         TV99iImvxG0LCWEyGBwyCK4ZuPoG6Q53QkTnqlI0=
Date:   Wed, 18 Jan 2023 17:15:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-introduce-damon_get_folio.patch removed from -mm tree
Message-Id: <20230119011553.9C38FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: introduce damon_get_folio()
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon: introduce damon_get_folio()
Date: Fri, 30 Dec 2022 15:08:44 +0800

Introduce damon_get_folio(), and the temporary wrapper function
damon_get_page(), which help us to convert damon related functions to use
folios, and it will be dropped once the conversion is completed.

Link: https://lkml.kernel.org/r/20221230070849.63358-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   18 +++++++++++-------
 mm/damon/ops-common.h |    9 ++++++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-introduce-damon_get_folio
+++ a/mm/damon/ops-common.c
@@ -16,21 +16,25 @@
  * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
  * NULL.
  *
- * The body of this function is stolen from the 'page_idle_get_page()'.  We
+ * The body of this function is stolen from the 'page_idle_get_folio()'.  We
  * steal rather than reuse it because the code is quite simple.
  */
-struct page *damon_get_page(unsigned long pfn)
+struct folio *damon_get_folio(unsigned long pfn)
 {
 	struct page *page = pfn_to_online_page(pfn);
+	struct folio *folio;
 
-	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
+	if (!page || PageTail(page))
 		return NULL;
 
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
+	folio = page_folio(page);
+	if (!folio_test_lru(folio) || !folio_try_get(folio))
+		return NULL;
+	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+		folio_put(folio);
+		folio = NULL;
 	}
-	return page;
+	return folio;
 }
 
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr)
--- a/mm/damon/ops-common.h~mm-damon-introduce-damon_get_folio
+++ a/mm/damon/ops-common.h
@@ -7,7 +7,14 @@
 
 #include <linux/damon.h>
 
-struct page *damon_get_page(unsigned long pfn);
+struct folio *damon_get_folio(unsigned long pfn);
+static inline struct page *damon_get_page(unsigned long pfn)
+{
+	struct folio *folio = damon_get_folio(pfn);
+
+	/* when folio is NULL, return &(0->page) mean return NULL */
+	return &folio->page;
+}
 
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

