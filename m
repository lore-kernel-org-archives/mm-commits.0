Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDC2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiEJEZS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiEJEX0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFCF1CE60C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 748B8B81B0D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C61C385C5;
        Tue, 10 May 2022 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156281;
        bh=N9tmxNjgi5uXEPovVDGIbQCmdtofznIn46gRUGhR2eg=;
        h=Date:To:From:Subject:From;
        b=JcxPFyuVqy9Daet1z9kH548y9UR7qD9iSji35PtnnnFbXH4v6FdYuRjNP7FaHkQK4
         k6gtYX6KtDcTVbf5VpubuWnBXXqPCbpjudQyQ4bxENeEDL8u+VNSEAN6ZsLYooCia/
         r0s2MJm1BGEKc52U8RM2gwc8feCyVXcCQ65+0uwI=
Date:   Mon, 09 May 2022 21:18:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-refactor-do_header-cpio-magic-checks.patch removed from -mm tree
Message-Id: <20220510041801.15C61C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: refactor do_header() cpio magic checks
has been removed from the -mm tree.  Its filename was
     initramfs-refactor-do_header-cpio-magic-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Disseldorp <ddiss@suse.de>
Subject: initramfs: refactor do_header() cpio magic checks

Patch series "initramfs: "crc" cpio format and INITRAMFS_PRESERVE_MTIME", v7.

This patchset does some minor initramfs refactoring and allows cpio entry
mtime preservation to be disabled via a new Kconfig
INITRAMFS_PRESERVE_MTIME option.

Patches 4/6 to 6/6 implement support for creation and extraction of "crc"
cpio archives, which carry file data checksums.  Basic tests for this
functionality can be found at https://github.com/rapido-linux/rapido/pull/163


This patch (of 6):

do_header() is called for each cpio entry and fails if the first six bytes
don't match "newc" magic.  The magic check includes a special case error
message if POSIX.1 ASCII (cpio -H odc) magic is detected.  This special
case POSIX.1 check can be nested under the "newc" mismatch code path to
avoid calling memcmp() twice in a non-error case.

Link: https://lkml.kernel.org/r/20220404093429.27570-1-ddiss@suse.de
Link: https://lkml.kernel.org/r/20220404093429.27570-2-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/init/initramfs.c~initramfs-refactor-do_header-cpio-magic-checks
+++ a/init/initramfs.c
@@ -257,12 +257,11 @@ static int __init do_collect(void)
 
 static int __init do_header(void)
 {
-	if (memcmp(collected, "070707", 6)==0) {
-		error("incorrect cpio method used: use -H newc option");
-		return 1;
-	}
 	if (memcmp(collected, "070701", 6)) {
-		error("no cpio magic");
+		if (memcmp(collected, "070707", 6) == 0)
+			error("incorrect cpio method used: use -H newc option");
+		else
+			error("no cpio magic");
 		return 1;
 	}
 	parse_header(collected);
_

Patches currently in -mm which might be from ddiss@suse.de are


