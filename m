Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518EFECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiILDfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiILDdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FBD29CB5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDF2611AD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31B4C433C1;
        Mon, 12 Sep 2022 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953440;
        bh=ZYslhj+J+JOrRiO+WNFppeFKyHVAW+ZXexoNsO8ElRM=;
        h=Date:To:From:Subject:From;
        b=rBp2uknhZcIv01iZZBGMRZLgGyXr1JwcFqKs4LaIjIKHiBnQrvnFHnlAptCIQ4Z7A
         oyFaaOcELlNe35FmpRCD3FBHpqHQZuZZc5CHHGm1YklMTV2xXGMqbz6TdOKARp6/Vq
         BdgTIaXrH5ibpFMJ7KyoDJZKjETquJsS3N3OPJF4=
Date:   Sun, 11 Sep 2022 20:30:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-make-hugetlb_cma_check-static.patch removed from -mm tree
Message-Id: <20220912033040.A31B4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: make hugetlb_cma_check() static
has been removed from the -mm tree.  Its filename was
     hugetlb-make-hugetlb_cma_check-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: make hugetlb_cma_check() static
Date: Thu, 1 Sep 2022 20:00:21 +0800

Patch series "A few cleanup patches for hugetlb", v2.

This series contains a few cleanup patches to use helper functions to
simplify the codes, remove unneeded nid parameter and so on. More
details can be found in the respective changelogs.


This patch (of 10):

Make hugetlb_cma_check() static as it's only used inside mm/hugetlb.c.

Link: https://lkml.kernel.org/r/20220901120030.63318-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220901120030.63318-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ----
 mm/hugetlb.c            |   10 +++++++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-make-hugetlb_cma_check-static
+++ a/include/linux/hugetlb.h
@@ -1123,14 +1123,10 @@ static inline spinlock_t *huge_pte_lock(
 
 #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
 extern void __init hugetlb_cma_reserve(int order);
-extern void __init hugetlb_cma_check(void);
 #else
 static inline __init void hugetlb_cma_reserve(int order)
 {
 }
-static inline __init void hugetlb_cma_check(void)
-{
-}
 #endif
 
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
--- a/mm/hugetlb.c~hugetlb-make-hugetlb_cma_check-static
+++ a/mm/hugetlb.c
@@ -4030,6 +4030,14 @@ static void hugetlb_register_all_nodes(v
 
 #endif
 
+#ifdef CONFIG_CMA
+static void __init hugetlb_cma_check(void);
+#else
+static inline __init void hugetlb_cma_check(void)
+{
+}
+#endif
+
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -7361,7 +7369,7 @@ void __init hugetlb_cma_reserve(int orde
 		hugetlb_cma_size = 0;
 }
 
-void __init hugetlb_cma_check(void)
+static void __init hugetlb_cma_check(void)
 {
 	if (!hugetlb_cma_size || cma_reserve_called)
 		return;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

