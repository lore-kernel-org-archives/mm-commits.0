Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB1BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiDZUrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355118AbiDZUrR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC62B1A73DD
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A52C6158A
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1697C385A4;
        Tue, 26 Apr 2022 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651005847;
        bh=BhJtQT0g9VjpJYJlWC1r5kyhMzO7D4zSaCGvuqKj8SQ=;
        h=Date:To:From:Subject:From;
        b=DSbiQQao9FJpvgTdsojVkUApmaDH72a8TkjGUs1ddiHEQhnozX0zGQf+XGJrBSdOs
         rt6uMsCnFyZ1hW++DTCcJDudIuSX1ekKJkLc0FJcJukLGh/QUWI63D9W9mkRLDEfLU
         cTi6WdzMlcdBs9UZVsDy8KfLAhIFnvScSBEeH1Xk=
Date:   Tue, 26 Apr 2022 13:44:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-refactor-do_header-cpio-magic-checks.patch added to -mm tree
Message-Id: <20220426204407.A1697C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: refactor do_header() cpio magic checks
has been added to the -mm tree.  Its filename is
     initramfs-refactor-do_header-cpio-magic-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-refactor-do_header-cpio-magic-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-refactor-do_header-cpio-magic-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

initramfs-refactor-do_header-cpio-magic-checks.patch
initramfs-make-dir_entryname-a-flexible-array-member.patch
initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
gen_init_cpio-fix-short-read-file-handling.patch
gen_init_cpio-support-file-checksum-archiving.patch
initramfs-support-cpio-extraction-with-file-checksums.patch

