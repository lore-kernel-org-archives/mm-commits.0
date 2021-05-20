Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA4FC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095B9613E6
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhETUrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhETUrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB965613E1;
        Thu, 20 May 2021 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543552;
        bh=JQKHAvIUMnjPXJQoM5dgZmiCI12ElhmKXGKsCgbgY4A=;
        h=Date:From:To:Subject:From;
        b=SUx5zRgxfVZhqrIyvQPFpIYGu/Xwr84zUX0tCCAY7fmVWqDigyIJ+PMaigbVM/O1O
         NIoD9X7cWhjKj+z7yZtuMOILLrRGXH+gcGz1P1fWFyo3ySe1yinj1pMZ2Xf86HEEtm
         i51zhHndSnRDVq2L0YP2R04I8WYOfAnrdU04HsDg=
Date:   Thu, 20 May 2021 13:45:51 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch added
 to -mm tree
Message-ID: <20210520204551.hvTLxPR8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: move get_swap_page_of_type() under CONFIG_HIBERNATION
has been added to the -mm tree.  Its filename is
     mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch

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
Subject: mm/swapfile: move get_swap_page_of_type() under CONFIG_HIBERNATION

Patch series "Cleanups for swap", v2.

This series contains just cleanups to remove some unused variables, delete
meaningless forward declarations and so on.  More details can be found in
the respective changelogs.


This patch (of 4):

We should move get_swap_page_of_type() under CONFIG_HIBERNATION since the
only caller of this function is now suspend routine.

Link: https://lkml.kernel.org/r/20210520134022.1370406-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210520134022.1370406-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-move-get_swap_page_of_type-under-config_hibernation
+++ a/mm/swapfile.c
@@ -1137,30 +1137,6 @@ noswap:
 	return n_ret;
 }
 
-/* The only caller of this function is now suspend routine */
-swp_entry_t get_swap_page_of_type(int type)
-{
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
-	pgoff_t offset;
-
-	if (!si)
-		goto fail;
-
-	spin_lock(&si->lock);
-	if (si->flags & SWP_WRITEOK) {
-		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 1);
-		if (offset) {
-			atomic_long_dec(&nr_swap_pages);
-			spin_unlock(&si->lock);
-			return swp_entry(type, offset);
-		}
-	}
-	spin_unlock(&si->lock);
-fail:
-	return (swp_entry_t) {0};
-}
-
 static struct swap_info_struct *__swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
@@ -1812,6 +1788,30 @@ int free_swap_and_cache(swp_entry_t entr
 }
 
 #ifdef CONFIG_HIBERNATION
+
+swp_entry_t get_swap_page_of_type(int type)
+{
+	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	pgoff_t offset;
+
+	if (!si)
+		goto fail;
+
+	spin_lock(&si->lock);
+	if (si->flags & SWP_WRITEOK) {
+		/* This is called for allocating swap entry, not cache */
+		offset = scan_swap_map(si, 1);
+		if (offset) {
+			atomic_long_dec(&nr_swap_pages);
+			spin_unlock(&si->lock);
+			return swp_entry(type, offset);
+		}
+	}
+	spin_unlock(&si->lock);
+fail:
+	return (swp_entry_t) {0};
+}
+
 /*
  * Find the swap type that corresponds to given device (if any).
  *
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch

