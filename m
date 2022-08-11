Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F659C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHKVZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiHKVZQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:25:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D646E9B
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 463EBB82076
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D5BC433D6;
        Thu, 11 Aug 2022 21:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660253112;
        bh=fuwYEpVOU01YrcgvDrW9xGSDhNp9lf5/V4g0HfJsop0=;
        h=Date:To:From:Subject:From;
        b=XVNXlnFQR5Mm1Dd8blvrq6zVz0K+AWWqM35a4K6L/ytlQUAtF9GNKWBCUgHo+iGox
         XBKymsUfvJ9sYEN5o9mcDVSy0+rLU7BElxRaRv5+Gvs+rD1cqcq/flgbAHc9CQi7CF
         xz8wYtOlAT9lKS7CnM/kEKv7ree4mcOgOlynuu5c=
Date:   Thu, 11 Aug 2022 14:25:11 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, minchan@kernel.org, david@redhat.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch added to mm-unstable branch
Message-Id: <20220811212511.E0D5BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug: show complete cma name in debugfs directories
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch

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
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm/cma_debug: show complete cma name in debugfs directories
Date: Thu, 11 Aug 2022 18:45:29 +0530

Currently only 12 characters of the cma name is being used as the debug
directories where as the cma name can be of length CMA_MAX_NAME(=64)
characters.  One side problem with this is having 2 cma's with first
common 12 characters would end up in trying to create directories with
same name and fails with -EEXIST thus can limit cma debug functionality.

The 'cma-' prefix is used initially where cma areas don't have any names
and are represented by simple integer values.  Since now each cma would be
having its own name, drop 'cma-' prefix for the cma debug directories as
they are clearly evident that they are for cma debug through creating them
in /sys/kernel/debug/cma/ path.

Link: https://lkml.kernel.org/r/1660223729-22461-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavan Kondeti <quic_pkondeti@quicinc.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/cma_debugfs.rst |   10 +++++-----
 mm/cma_debug.c                               |    5 +----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/cma_debugfs.rst~mm-cma_debug-show-complete-cma-name-in-debugfs-directories
+++ a/Documentation/admin-guide/mm/cma_debugfs.rst
@@ -5,10 +5,10 @@ CMA Debugfs Interface
 The CMA debugfs interface is useful to retrieve basic information out of the
 different CMA areas and to test allocation/release in each of the areas.
 
-Each CMA zone represents a directory under <debugfs>/cma/, indexed by the
-kernel's CMA index. So the first CMA zone would be:
+Each CMA area represents a directory under <debugfs>/cma/, represented by
+its CMA name like below:
 
-	<debugfs>/cma/cma-0
+	<debugfs>/cma/<cma_name>
 
 The structure of the files created under that directory is as follows:
 
@@ -18,8 +18,8 @@ The structure of the files created under
  - [RO] bitmap: The bitmap of page states in the zone.
  - [WO] alloc: Allocate N pages from that CMA area. For example::
 
-	echo 5 > <debugfs>/cma/cma-2/alloc
+	echo 5 > <debugfs>/cma/<cma_name>/alloc
 
-would try to allocate 5 pages from the cma-2 area.
+would try to allocate 5 pages from the 'cma_name' area.
 
  - [WO] free: Free N pages from that CMA area, similar to the above.
--- a/mm/cma_debug.c~mm-cma_debug-show-complete-cma-name-in-debugfs-directories
+++ a/mm/cma_debug.c
@@ -163,11 +163,8 @@ DEFINE_DEBUGFS_ATTRIBUTE(cma_alloc_fops,
 static void cma_debugfs_add_one(struct cma *cma, struct dentry *root_dentry)
 {
 	struct dentry *tmp;
-	char name[CMA_MAX_NAME];
 
-	scnprintf(name, sizeof(name), "cma-%s", cma->name);
-
-	tmp = debugfs_create_dir(name, root_dentry);
+	tmp = debugfs_create_dir(cma->name, root_dentry);
 
 	debugfs_create_file("alloc", 0200, tmp, cma, &cma_alloc_fops);
 	debugfs_create_file("free", 0200, tmp, cma, &cma_free_fops);
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-page_ext-remove-unused-variable-in-offline_page_ext.patch
mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch
mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch

