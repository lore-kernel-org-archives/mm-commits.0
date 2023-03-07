Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7EEC678D5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjCGVjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjCGVjU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96F29224B
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64F83B81909
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20113C433D2;
        Tue,  7 Mar 2023 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678225157;
        bh=PqKA1JZc3i4xXa2V8DEc3+xOH19uoe0Mzp/6mWxLp4A=;
        h=Date:To:From:Subject:From;
        b=bj3nmh8CvWNcEcBq4P9fDAP4K6tqU0nPHpLRae1OPYbj6FBLjiqCsSmICKUzUf0t9
         McYKpxhJm3WTIM4OFk0ZK0ZQ2k1DTEOumcS+jTPEmYteb8368cDF3JJmBb+NkDqAt/
         StOTM6Mcll9V3iRs5RFf2IgbeEv79C/LhVXed2rQ=
Date:   Tue, 07 Mar 2023 13:39:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        piaojun@huawei.com, ocfs2-devel@oss.oracle.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, jack@suse.cz,
        ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
        dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch added to mm-unstable branch
Message-Id: <20230307213917.20113C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
has been added to the -mm mm-unstable branch.  Its filename is
     ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

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
Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
Date: Tue, 7 Mar 2023 15:31:24 +0100

Use filemap_write_and_wait_range to write back the range of the dirty page
instead of write_one_page in preparation of removing write_one_page and
eventually ->writepage.

Link: https://lkml.kernel.org/r/20230307143125.27778-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ retry:
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
 			if (PageDirty(page)) {
-				/*
-				 * write_on_page will unlock the page on return
-				 */
-				ret = write_one_page(page);
+				unlock_page(page);
+				put_page(page);
+
+				ret = filemap_write_and_wait_range(mapping,
+						offset, map_end - 1);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from hch@lst.de are

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch

