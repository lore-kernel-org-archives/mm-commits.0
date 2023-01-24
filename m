Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D66C54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 21:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjAXVEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbjAXVEW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 16:04:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCC649001
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 13:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52DEBB816DD
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 21:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06666C433D2;
        Tue, 24 Jan 2023 21:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674594257;
        bh=JF6IZ0Vicvv+2jG0Zhx5N6QlxmWyzTSmde/SoLu0kPo=;
        h=Date:To:From:Subject:From;
        b=1MQGvYS10BhYYH2ANPet+PPwLbpZtCjo8TEWgNLpzEbrl3xno19/ktUTLbVN9TeOH
         pc4ZPgp1bA4ExX6IOpiuJR6PNppud+4OvnO32L9HHPP2m0femB6G+W37tFsinDQkFI
         cEFCOpDjy1R6s3X/MYvyGHNx914Vj9wCtdEcXrFc=
Date:   Tue, 24 Jan 2023 13:04:16 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        ebiggers@kernel.org, chao@kernel.org, adilger.kernel@dilger.ca,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch added to mm-nonmm-unstable branch
Message-Id: <20230124210417.06666C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: hfs: initialize fsdata in hfs_file_truncate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: fs: hfs: initialize fsdata in hfs_file_truncate()
Date: Mon, 21 Nov 2022 12:21:33 +0100

When aops->write_begin() does not initialize fsdata, KMSAN may report an
error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Link: https://lkml.kernel.org/r/20221121112134.407362-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/extent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfs/extent.c~fs-hfs-initialize-fsdata-in-hfs_file_truncate
+++ a/fs/hfs/extent.c
@@ -486,7 +486,7 @@ void hfs_file_truncate(struct inode *ino
 		inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
-		void *fsdata;
+		void *fsdata = NULL;
 		struct page *page;
 
 		/* XXX: Can use generic_cont_expand? */
_

Patches currently in -mm which might be from glider@google.com are

revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch
kmsan-silence-wmissing-prototypes-warnings.patch
fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch
fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate.patch

