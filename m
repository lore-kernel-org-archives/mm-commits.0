Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEE9C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjBCGh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBCGgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E178D414
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C47161DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BF8C433EF;
        Fri,  3 Feb 2023 06:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406172;
        bh=+ZY1+GVejlBnhttlXII1s8fCMJQ43V2b1ym8MWOt45Y=;
        h=Date:To:From:Subject:From;
        b=sVNf0LcVIkmyIJ5BpO6I6KWnvfWsUJxg8Ql7UVzztYFYnQgE51YhdXKG1+SmoQTlA
         Awly+6dbxKlWMAW7eDLoWFmVxUN5XjuU/A7vw89WNLvAXbdNuaeKYoFWRXqyPnd44l
         l6xStxGvs2eHD+xxMWrACWVqjYSMcfh7QQ7ySyGo=
Date:   Thu, 02 Feb 2023 22:36:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch removed from -mm tree
Message-Id: <20230203063611.E3BF8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert __free_raw_hwp_pages() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert __free_raw_hwp_pages() to folios
Date: Thu, 12 Jan 2023 14:46:06 -0600

Change __free_raw_hwp_pages() to __folio_free_raw_hwp() and modify its
callers to pass in a folio.

Link: https://lkml.kernel.org/r/20230112204608.80136-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-convert-__free_raw_hwp_pages-to-folios
+++ a/mm/memory-failure.c
@@ -1700,12 +1700,11 @@ static inline struct llist_head *raw_hwp
 	return (struct llist_head *)&folio->_hugetlb_hwpoison;
 }
 
-static unsigned long __free_raw_hwp_pages(struct page *hpage, bool move_flag)
+static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
 	struct llist_head *head;
 	struct llist_node *t, *tnode;
 	unsigned long count = 0;
-	struct folio *folio = page_folio(hpage);
 
 	head = raw_hwp_list_head(folio);
 	llist_for_each_safe(tnode, t, head->first) {
@@ -1763,7 +1762,7 @@ static int hugetlb_set_page_hwpoison(str
 		 * Once hugetlb_raw_hwp_unreliable is set, raw_hwp_page is not
 		 * used any more, so free it.
 		 */
-		__free_raw_hwp_pages(hpage, false);
+		__folio_free_raw_hwp(folio, false);
 	}
 	return ret;
 }
@@ -1784,7 +1783,7 @@ static unsigned long folio_free_raw_hwp(
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return 0;
 
-	return __free_raw_hwp_pages(&folio->page, move_flag);
+	return __folio_free_raw_hwp(folio, move_flag);
 }
 
 void folio_clear_hugetlb_hwpoison(struct folio *folio)
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

