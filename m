Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F41C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 19:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbjFLTy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237727AbjFLTyy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 15:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E41102
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 12:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AEE8617C7
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 19:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5D0C433EF;
        Mon, 12 Jun 2023 19:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686599691;
        bh=1qIgLZA+OV0H5NM/4hqsGCFwGAxbM6R2jo7ey/BK6dY=;
        h=Date:To:From:Subject:From;
        b=XceMCEmcdpLTYXT0WiMKcDaqE2OZvAiQFNT8aWRTCsUnf3IJpbIPszViWU6n98EIo
         bITasHvz0GjDGCKL/la7/F/NzPbHCr/F0h0pppW6E2hTcrBK6m90QP+zu2M8ro4zdZ
         tRxgw/z4bl5w7XojMi5dBFpQyxs+eh0CC8C1eYzM=
Date:   Mon, 12 Jun 2023 12:54:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-set_compound_page_dtor.patch added to mm-unstable branch
Message-Id: <20230612195451.CD5D0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove set_compound_page_dtor()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-set_compound_page_dtor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-set_compound_page_dtor.patch

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
Subject: mm: remove set_compound_page_dtor()
Date: Mon, 12 Jun 2023 09:34:05 -0700

All users can use the folio equivalent so this function can be safely
removed.

Link: https://lkml.kernel.org/r/20230612163405.99345-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ----------
 mm/huge_memory.c   |    2 +-
 mm/internal.h      |    2 +-
 3 files changed, 2 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-remove-set_compound_page_dtor
+++ a/include/linux/mm.h
@@ -1223,16 +1223,6 @@ enum compound_dtor_id {
 };
 extern compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS];
 
-static inline void set_compound_page_dtor(struct page *page,
-		enum compound_dtor_id compound_dtor)
-{
-	struct folio *folio = (struct folio *)page;
-
-	VM_BUG_ON_PAGE(compound_dtor >= NR_COMPOUND_DTORS, page);
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	folio->_folio_dtor = compound_dtor;
-}
-
 static inline void folio_set_compound_dtor(struct folio *folio,
 		enum compound_dtor_id compound_dtor)
 {
--- a/mm/huge_memory.c~mm-remove-set_compound_page_dtor
+++ a/mm/huge_memory.c
@@ -583,7 +583,7 @@ void prep_transhuge_page(struct page *pa
 
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
-	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
+	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
 }
 
 static inline bool is_transparent_hugepage(struct page *page)
--- a/mm/internal.h~mm-remove-set_compound_page_dtor
+++ a/mm/internal.h
@@ -391,7 +391,7 @@ static inline void prep_compound_head(st
 {
 	struct folio *folio = (struct folio *)page;
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 	set_compound_order(page, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-set_compound_page_dtor.patch

