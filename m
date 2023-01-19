Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B7BC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjASBOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjASBN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7865F37F20
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E9E61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FA1C433EF;
        Thu, 19 Jan 2023 01:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090827;
        bh=snMQ+fOwT1dPjC4GK+deS4QC9K5p3v1P2VUJvPw5xYs=;
        h=Date:To:From:Subject:From;
        b=QTjKSdFDnHQ0CK1oF0MeGHjj3Htt1ixlqowGMlBrado5et18a7JngsZEDtqjuZRtk
         aftDsIFOp7ZkCLnU1n9Pf/TVl9FCAUs0lit20Cgbf4NxgeNtOuNFUbuX/DCBCNmGdT
         iHXbBUmcuI8GZZLbk/fpO4ehXrcyKXELAAx+KXhE=
Date:   Wed, 18 Jan 2023 17:13:46 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch removed from -mm tree
Message-Id: <20230119011347.69FA1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: don't wait for migration entry during follow page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: don't wait for migration entry during follow page
Date: Fri, 16 Dec 2022 10:50:53 -0500

That's what the code does with !hugetlb pages, so we should logically do
the same for hugetlb, so migration entry will also be treated as no page.

This is probably also the last piece in follow_page code that may sleep,
the last one should be removed in cf994dd8af27 ("mm/gup: remove
FOLL_MIGRATION", 2022-11-16).

Link: https://lkml.kernel.org/r/20221216155100.2043537-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-wait-for-migration-entry-during-follow-page
+++ a/mm/hugetlb.c
@@ -6401,7 +6401,6 @@ struct page *hugetlb_follow_page_mask(st
 	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
-retry:
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (!pte)
 		return NULL;
@@ -6424,16 +6423,6 @@ retry:
 			page = NULL;
 			goto out;
 		}
-	} else {
-		if (is_hugetlb_entry_migration(entry)) {
-			spin_unlock(ptl);
-			__migration_entry_wait_huge(pte, ptl);
-			goto retry;
-		}
-		/*
-		 * hwpoisoned entry is treated as no_page_table in
-		 * follow_page_mask().
-		 */
 	}
 out:
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

