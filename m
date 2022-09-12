Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18204ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiILD3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA24A27B05
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8838B80C71
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615EEC433B5;
        Mon, 12 Sep 2022 03:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953319;
        bh=PS3xwLyljdprjUpMVlsEGiIKAmSF1sZhV8aCtqb3jJs=;
        h=Date:To:From:Subject:From;
        b=adCFIswVyBf/qHv8mkazP7FZGvX5XSE5er3aCC3OXjUeHrSg1HleLuDCdy45s3nKD
         gmkj0zVtN9dD/vCBOrvCjRR8mMt2O4GszZTMkCxNevS10cI74FgCnIPawSC5JwXbh3
         faFCslm/1q14LGnbqcWeh+uAqnvpMr/0Erjsk9e4=
Date:   Sun, 11 Sep 2022 20:28:38 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_pkondeti@quicinc.com, minchan@kernel.org, david@redhat.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch removed from -mm tree
Message-Id: <20220912032839.615EEC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/cma_debug: show complete cma name in debugfs directories
has been removed from the -mm tree.  Its filename was
     mm-cma_debug-show-complete-cma-name-in-debugfs-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

