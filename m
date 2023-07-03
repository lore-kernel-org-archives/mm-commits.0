Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B1AEB64D9
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 00:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjGCAEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 20:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGCAEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 20:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D4C1B7
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE2960C83
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 00:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE188C433C7;
        Mon,  3 Jul 2023 00:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688342663;
        bh=koQAgVUQ2/0B/+5sAoIBlDvPZtBcZ4A2IqeT3ryV9DQ=;
        h=Date:To:From:Subject:From;
        b=zLmCbmkgwSBTy9PCKXty6sN3SehNnpM5DdPwvvH9XaYYh8yuABx6+HRYkbQ6UIaQ8
         vWRyGMXCMihFkT5e5PnkrqdK4p8LSQyQ+rxXX0J90z0fVFZJXSuyC/t7ZXC+PhaKTo
         4NzLVi05JVgOm0szXZFNAnq8IXlloLvJ9aNiTr84=
Date:   Sun, 02 Jul 2023 17:04:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, ocfs2-devel@oss.oracle.com,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, hch@lst.de, brauner@kernel.org, beanhuo@micron.com,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-clean-up-block_commit_write-fix.patch added to mm-unstable branch
Message-Id: <20230703000422.EE188C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-buffer-clean-up-block_commit_write-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-clean-up-block_commit_write-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-clean-up-block_commit_write-fix.patch

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
Subject: fs-buffer-clean-up-block_commit_write-fix
Date: Sun Jul  2 05:03:36 PM PDT 2023

remove now-unused local `inode'

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Luís Henriques <ocfs2-devel@oss.oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/buffer.c~fs-buffer-clean-up-block_commit_write-fix
+++ a/fs/buffer.c
@@ -2252,7 +2252,6 @@ int block_write_end(struct file *file, s
 			struct page *page, void *fsdata)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = mapping->host;
 	size_t start = pos - folio_pos(folio);
 
 	if (unlikely(copied < len)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch

