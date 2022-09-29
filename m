Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08234C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiI2EAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiI2EAt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:00:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193AC32A98
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F376561BEF
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0BCC433D6;
        Thu, 29 Sep 2022 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424045;
        bh=SOaIEhtZXDaoAppmQkZWg2EsFqasNrseHbRucrnUHqI=;
        h=Date:To:From:Subject:From;
        b=Xp/mtdTPbvFKoNYegxp2z0lFePgOLqTHM3jYv+BWWDZaCPBkizUMuyE2twrBpPMr+
         7UDW5vWB27GQ8xZzufeQpQVzZrKDcbj8sVI2fW2ZBqMnZ0yo7jQ1GWPQHDnNCCAp+N
         CQ1f6ssHrDp0RE1PnC+DzWf+f+Mmx3hDJh4f0DIg=
Date:   Wed, 28 Sep 2022 21:00:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] swap-add-swap_cache_get_folio-fix.patch removed from -mm tree
Message-Id: <20220929040045.3A0BCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap-add-swap_cache_get_folio-fix
has been removed from the -mm tree.  Its filename was
     swap-add-swap_cache_get_folio-fix.patch

This patch was dropped because it was folded into swap-add-swap_cache_get_folio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-add-swap_cache_get_folio-fix
Date: Sat Sep  3 12:35:09 PM PDT 2022

add CONFIG_SWAP=n stub for swap_cache_get_folio()

Reported-by: kernel test robot <lkp@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swap.h~swap-add-swap_cache_get_folio-fix
+++ a/mm/swap.h
@@ -101,6 +101,12 @@ static inline int swap_writepage(struct
 	return 0;
 }
 
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct page *lookup_swap_cache(swp_entry_t swp,
 					     struct vm_area_struct *vma,
 					     unsigned long addr)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swap-add-swap_cache_get_folio.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

