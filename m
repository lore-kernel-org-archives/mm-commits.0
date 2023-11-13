Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BADC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 16:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjKMQeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 11:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjKMQeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 11:34:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A62EF2
        for <mm-commits@vger.kernel.org>; Mon, 13 Nov 2023 08:34:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11827C433C7;
        Mon, 13 Nov 2023 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699893249;
        bh=KpaUHavetVqItN+zJXE3ckpTSsK5ne0aKo7WWMt7f3Y=;
        h=Date:To:From:Subject:From;
        b=CGooIWQaerHvHRqRBwSU4Oz4vob79NzQFJURAjnSDJq+jOiH9mTiFNmaLahrhjxeE
         DBPiWOsW3Il1jElhNN1Yu/4HQeAiEyU/uQ7G4vzHU1XxJfHJndvxlIYq27l2rJZxmb
         cU7B9iwMePKNefAqD51E8OSPWTUrfssnUPgA5KVg=
Date:   Mon, 13 Nov 2023 08:34:08 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-variable-overflow-triggered-by-sysbot.patch added to mm-nonmm-unstable branch
Message-Id: <20231113163409.11827C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Squashfs: fix variable overflow triggered by sysbot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-variable-overflow-triggered-by-sysbot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-variable-overflow-triggered-by-sysbot.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix variable overflow triggered by sysbot
Date: Mon, 13 Nov 2023 16:09:01 +0000

Sysbot reports a slab out of bounds write in squashfs_readahead().

This is ultimately caused by a file reporting an (infeasibly) large file
size (1407374883553280 bytes) with the minimum block size of 4K.

This causes variable overflow.

Link: https://lkml.kernel.org/r/20231113160901.6444-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b1fda20609ede0d1@google.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    3 ++-
 fs/squashfs/file_direct.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-variable-overflow-triggered-by-sysbot
+++ a/fs/squashfs/file.c
@@ -544,7 +544,8 @@ static void squashfs_readahead(struct re
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
 	struct page **pages;
-	int i, file_end = i_size_read(inode) >> msblk->block_log;
+	int i;
+	loff_t file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
--- a/fs/squashfs/file_direct.c~squashfs-fix-variable-overflow-triggered-by-sysbot
+++ a/fs/squashfs/file_direct.c
@@ -26,10 +26,10 @@ int squashfs_readpage_block(struct page
 	struct inode *inode = target_page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 
-	int file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = target_page->index & ~mask;
-	int end_index = start_index | mask;
+	loff_t start_index = target_page->index & ~mask;
+	loff_t end_index = start_index | mask;
 	int i, n, pages, bytes, res = -ENOMEM;
 	struct page **page;
 	struct squashfs_page_actor *actor;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-variable-overflow-triggered-by-sysbot.patch

