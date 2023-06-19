Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17F6EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjFSXYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjFSXWV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462A5172B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D136760F14
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38710C433C0;
        Mon, 19 Jun 2023 23:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216931;
        bh=/BqN5LZTm0oDuNNBylY0K/VU/Lae1OyeSfWE4HSCibI=;
        h=Date:To:From:Subject:From;
        b=B8kBlIRNJJfjfxRTc9tvDwFyB508ctxbrEUVtA1oROe4n0mJ3wQo+KLxanZOvFX7r
         cAG+j9edktuTA6vkcvQ9oaBQJwSC2dc5gHRd3a5lpcUFeyEYWviyJaBlj7EwOmSdgt
         9DTrAINxpCTtjZaKY5AnrqcgMt/QIL5fagO6GiP8=
Date:   Mon, 19 Jun 2023 16:22:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-set_compound_page_dtor.patch removed from -mm tree
Message-Id: <20230619232211.38710C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove set_compound_page_dtor()
has been removed from the -mm tree.  Its filename was
     mm-remove-set_compound_page_dtor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


