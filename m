Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EDCC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiGHAy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiGHAy0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:54:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE7C70E6C
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE3561338
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51529C3411E;
        Fri,  8 Jul 2022 00:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657241664;
        bh=OQ/BdcKmfC+sNgKa2EUrVoOd9yQdWg5f9iBIy2hZpvQ=;
        h=Date:To:From:Subject:From;
        b=pCjx2DAYHOnVchhix21uJAOJpuE0E4uqZIi/fQcrveOLtdNowTQMdTgeStjMozyk7
         H5Ws5AvOYOM1qgaJZmkfx1JykQTQ0xOdpt0ymqBqHkLCEuaFRPxch9yUmN7WlzOJ85
         SHkXE+iqbvGhna8sUjoORvyD50pcQBhVk1dEtgoU=
Date:   Thu, 07 Jul 2022 17:54:23 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix.patch removed from -mm tree
Message-Id: <20220708005424.51529C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix

build fix

Link: https://lkml.kernel.org/r/20220704070317.GA2473612@hori.linux.bs1.fc.nec.co.jp
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix
+++ a/mm/memory-failure.c
@@ -1664,6 +1664,7 @@ unlock:
 EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 #endif /* CONFIG_FS_DAX */
 
+#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Struct raw_hwp_page represents information about "raw error page",
  * constructing singly linked list originated from ->private field of
@@ -1797,7 +1798,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
@@ -1893,8 +1893,9 @@ static inline int try_memory_failure_hug
 	return 0;
 }
 
-static inline void free_raw_hwp_pages(struct page *hpage, bool move_flag)
+static inline long free_raw_hwp_pages(struct page *hpage, bool move_flag)
 {
+	return 0;
 }
 #endif	/* CONFIG_HUGETLB_PAGE */
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

