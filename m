Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C110ECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiHaBvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiHaBvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D240BB02A9
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536AC618D8
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0DDC433D6;
        Wed, 31 Aug 2022 01:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661910672;
        bh=530eN9lHmcccxtU9PGP1C3UzIHwlEHDN5bFjTKhjJ8M=;
        h=Date:To:From:Subject:From;
        b=gAN7ovflgmiVn46V7xHmnZqzUJERJ/BCgcLLX9jk+nYoY5NcXAacbuNlXDXtaRGsW
         Z9W7X56HpcNsur+a5Af3xslr6ZQnJzRvI8wLvG0pKX3mJZD5ujvbKDuBYscIkDai2I
         oCmiWPUQz8lNPWeqJgU4iZUOW4ZgYug7c5UqA8UY=
Date:   Tue, 30 Aug 2022 18:51:11 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch added to mm-unstable branch
Message-Id: <20220831015112.AE0DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate_device.c: fix a misleading and outdated comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

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
Subject: mm/migrate_device.c: fix a misleading and outdated comment
Date: Tue, 30 Aug 2022 12:01:38 +1000

Commit ab09243aa95a ("mm/migrate.c: remove MIGRATE_PFN_LOCKED") changed
the way trylock_page() in migrate_vma_collect_pmd() works without updating
the comment.  Reword the comment to be less misleading and a better
reflection of what happens.

Link: https://lkml.kernel.org/r/20220830020138.497063-1-apopple@nvidia.com
Fixes: ab09243aa95a ("mm/migrate.c: remove MIGRATE_PFN_LOCKED")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Peter Xu <peterx@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-fix-a-misleading-and-out-dated-comment
+++ a/mm/migrate_device.c
@@ -185,9 +185,16 @@ again:
 		get_page(page);
 
 		/*
-		 * Optimize for the common case where page is only mapped once
-		 * in one process. If we can lock the page, then we can safely
-		 * set up a special migration page table entry now.
+		 * We rely on trylock_page() to avoid deadlock between
+		 * concurrent migrations where each is waiting on the others
+		 * page lock. If we can't immediately lock the page we fail this
+		 * migration as it is only best effort anyway.
+		 *
+		 * If we can lock the page it's safe to set up a migration entry
+		 * now. In the common case where the page is mapped once in a
+		 * single process setting up the migration entry now is an
+		 * optimisation to avoid walking the rmap later with
+		 * try_to_migrate().
 		 */
 		if (trylock_page(page)) {
 			bool anon_exclusive;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch
mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

