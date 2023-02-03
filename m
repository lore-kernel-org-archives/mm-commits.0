Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC34CC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjBCGhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjBCGgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FB98D403
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F3961DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB69C433D2;
        Fri,  3 Feb 2023 06:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406167;
        bh=ZKSwxbYd9eCm1IYbuKu1dUQxZxR6sUFQEFv0o2hnG/o=;
        h=Date:To:From:Subject:From;
        b=mbSvsgcVpisYsJMthYdbDNxCF2fQ/lAwij7agqyzkfh7ywzo2ehOwPxE2YvrKdJcy
         L0KqkPFdtcLU/ntIBGte26QoKsQqZT7IrSE4ZlQn8LxRuek7GaNxj40xOCMyY87wv8
         nHs9IO3ppXzesu2ytn02ERn4E+oaTIv0ZSzFHIIY=
Date:   Thu, 02 Feb 2023 22:36:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch removed from -mm tree
Message-Id: <20230203063607.BDB69C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert try_memory_failure_hugetlb() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert try_memory_failure_hugetlb() to folios
Date: Thu, 12 Jan 2023 14:46:02 -0600

Use a struct folio rather than a head page in try_memory_failure_hugetlb. 
This converts one user of SetHPageMigratable to the folio equivalent.

Link: https://lkml.kernel.org/r/20230112204608.80136-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios
+++ a/mm/memory-failure.c
@@ -1860,7 +1860,7 @@ static int try_memory_failure_hugetlb(un
 {
 	int res;
 	struct page *p = pfn_to_page(pfn);
-	struct page *head;
+	struct folio *folio;
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
@@ -1873,8 +1873,8 @@ retry:
 	} else if (res == -EHWPOISON) {
 		pr_err("%#lx: already hardware poisoned\n", pfn);
 		if (flags & MF_ACTION_REQUIRED) {
-			head = compound_head(p);
-			res = kill_accessing_process(current, page_to_pfn(head), flags);
+			folio = page_folio(p);
+			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
 		return res;
 	} else if (res == -EBUSY) {
@@ -1885,16 +1885,16 @@ retry:
 		return action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 	}
 
-	head = compound_head(p);
-	lock_page(head);
+	folio = page_folio(p);
+	folio_lock(folio);
 
 	if (hwpoison_filter(p)) {
-		hugetlb_clear_page_hwpoison(head);
+		hugetlb_clear_page_hwpoison(&folio->page);
 		if (migratable_cleared)
-			SetHPageMigratable(head);
-		unlock_page(head);
+			folio_set_hugetlb_migratable(folio);
+		folio_unlock(folio);
 		if (res == 1)
-			put_page(head);
+			folio_put(folio);
 		return -EOPNOTSUPP;
 	}
 
@@ -1903,7 +1903,7 @@ retry:
 	 * or demotion can be prevented by PageHWPoison flag.
 	 */
 	if (res == 0) {
-		unlock_page(head);
+		folio_unlock(folio);
 		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
@@ -1913,10 +1913,10 @@ retry:
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
 
-	page_flags = head->flags;
+	page_flags = folio->flags;
 
-	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
-		unlock_page(head);
+	if (!hwpoison_user_mappings(p, pfn, flags, &folio->page)) {
+		folio_unlock(folio);
 		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

