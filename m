Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56707C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiFQCtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379790AbiFQCtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4364D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77CC361D25
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE31BC3411A;
        Fri, 17 Jun 2022 02:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434158;
        bh=PgEZ12nrvHK+dj6TLQ0LjIrZ3BgRAo4fz/hHUp5JIV8=;
        h=Date:To:From:Subject:From;
        b=fmxT078jiN+eA3xO134bvBnc2nnTWfjvohSNOopoz6CwO2nhsAaagCiWsfdNQCULO
         GCO9TOKXXi/FghoacEO2WVVH8FH3gO67uKZubvdcVZclI5Z8wx+oM5Fk5qNhOV+OQT
         UJ3MhcakVhUDFTfeeh0u9jDcd+FQAe1yMEwWUZa4=
Date:   Thu, 16 Jun 2022 19:49:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, hughd@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch removed from -mm tree
Message-Id: <20220617024918.CE31BC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem.c: clean up comment of shmem_swapin_folio
has been removed from the -mm tree.  Its filename was
     mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/shmem.c: clean up comment of shmem_swapin_folio
Date: Mon, 30 May 2022 19:58:41 +0800

shmem_swapin_folio has changed to use folio but comment still mentions
page.  Update the relevant comment accordingly as suggested by Naoya.

Link: https://lkml.kernel.org/r/20220530115841.4348-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~mm-shmemc-clean-up-comment-of-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -1706,10 +1706,10 @@ static void shmem_set_folio_swapin_error
 }
 
 /*
- * Swap in the page pointed to by *pagep.
- * Caller has to make sure that *pagep contains a valid swapped page.
- * Returns 0 and the page in pagep if success. On failure, returns the
- * error code and NULL in *pagep.
+ * Swap in the folio pointed to by *foliop.
+ * Caller has to make sure that *foliop contains a valid swapped folio.
+ * Returns 0 and the folio in foliop if success. On failure, returns the
+ * error code and NULL in *foliop.
  */
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			     struct folio **foliop, enum sgp_type sgp,
@@ -1749,7 +1749,7 @@ static int shmem_swapin_folio(struct ino
 	}
 	folio = page_folio(page);
 
-	/* We have to do this with page locked to prevent races */
+	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
 	    folio_swap_entry(folio).val != swap.val ||
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

