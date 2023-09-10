Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9C3EE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 19:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjIJTq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 15:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjIJTq3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 15:46:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F9212D
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 12:46:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCC1C433C7;
        Sun, 10 Sep 2023 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694375184;
        bh=3VufXR64259wQXrRbsR0dY1V50Q00dI1yjXM2JFB5qY=;
        h=Date:To:From:Subject:From;
        b=h9XwZAbNEJvUFweuOo9w7jX1qanxw7gChiKRUv59h+Dv3Y3kFboRtefCU8JLi36/5
         269ZMyPyxoypNcopHBDCSaUPduGLf8KSF1cQF3wi22C1t04hOTCN3mRwamQnH8fDC9
         /aNLJrEAeYnSWksYvX2UQ2XaDq8FwhIH2dwkSgTo=
Date:   Sun, 10 Sep 2023 12:46:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch added to mm-unstable branch
Message-Id: <20230910194624.5FCC1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch

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
From: Jane Chu <jane.chu@oracle.com>
Subject: mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
Date: Fri, 8 Sep 2023 16:23:36 -0600

add comment to mf_generic_kill_procss(), simplify
mf_generic_kill_procs:folio initialization.

Link: https://lkml.kernel.org/r/20230908222336.186313-1-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
+++ a/mm/memory-failure.c
@@ -1720,11 +1720,19 @@ static void unmap_and_kill(struct list_h
 	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
 }
 
+/*
+ * Only dev_pagemap pages get here, such as fsdax when the filesystem
+ * either do not claim or fails to claim a hwpoison event, or devdax.
+ * The fsdax pages are initialized per base page, and the devdax pages
+ * could be initialized either as base pages, or as compound pages with
+ * vmemmap optimization enabled. Devdax is simplistic in its dealing with
+ * hwpoison, such that, if a subpage of a compound page is poisoned,
+ * simply mark the compound head page is by far sufficient.
+ */
 static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio = pfn_folio(pfn);
 	LIST_HEAD(to_kill);
 	dax_entry_t cookie;
 	int rc = 0;
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch

