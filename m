Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFE6C61DB3
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbjALVct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjALVcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E80395CA
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242C462198
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA47C433F0;
        Thu, 12 Jan 2023 21:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558197;
        bh=bugGfH6D6u7nsg4YgBrrpoaar/8yU3j3ai+9zDdxYro=;
        h=Date:To:From:Subject:From;
        b=RPRcqK9dhJmQ9sWdlrIAbEdP1q+WSXRLHpAvAWR7zi7PEF6QyW8LNGvumL6q3wsHh
         El8P2HKZyvb8VCbmOK0vkau46WppnK76+2S5YOQeto4l25Ee0n9MqVFsYwus/MnE3S
         2jCM+nnapTnsrVtHmSbhRoKZ5VwWKQGPoOZ7r5fg=
Date:   Thu, 12 Jan 2023 13:16:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211637.7AA47C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert __free_raw_hwp_pages() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert __free_raw_hwp_pages() to folios
Date: Thu, 12 Jan 2023 14:46:06 -0600

Change __free_raw_hwp_pages() to __folio_free_raw_hwp() and modify its
callers to pass in a folio.

Link: https://lkml.kernel.org/r/20230112204608.80136-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

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

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch

