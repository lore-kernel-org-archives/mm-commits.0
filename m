Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11204C3DA79
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 19:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiL2TzR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiL2TzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 14:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46662165B5
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 11:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E16D3B81A4D
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 19:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7772CC433D2;
        Thu, 29 Dec 2022 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672343707;
        bh=KkREFHM3EE5WT627YxyN5pLY0RCtA3oQbL+qmB0pgDE=;
        h=Date:To:From:Subject:From;
        b=hOtQG/eGZ7eTNcRKBUT+PzOWPkiAwwOQ+r64iELnbJdFGRsLLdFCKx3mI3OHVZ0qw
         5PEoaLC3nG2pz9+jUffnmziV8LqGT40lL+pJhOsei7ei6gm2RA6MhAxPuKzxHDmEM1
         U/iwZYoTa/W1xQACH2AF/V3LiLQh+O0jmukD7V98=
Date:   Thu, 29 Dec 2022 11:55:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch added to mm-unstable branch
Message-Id: <20221229195507.7772CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use filemap_fdatawrite_wbc instead of generic_writepages
has been added to the -mm mm-unstable branch.  Its filename is
     ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch

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
Subject: ocfs2: use filemap_fdatawrite_wbc instead of generic_writepages
Date: Thu, 29 Dec 2022 06:10:30 -1000

filemap_fdatawrite_wbc is a fairly thing wrapper around do_writepages, and
the big difference there is support for cgroup writeback, which is not
supported by ocfs2, and the potential to use ->writepages instead of
->writepage, which ocfs2 does not currently implement but eventually
should.

Link: https://lkml.kernel.org/r/20221229161031.391878-6-hch@lst.de
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


--- a/fs/ocfs2/journal.c~ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages
+++ a/fs/ocfs2/journal.c
@@ -852,7 +852,7 @@ static int ocfs2_journal_submit_inode_da
 		.range_end = jinode->i_dirty_end,
 	};
 
-	return generic_writepages(mapping, &wbc);
+	return filemap_fdatawrite_wbc(mapping, &wbc);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
_

Patches currently in -mm which might be from hch@lst.de are

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch

