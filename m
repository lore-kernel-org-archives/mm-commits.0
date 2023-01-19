Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401D7C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjASBUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjASBSH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5318E6923B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A8461B16
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A458C433F0;
        Thu, 19 Jan 2023 01:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090945;
        bh=GO6cZKliCFJweE/XT5+Oe6A8xLK3ENu4tFCocxDCZac=;
        h=Date:To:From:Subject:From;
        b=IMfZJzyctlPrFxN2FUYYtTmqZzMPi5Iu2Ke0bh4xEvSO26eO9Z4PqTG/cF8JbZy9u
         ltjXztqBKJMX0oVnx3urvfT7NQYlqAEhh4JphpuVSynDg4GT5QhPCw6u/Ub6bczFZG
         lHaabNsxLnYO7qNDXfMPS57GHZ5PPHxOzo4maqHM=
Date:   Wed, 18 Jan 2023 17:15:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, almaz.alexandrovich@paragon-software.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch removed from -mm tree
Message-Id: <20230119011545.0A458C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: use filemap_fdatawrite_wbc instead of generic_writepages
has been removed from the -mm tree.  Its filename was
     ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


