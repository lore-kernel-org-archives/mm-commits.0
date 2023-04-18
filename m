Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDBBC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 19:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjDRTJW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjDRTJV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 15:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF96FC14A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 12:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 662AB62D99
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 19:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF32AC433EF;
        Tue, 18 Apr 2023 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681844942;
        bh=2iYySgQdhMa8Q7pUYXRmtBQCiUacvozcqzgPcK+bhTY=;
        h=Date:To:From:Subject:From;
        b=fRXSyhF75OJfrB0F90KUP7sGcGypYFZsrpI9UfhkyRCTBxm0Yg0vAl1lWDY3g3x/4
         LrzI8hZhtztGC2hNrQeT30hg3kPPsHnA0TTeFfX+gJ0bbldd8jBFH8AR19KCBtuAeI
         xxaO/UnOIAfDBExKafFBxVNKkVgdhyfvPUkUyaOw=
Date:   Tue, 18 Apr 2023 12:09:02 -0700
To:     mm-commits@vger.kernel.org, john@metanate.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-debugfs-file-permissions.patch added to mm-unstable branch
Message-Id: <20230418190902.BF32AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: fix debugfs file permissions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-fix-debugfs-file-permissions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-debugfs-file-permissions.patch

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

mm-shrinkers-fix-debugfs-file-permissions.patch

