Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ACEC433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BBA06023F
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhCaE01 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhCaE0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CBA76023F;
        Wed, 31 Mar 2021 04:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617164775;
        bh=KS5qdXdNd5xLveVBYiKxmBeG1yjeq/GmO3s3h2i/E6o=;
        h=Date:From:To:Subject:From;
        b=OJVFhdTGGHq2V3yQP+X0fpPbZjCafytxphLF32mjYbsfo2r2W9ECiGzYQshLnVqMN
         HDBGnYxVAsukPY4wvqHx71DXFCHG9epI9pAr7nc7DndtFyTfnOByxfQac/R8VhWkse
         CR4N5Z9jnCW8UBeTwxuGuuOpiFKkypOhKegUsEBI=
Date:   Tue, 30 Mar 2021 21:26:15 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com
Subject:  + mm-gup-remove-foll_split.patch added to -mm tree
Message-ID: <20210331042615.GNU0fSQmU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: remove FOLL_SPLIT
has been added to the -mm tree.  Its filename is
     mm-gup-remove-foll_split.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-foll_split.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-foll_split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: gup: remove FOLL_SPLIT

Since commit 5a52c9df62b4 ("uprobe: use FOLL_SPLIT_PMD instead of
FOLL_SPLIT") and commit ba925fa35057 ("s390/gmap: improve THP splitting")
FOLL_SPLIT has not been used anymore.  Remove the dead code.

Link: https://lkml.kernel.org/r/20210330203900.9222-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.rst |    5 -----
 include/linux/mm.h             |    1 -
 mm/gup.c                       |   28 ++--------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

--- a/Documentation/vm/transhuge.rst~mm-gup-remove-foll_split
+++ a/Documentation/vm/transhuge.rst
@@ -53,11 +53,6 @@ prevent the page from being split by any
    of handling GUP on hugetlbfs will also work fine on transparent
    hugepage backed mappings.
 
-In case you can't handle compound pages if they're returned by
-follow_page, the FOLL_SPLIT bit can be specified as a parameter to
-follow_page, so that it will split the hugepages before returning
-them.
-
 Graceful fallback
 =================
 
--- a/include/linux/mm.h~mm-gup-remove-foll_split
+++ a/include/linux/mm.h
@@ -2781,7 +2781,6 @@ struct page *follow_page(struct vm_area_
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
 #define FOLL_POPULATE	0x40	/* fault in page */
-#define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
--- a/mm/gup.c~mm-gup-remove-foll_split
+++ a/mm/gup.c
@@ -516,18 +516,6 @@ retry:
 		}
 	}
 
-	if (flags & FOLL_SPLIT && PageTransCompound(page)) {
-		get_page(page);
-		pte_unmap_unlock(ptep, ptl);
-		lock_page(page);
-		ret = split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
-		if (ret)
-			return ERR_PTR(ret);
-		goto retry;
-	}
-
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	if (unlikely(!try_grab_page(page, flags))) {
 		page = ERR_PTR(-ENOMEM);
@@ -672,7 +660,7 @@ retry_locked:
 		spin_unlock(ptl);
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 	}
-	if (flags & (FOLL_SPLIT | FOLL_SPLIT_PMD)) {
+	if (flags & FOLL_SPLIT_PMD) {
 		int ret;
 		page = pmd_page(*pmd);
 		if (is_huge_zero_page(page)) {
@@ -681,19 +669,7 @@ retry_locked:
 			split_huge_pmd(vma, pmd, address);
 			if (pmd_trans_unstable(pmd))
 				ret = -EBUSY;
-		} else if (flags & FOLL_SPLIT) {
-			if (unlikely(!try_get_page(page))) {
-				spin_unlock(ptl);
-				return ERR_PTR(-ENOMEM);
-			}
-			spin_unlock(ptl);
-			lock_page(page);
-			ret = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
-			if (pmd_none(*pmd))
-				return no_page_table(vma, flags);
-		} else {  /* flags & FOLL_SPLIT_PMD */
+		} else {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmd, address);
 			ret = pte_alloc(mm, pmd) ? -ENOMEM : 0;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-gup-remove-foll_split.patch
mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
mm-vmscan-consolidate-shrinker_maps-handling-code.patch
mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation.patch
mm-vmscan-remove-memcg_shrinker_map_size.patch
mm-vmscan-use-kvfree_rcu-instead-of-call_rcu.patch
mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
mm-vmscan-add-shrinker_info_protected-helper.patch
mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch
mm-vmscan-add-per-memcg-shrinker-nr_deferred.patch
mm-vmscan-use-per-memcg-nr_deferred-of-shrinker.patch
mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers.patch
mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

