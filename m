Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29A6C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjLDTPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjLDTPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:15:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDD6E6
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:15:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA6BC433C7;
        Mon,  4 Dec 2023 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701717322;
        bh=cCoaUHNXhKQgh9+UeHzA1/H3zo760AI/w+mG7a/r/3U=;
        h=Date:To:From:Subject:From;
        b=FPWqn0S8/Ihecc5CQ7RdDCNgyPTOmtrFnXmqT2igwgW1jgyjWx2OKn3IRCsQW/IJO
         9zguhJhOlZWs4qE0lMDqQG5BhqVdNPtyf6UreP2V9xe3k7w0k/rxLjBjWL/P6gt8Rm
         jHMG5vbxSfQkFUi3OsKazNPYZgmew4+Rx6gMzj+U=
Date:   Mon, 04 Dec 2023 11:15:22 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch added to mm-unstable branch
Message-Id: <20231204191522.CDA6BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
Date: Fri, 10 Nov 2023 11:33:21 +0800

Use more folio APIs to save six compound_head() calls in
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231110033324.2455523-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2631,13 +2631,13 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
-	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
-					  PageSwapCache(head)));
+	page_ref_unfreeze(page_tail, 1 + (!folio_test_anon(folio) ||
+					  folio_test_swapcache(folio)));
 
-	if (page_is_young(head))
-		set_page_young(page_tail);
-	if (page_is_idle(head))
-		set_page_idle(page_tail);
+	if (folio_test_young(folio))
+		folio_set_young(new_folio);
+	if (folio_test_idle(folio))
+		folio_set_idle(new_folio);
 
 	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

