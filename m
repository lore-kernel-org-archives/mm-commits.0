Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF64C7EE25
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 20:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243872AbjEOUJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 16:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbjEOUJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 16:09:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC77D11608;
        Mon, 15 May 2023 13:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9F462552;
        Mon, 15 May 2023 20:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FAAC4339B;
        Mon, 15 May 2023 20:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684181338;
        bh=Ad5P9Rjhn0R7rSISLqLbL+wOWQTGjqXUcsHSR9iOe90=;
        h=Date:To:From:Subject:From;
        b=u6MoxiN9nsiYriHJ9IPsZox9g/57OzNpNsZAhQrnKuqq/G/g6ojszsq/JTqLirXGb
         QZDfzQkhJp+KWvhrVv5OwaDWRBRT5w31HLAwF3ZtXBXlQqbyocNGps/Onu0eTjsVD5
         yyEVXRAHo9q8Vi/1z69HsxnkazuqePGCZw5PgEs0=
Date:   Mon, 15 May 2023 13:08:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch added to mm-hotfixes-unstable branch
Message-Id: <20230515200858.D3FAAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix incomplete buffer cleanup in nilfs_btnode_abort_change_key()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix incomplete buffer cleanup in nilfs_btnode_abort_change_key()
Date: Sat, 13 May 2023 19:24:28 +0900

A syzbot fault injection test reported that nilfs_btnode_create_block, a
helper function that allocates a new node block for b-trees, causes a
kernel BUG for disk images where the file system block size is smaller
than the page size.

This was due to unexpected flags on the newly allocated buffer head, and
it turned out to be because the buffer flags were not cleared by
nilfs_btnode_abort_change_key() after an error occurred during a b-tree
update operation and the buffer was later reused in that state.

Fix this issue by using nilfs_btnode_delete() to abandon the unused
preallocated buffer in nilfs_btnode_abort_change_key().

Link: https://lkml.kernel.org/r/20230513102428.10223-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b0a35a5c1f7e846d3b09@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000d1d6c205ebc4d512@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key
+++ a/fs/nilfs2/btnode.c
@@ -285,6 +285,14 @@ void nilfs_btnode_abort_change_key(struc
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		xa_erase_irq(&btnc->i_pages, newkey);
 		unlock_page(ctxt->bh->b_page);
-	} else
-		brelse(nbh);
+	} else {
+		/*
+		 * When canceling a buffer that a prepare operation has
+		 * allocated to copy a node block to another location, use
+		 * nilfs_btnode_delete() to initialize and release the buffer
+		 * so that the buffer flags will not be in an inconsistent
+		 * state when it is reallocated.
+		 */
+		nilfs_btnode_delete(nbh);
+	}
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode.patch
nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch

