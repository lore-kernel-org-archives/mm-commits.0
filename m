Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD2EC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjDUVxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjDUVxH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BE630DA
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8324D61A00
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F75C4339B;
        Fri, 21 Apr 2023 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113968;
        bh=uocb+SKurhn7o+0nZ/WY0H2Pt/fyelPDmwywCOdgNQc=;
        h=Date:To:From:Subject:From;
        b=wApWxrGdmAuPME+EFhwRSRgwNSGdH0qU255u/UaP9pssVObcUnJMLVOZVEmN7u6zy
         HUQ/JoFSPEdNNSABA24+8HRVxRgQI4WVn4zTA4TYaaqOrZ5LlEkvzh4uNT8+SezbjE
         lCe3+YfhCnEAo/XYbfLX1JV/3nWvbQJOsAmTlL9k=
Date:   Fri, 21 Apr 2023 14:52:48 -0700
To:     mm-commits@vger.kernel.org, john@metanate.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinkers-fix-debugfs-file-permissions.patch removed from -mm tree
Message-Id: <20230421215248.D5F75C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shrinkers: fix debugfs file permissions
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-fix-debugfs-file-permissions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Keeping <john@metanate.com>
Subject: mm: shrinkers: fix debugfs file permissions
Date: Tue, 18 Apr 2023 11:19:05 +0100

The permissions for the files here are swapped as "count" is read-only and
"scan" is write-only.  While this doesn't really matter as these
permissions don't stop the files being opened for reading/writing as
appropriate, they are shown by "ls -l" and are confusing.

Link: https://lkml.kernel.org/r/20230418101906.3131303-1-john@metanate.com
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-fix-debugfs-file-permissions
+++ a/mm/shrinker_debug.c
@@ -189,9 +189,9 @@ int shrinker_debugfs_add(struct shrinker
 	}
 	shrinker->debugfs_entry = entry;
 
-	debugfs_create_file("count", 0220, entry, shrinker,
+	debugfs_create_file("count", 0440, entry, shrinker,
 			    &shrinker_debugfs_count_fops);
-	debugfs_create_file("scan", 0440, entry, shrinker,
+	debugfs_create_file("scan", 0220, entry, shrinker,
 			    &shrinker_debugfs_scan_fops);
 	return 0;
 }
_

Patches currently in -mm which might be from john@metanate.com are


