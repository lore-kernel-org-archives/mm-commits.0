Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4990AC3DA7A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 19:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiL2TzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiL2TzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 14:55:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1844916596
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 11:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B89E6B818F0
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 19:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28561C433EF;
        Thu, 29 Dec 2022 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672343701;
        bh=Y4F6LdUcLifZNqf7/2aKuJgUinTjE1SjWv4u04ZeIhU=;
        h=Date:To:From:Subject:From;
        b=TYL+KWntUYfEzZKpofpGWT+tsL51qQay8BiQjWlE653gxNzh80nmPvp/Cj+nkl8MH
         QqNa6G95ugVq6Op7AhB1rUEFX85cFERz0R2d68SdVC+MYozUVrj0E9ik37oPH7XkRS
         IHtjV3QZzbqfd2BB3DQjnazHyLHybwi85DmlTLv8=
Date:   Thu, 29 Dec 2022 11:55:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-an-outdated-comment-on-mpage_writepages.patch added to mm-unstable branch
Message-Id: <20221229195501.28561C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove an outdated comment on mpage_writepages
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-an-outdated-comment-on-mpage_writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-an-outdated-comment-on-mpage_writepages.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: fs: remove an outdated comment on mpage_writepages
Date: Thu, 29 Dec 2022 06:10:26 -1000

Patch series "remove generic_writepages"

This series removes generic_writepages by open coding the current
functionality in the three remaining callers.  Besides removing some
code the main benefit is that one of the few remaining ->writepage
callers from outside the core page cache code go away.

This patch (of 6):


mpage_writepages doesn't do any of the page locking itself, so remove and
outdated comment on the locking pattern there.

Link: https://lkml.kernel.org/r/20221229161031.391878-1-hch@lst.de
Link: https://lkml.kernel.org/r/20221229161031.391878-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/mpage.c~fs-remove-an-outdated-comment-on-mpage_writepages
+++ a/fs/mpage.c
@@ -641,14 +641,6 @@ out:
  *
  * This is a library function, which implements the writepages()
  * address_space_operation.
- *
- * If a page is already under I/O, generic_writepages() skips it, even
- * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
- * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
- * and msync() need to guarantee that all the data which was dirty at the time
- * the call was made get new I/O started against them.  If wbc->sync_mode is
- * WB_SYNC_ALL then we were called for data integrity and we must wait for
- * existing IO to complete.
  */
 int
 mpage_writepages(struct address_space *mapping,
_

Patches currently in -mm which might be from hch@lst.de are

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch

