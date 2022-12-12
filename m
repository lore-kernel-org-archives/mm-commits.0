Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8068FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 00:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiLLAFS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 19:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLAFR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 19:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB78766F
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 16:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDEF60EAA
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 00:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C10DC433D2;
        Mon, 12 Dec 2022 00:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670803515;
        bh=GyIIFYviH9/bs17qt+N3Giio+IcJ6/0X9n5HCgF/Oe8=;
        h=Date:To:From:Subject:From;
        b=UnEtY7X7ziJcjkyGz3AZ8JF45nuMHb8N6dYbIqGSi2fPs/RA9dV5NEXDs1jEjeGmH
         9QLd+2rXmZvclecSlXjZpwO5vH5N1vt/ZcAHHS/MEQ5ztca3G06YCMfgsiIMZpE09G
         4CAeaW+AokxvX64QGQ2F62DaknueLTu3ZtCIi4UQ=
Date:   Sun, 11 Dec 2022 16:05:14 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-remove-foll_migration-fix.patch removed from -mm tree
Message-Id: <20221212000515.1C10DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-gup-remove-foll_migration-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-foll_migration-fix.patch

This patch was dropped because it was folded into mm-gup-remove-foll_migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-remove-foll_migration-fix
Date: Fri Oct 21 03:04:50 PM PDT 2022

fix merge snafu

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/gup.c~mm-gup-remove-foll_migration-fix
+++ a/mm/gup.c
@@ -651,28 +651,8 @@ static struct page *follow_pmd_mask(stru
 	pmdval = READ_ONCE(*pmd);
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
-retry:
-	if (!pmd_present(pmdval)) {
-		/*
-		 * Should never reach here, if thp migration is not supported;
-		 * Otherwise, it must be a thp migration entry.
-		 */
-		VM_BUG_ON(!thp_migration_supported() ||
-				  !is_pmd_migration_entry(pmdval));
-
-		if (likely(!(flags & FOLL_MIGRATION)))
-			return no_page_table(vma, flags);
-
-		pmd_migration_entry_wait(mm, pmd);
-		pmdval = READ_ONCE(*pmd);
-		/*
-		 * MADV_DONTNEED may convert the pmd to null because
-		 * mmap_lock is held in read mode
-		 */
-		if (pmd_none(pmdval))
-			return no_page_table(vma, flags);
-		goto retry;
-	}
+	if (!pmd_present(pmdval))
+		return no_page_table(vma, flags);
 	if (pmd_devmap(pmdval)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags, &ctx->pgmap);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-remove-foll_migration.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch
mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

