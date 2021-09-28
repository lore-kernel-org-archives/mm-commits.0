Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F362CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C832D60F58
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbhI1CuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238590AbhI1CuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 22:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A442960E05;
        Tue, 28 Sep 2021 02:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632797312;
        bh=64GpK/V/bLk9e2oQt31dsZ6+GhCWWpVEzVQpgC3sNKc=;
        h=Date:From:To:Subject:From;
        b=I3ws944fp8yDYojK1Y1VsnPR2+BFJnXXD0n8t5n2oVxkSrjM6fCCY6xm/Z4OofZro
         pyZw8fYI0JCtImLJWpFcxQCNaBKeJn8eGz9mMqazVZ5uiAE465pBDGnW77IWx/w+Qb
         cdRkSx90/+JTMMBTKHuXvMMY+O2qoClkZeYEbegI=
Date:   Mon, 27 Sep 2021 19:48:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        songkai01@inspur.com
Subject:  + mm-vmscanc-fix-wunused-but-set-variable-warning.patch
 added to -mm tree
Message-ID: <20210928024832.5EH0TKmlw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix -Wunused-but-set-variable warning
has been added to the -mm tree.  Its filename is
     mm-vmscanc-fix-wunused-but-set-variable-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-fix-wunused-but-set-variable-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-fix-wunused-but-set-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kai Song <songkai01@inspur.com>
Subject: mm/vmscan.c: fix -Wunused-but-set-variable warning

We fix the following warning when building kernel with W=1:
mm/vmscan.c:1362:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/20210924181218.21165-1-songkai01@inspur.com
Signed-off-by: Kai Song <songkai01@inspur.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-wunused-but-set-variable-warning
+++ a/mm/vmscan.c
@@ -1344,7 +1344,6 @@ static unsigned int demote_page_list(str
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
-	int err;
 
 	if (list_empty(demote_pages))
 		return 0;
@@ -1353,7 +1352,7 @@ static unsigned int demote_page_list(str
 		return 0;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	err = migrate_pages(demote_pages, alloc_demote_page, NULL,
+	migrate_pages(demote_pages, alloc_demote_page, NULL,
 			    target_nid, MIGRATE_ASYNC, MR_DEMOTION,
 			    &nr_succeeded);
 
_

Patches currently in -mm which might be from songkai01@inspur.com are

mm-vmscanc-fix-wunused-but-set-variable-warning.patch

