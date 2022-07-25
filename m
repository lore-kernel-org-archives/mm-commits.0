Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A84C43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 21:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiGYVer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbiGYVee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 17:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42481B77
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 14:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD44B80E01
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 21:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84748C341C6;
        Mon, 25 Jul 2022 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658784870;
        bh=DWXUOQBBLnKex1Jxw9f3Ewr+1trGNhot85cpeF7Skbk=;
        h=Date:To:From:Subject:From;
        b=lPx8mZGCn7ziz6oB7MABt0RIYEbCS3W+6HHmK+FcOixEZP13aqDLqGX+0DpDXR3lo
         qaDWDuOb1zRrFmA2xcQcesWRRV2K/E+J6I1AMu0IQlzIPrHE1816Ea73HoyM1T0mNN
         KJZuffcCrSNJE/PRRhXMDIsMK8QyAGXhgXzf7rDw=
Date:   Mon, 25 Jul 2022 14:34:29 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch added to mm-unstable branch
Message-Id: <20220725213430.84748C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix formatting in check_and_migrate_movable_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup.c: fix formatting in check_and_migrate_movable_page()
Date: Thu, 21 Jul 2022 12:05:52 +1000

Commit b05a79d4377f ("mm/gup: migrate device coherent pages when pinning
instead of failing") added a badly formatted if statement. Fix it.

Link: https://lkml.kernel.org/r/20220721020552.1397598-2-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gupc-fix-formating-in-check_and_migrate_movable_page
+++ a/mm/gup.c
@@ -1983,8 +1983,8 @@ static long check_and_migrate_movable_pa
 				    folio_nr_pages(folio));
 	}
 
-	if (!list_empty(&movable_page_list) || isolation_error_count
-		|| coherent_pages)
+	if (!list_empty(&movable_page_list) || isolation_error_count ||
+	    coherent_pages)
 		goto unpin_pages;
 
 	/*
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch

