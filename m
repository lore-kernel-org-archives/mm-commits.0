Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F488C53210
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 01:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjAEB6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Jan 2023 20:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjAEB6H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2023 20:58:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4830555
        for <mm-commits@vger.kernel.org>; Wed,  4 Jan 2023 17:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC535B81979
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 01:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60289C433EF;
        Thu,  5 Jan 2023 01:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883883;
        bh=hAlKr12OThTCVjQkkVqyIlXmfgu7mcwaG9hEGQwjL9Y=;
        h=Date:To:From:Subject:From;
        b=e2ZaIfreCTbyv1SLi87wpI65RhrZsyglTcjRH3ne5kjMqCGMJUbjB+hudmo+yC9We
         6D1oqexaqUgA4N/SNUN64UmKHSGD8wD/stAHrl4F4834r2UzXznse/MD6OF9m0mrtu
         57Egi8XX6aIpQCan7IY5IdNknvV+Rfzynh8S0U7w=
Date:   Wed, 04 Jan 2023 17:58:02 -0800
To:     mm-commits@vger.kernel.org, mgorman@suse.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-invert-logic-for-early-page-initialisation-checks.patch added to mm-unstable branch
Message-Id: <20230105015803.60289C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: invert logic for early page initialisation checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-invert-logic-for-early-page-initialisation-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-invert-logic-for-early-page-initialisation-checks.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/page_alloc: invert logic for early page initialisation checks
Date: Wed, 4 Jan 2023 21:18:05 +0200

Rename early_page_uninitialised() to early_page_initialised() and invert
its logic to make the code more readable.

Link: https://lkml.kernel.org/r/20230104191805.2535864-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-invert-logic-for-early-page-initialisation-checks
+++ a/mm/page_alloc.c
@@ -443,15 +443,15 @@ static inline bool deferred_pages_enable
 	return static_branch_unlikely(&deferred_pages);
 }
 
-/* Returns true if the struct page for the pfn is uninitialised */
-static inline bool __meminit early_page_uninitialised(unsigned long pfn)
+/* Returns true if the struct page for the pfn is initialised */
+static inline bool __meminit early_page_initialised(unsigned long pfn)
 {
 	int nid = early_pfn_to_nid(pfn);
 
 	if (node_online(nid) && pfn >= NODE_DATA(nid)->first_deferred_pfn)
-		return true;
+		return false;
 
-	return false;
+	return true;
 }
 
 /*
@@ -498,9 +498,9 @@ static inline bool deferred_pages_enable
 	return false;
 }
 
-static inline bool early_page_uninitialised(unsigned long pfn)
+static inline bool early_page_initialised(unsigned long pfn)
 {
-	return false;
+	return true;
 }
 
 static inline bool defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
@@ -1643,7 +1643,7 @@ static void __meminit init_reserved_page
 	pg_data_t *pgdat;
 	int nid, zid;
 
-	if (!early_page_uninitialised(pfn))
+	if (early_page_initialised(pfn))
 		return;
 
 	nid = early_pfn_to_nid(pfn);
@@ -1806,7 +1806,7 @@ int __meminit early_pfn_to_nid(unsigned
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
-	if (early_page_uninitialised(pfn))
+	if (!early_page_initialised(pfn))
 		return;
 	if (!kmsan_memblock_free_pages(page, order)) {
 		/* KMSAN will take care of these pages. */
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-page_alloc-invert-logic-for-early-page-initialisation-checks.patch

