Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7124EC38142
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 23:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjAaXSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 18:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjAaXS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 18:18:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F85010421
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 15:18:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECFA5B81ED8
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 23:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D37C433EF;
        Tue, 31 Jan 2023 23:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675207105;
        bh=phwuTDLLgXwJ/tzrIEnEhUBTHMHggKOA9KCuQXOac8s=;
        h=Date:To:From:Subject:From;
        b=zLmhJa+VWn3ooq7eV54xGcbjvTgt/OftwUA2nTgcmPDbpJ15A+e7IESbUcKxVzQ0v
         XbLO2273mOoVgAwzxou9fb4fBtY4bZS6s0STWvD6swYH5O94rihW/0W/TRHktc+Hil
         NQs/oO6UZjrXvUeDufEJWQZWHXcf77ltntoErAAc=
Date:   Tue, 31 Jan 2023 15:18:25 -0800
To:     mm-commits@vger.kernel.org, matthias.bgg@gmail.com,
        jhubbard@nvidia.com, chinwen.chang@mediatek.com,
        apopple@nvidia.com, andrew.yang@mediatek.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch added to mm-unstable branch
Message-Id: <20230131231825.95D37C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add folio to list when folio_isolate_lru() succeed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch

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
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: mm/gup: add folio to list when folio_isolate_lru() succeed
Date: Tue, 31 Jan 2023 14:32:06 +0800

If we call folio_isolate_lru() successfully, we will get return value 0. 
We need to add this folio to the movable_pages_list.

Link: https://lkml.kernel.org/r/20230131063206.28820-1-Kuan-Ying.Lee@mediatek.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed
+++ a/mm/gup.c
@@ -1914,7 +1914,7 @@ static unsigned long collect_longterm_un
 			drain_allow = false;
 		}
 
-		if (!folio_isolate_lru(folio))
+		if (folio_isolate_lru(folio))
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

kasan-infer-allocation-size-by-scanning-metadata.patch
mm-gup-add-folio-to-list-when-folio_isolate_lru-succeed.patch

