Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADC7C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiILDel (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiILDdH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A6929800
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB1BFB8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A52C433D7;
        Mon, 12 Sep 2022 03:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953421;
        bh=lp1fCGeihxyKXGKG9R8mPXjhaOIbXo2ZCayIQlj10OQ=;
        h=Date:To:From:Subject:From;
        b=f+kgYK6wSWMTgxumoa4yVMuo+/vgOvx5oxz/JtZO2Zl8rs6vAxwDNZWKg4L2r1+J7
         jQ8IXtJ6/scEEcErvbYiaa1dyui904b5qjAQ7GNws2qq/ShDKNLbwPcf4BPBkfmmos
         17kneUBm+wlNh6gcFmDWv59AxseEtkwHx75nh30g=
Date:   Sun, 11 Sep 2022 20:30:20 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch removed from -mm tree
Message-Id: <20220912033021.A3A52C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: fix a misleading and outdated comment
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-hmm-tests-add-test-for-dirty-bits.patch

