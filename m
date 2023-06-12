Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545E0C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjFLUrA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjFLUqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD241FF9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E491E6221C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414F6C433D2;
        Mon, 12 Jun 2023 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686602625;
        bh=4OPXaGT3yBFt9aNy7LUYuDNznN+qCOuPhsspupiL0VA=;
        h=Date:To:From:Subject:From;
        b=mxjaEkc5tFF3kODK7UOR5zA+WM16YXGlD8G+JsGBFklPhqXkWbbvTRGN+skePhtuw
         wIHBwfrHnsNv44eeWsnRyObvVxMUM6+yjiv60q34eYofca9+JODKc7UiOTftywJJ++
         xwaO8ujuNSvhAhhyRa3BtllOX6TMBBVLe2vI7D9M=
Date:   Mon, 12 Jun 2023 13:43:44 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch removed from -mm tree
Message-Id: <20230612204345.414F6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch

This patch was dropped because it was folded into mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
Date: Thu May 18 01:30:35 PM PDT 2023

suppress smatch "if (unsigned < 0)" warning

Cc: Oscar Salvador <osalvador@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305182345.LTMlWG84-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix
+++ a/lib/stackdepot.c
@@ -541,9 +541,8 @@ int stack_print(struct seq_file *m, void
 	int ret = 0;
 	struct stack_record *stack = v;
 
-	if (!stack->size || stack->size < 0 ||
-	    stack->size > PAGE_SIZE || stack->handle.valid != 1 ||
-	    refcount_read(&stack->count) < 1)
+	if (stack->size <= 0 || stack->size > PAGE_SIZE ||
+	    stack->handle.valid != 1 || refcount_read(&stack->count) < 1)
 		return 0;
 
 	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

