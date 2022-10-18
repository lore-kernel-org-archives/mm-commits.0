Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA02CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJRBL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiJRBLg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:11:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95DFB1FD
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5882DB81BDB
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07703C433D6;
        Tue, 18 Oct 2022 01:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055492;
        bh=2QvUQd1KydFbEgS7ps9H/ST8OrmLf2rOpi5xR2B6eFg=;
        h=Date:To:From:Subject:From;
        b=BunYEO7zvppAjmd8xrBDgT6Gz1A/cX2DLwUe/duwOnusf1daEDJTzr28SuXLx5nVt
         ydn76ij62cyefOs1La9gOrANvMj0Xkba60FTIyv6tIkqdbR86lH65zvsHNR8M9kfOa
         hh8MgxVNO4aUKMoVfZ/vai8Cvmd/s3i8RY6NzbAw=
Date:   Mon, 17 Oct 2022 18:11:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch added to mm-unstable branch
Message-Id: <20221018011132.07703C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: rename page_not_mapped() to folio_not_mapped()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: rmap: rename page_not_mapped() to folio_not_mapped()
Date: Tue, 27 Sep 2022 14:38:26 +0800

Since commit 2f031c6f042c ("mm/rmap: Convert rmap_walk() to take a
folio"), page_not_mapped() takes folio as parameter, rename it to be
consistent.

Link: https://lkml.kernel.org/r/20220927063826.159590-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-rename-page_not_mapped-to-folio_not_mapped
+++ a/mm/rmap.c
@@ -1801,7 +1801,7 @@ static bool invalid_migration_vma(struct
 	return vma_is_temporary_stack(vma);
 }
 
-static int page_not_mapped(struct folio *folio)
+static int folio_not_mapped(struct folio *folio)
 {
 	return !folio_mapped(folio);
 }
@@ -1822,7 +1822,7 @@ void try_to_unmap(struct folio *folio, e
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
@@ -2150,7 +2150,7 @@ void try_to_migrate(struct folio *folio,
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_migrate_one,
 		.arg = (void *)flags,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
@@ -2297,7 +2297,7 @@ static bool folio_make_device_exclusive(
 	};
 	struct rmap_walk_control rwc = {
 		.rmap_one = page_make_device_exclusive_one,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 		.arg = &args,
 	};
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch

