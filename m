Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD12E7F127
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 20:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjIZUp7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbjIZUp7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 16:45:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A37126
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 13:45:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41705C433C7;
        Tue, 26 Sep 2023 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695761152;
        bh=AGK+Pmix3N5fFWLorS/lCGVKvx4LWXkL7esK7iasB8s=;
        h=Date:To:From:Subject:From;
        b=pR2tmvsuqtAMNczXVxwClnnrClTIn77eYMekuI8XhbDKWABAXOP/e5ZFHtf3t+PNl
         kHCU+n74hCvIScuVtsWvDAI8VB3x7gwXtXYSlMxM5jIgKSa0K2I9wTxiV6PtRHSqWG
         tkjagQ2wW5X9reiDs9Kn8mEQLOM4KX4BfwAYXshM=
Date:   Tue, 26 Sep 2023 13:45:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch added to mm-unstable branch
Message-Id: <20230926204552.41705C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: replace page_ref_freeze() with folio_ref_freeze() in hugetlb_folio_init_vmemmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch

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
Subject: mm/hugetlb: replace page_ref_freeze() with folio_ref_freeze() in hugetlb_folio_init_vmemmap()
Date: Tue, 26 Sep 2023 10:44:33 -0700

No functional difference, folio_ref_freeze() is currently a wrapper for
page_ref_freeze().

Link: https://lkml.kernel.org/r/20230926174433.81241-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap
+++ a/mm/hugetlb.c
@@ -3191,7 +3191,7 @@ static void __init hugetlb_folio_init_vm
 	/* Prepare folio head */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
-	ret = page_ref_freeze(&folio->page, 1);
+	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-filemap-remove-hugetlb-special-casing-in-filemapc.patch
mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch

