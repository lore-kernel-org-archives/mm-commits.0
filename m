Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59A4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346572AbiEaRcp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346569AbiEaRcn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FFD9399D
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68032B810F1
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F58C385A9;
        Tue, 31 May 2022 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654018359;
        bh=vKAvFYA9CT8hskD8SE3+gPm1nsYfwU5qqowFXFC1t5w=;
        h=Date:To:From:Subject:From;
        b=Rub6xZCYLKbx01asVHP/U9CfR9u5DcVmZ1LdExVYGn9mXxP9OcTgnlqmLngW5Xgbw
         M4R5YTsN/xyC4BhAdisNoNyoumCEYR83/pO8/7NPtHnTpIiSwxNJFLZjnMurk8XPsi
         aHm96kmk53LMXzp8xj4t1fcC3QYCiaukMcnrQAP8=
Date:   Tue, 31 May 2022 10:32:38 -0700
To:     mm-commits@vger.kernel.org, alex.sierra@amd.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch added to mm-unstable branch
Message-Id: <20220531173239.17F58C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
Date: Tue May 31 10:27:42 AM PDT 2022

adjust comment positioning, fix typo

Cc: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
+++ a/mm/memory.c
@@ -623,14 +623,15 @@ struct page *vm_normal_page(struct vm_ar
 			return NULL;
 		if (is_zero_pfn(pfn))
 			return NULL;
+		/*
+		 * NOTE: New users of ZONE_DEVICE will not set pte_devmap() and
+		 * will have refcounts incremented on their struct pages when
+		 * they are inserted into PTEs, thus they are safe to return
+		 * here. Legacy ZONE_DEVICE pages that set pte_devmap() do not
+		 * have refcounts. Example of legacy ZONE_DEVICE is
+		 * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
+		 */
 		if (pte_devmap(pte))
-/*
- * NOTE: New uers of ZONE_DEVICE will not set pte_devmap() and will have
- * refcounts incremented on their struct pages when they are inserted into
- * PTEs, thus they are safe to return here. Legacy ZONE_DEVICE pages that set
- * pte_devmap() do not have refcounts. Example of legacy ZONE_DEVICE is
- * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
- */
 			return NULL;
 
 		print_bad_pte(vma, addr, pte, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

