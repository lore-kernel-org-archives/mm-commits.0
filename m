Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC02CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 22:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343794AbiCGWev (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343812AbiCGWeu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 17:34:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9AC7032C;
        Mon,  7 Mar 2022 14:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4C0D6113B;
        Mon,  7 Mar 2022 22:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C5EC340E9;
        Mon,  7 Mar 2022 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646692434;
        bh=NdkJ1uWmjgDO4N0Ssdgw81+Fp1okwmj+/8PHrjclgec=;
        h=Date:To:From:Subject:From;
        b=QkovuEsV7tfMyyM/skRBUHhV15AF10JdIWOVqNGcXCvToTbj8EdGoH37m8ZVjkTUy
         YibzpabR27gOP4+BYmP1MD9zGDUa7olH67BRMYA14chz6Hi8YTz1Lfl61xIVoRDV9R
         jaF1T1Ls04OIe24fihmqZBvFA2ZZqP8X7F+1G2yE=
Date:   Mon, 07 Mar 2022 14:33:53 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-do-not-demote-poisoned-hugetlb-pages.patch added to -mm tree
Message-Id: <20220307223354.04C5EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: do not demote poisoned hugetlb pages
has been added to the -mm tree.  Its filename is
     hugetlb-do-not-demote-poisoned-hugetlb-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-do-not-demote-poisoned-hugetlb-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-do-not-demote-poisoned-hugetlb-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: do not demote poisoned hugetlb pages

It is possible for poisoned hugetlb pages to reside on the free lists.
The huge page allocation routines which dequeue entries from the free
lists make a point of avoiding poisoned pages.  There is no such check
and avoidance in the demote code path.

If a hugetlb page on the is on a free list, poison will only be set in
the head page rather then the page with the actual error.  If such a
page is demoted, then the poison flag may follow the wrong page.  A page
without error could have poison set, and a page with poison could not
have the flag set.

Check for poison before attempting to demote a hugetlb page.  Also,
return -EBUSY to the caller if only poisoned pages are on the free list.

Link: https://lkml.kernel.org/r/20220307215707.50916-1-mike.kravetz@oracle.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~hugetlb-do-not-demote-poisoned-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -3469,7 +3469,6 @@ static int demote_pool_huge_page(struct
 {
 	int nr_nodes, node;
 	struct page *page;
-	int rc = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3480,15 +3479,19 @@ static int demote_pool_huge_page(struct
 	}
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		if (!list_empty(&h->hugepage_freelists[node])) {
-			page = list_entry(h->hugepage_freelists[node].next,
-					struct page, lru);
-			rc = demote_free_huge_page(h, page);
-			break;
+		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
+			if (PageHWPoison(page))
+				continue;
+
+			return demote_free_huge_page(h, page);
 		}
 	}
 
-	return rc;
+	/*
+	 * Only way to get here is if all pages on free lists are poisoned.
+	 * Return -EBUSY so that caller will not retry.
+	 */
+	return -EBUSY;
 }
 
 #define HSTATE_ATTR_RO(_name) \
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-demote-poisoned-hugetlb-pages.patch
hugetlb-clean-up-potential-spectre-issue-warnings.patch
hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

