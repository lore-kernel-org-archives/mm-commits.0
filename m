Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26F8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357320AbiCYBb0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345861AbiCYBbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFE828E3A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AF9AB82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDBEC340EC;
        Fri, 25 Mar 2022 01:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171785;
        bh=JyBLKJR5fiip9BgnZCKo2Z7vqiDu1Az9WsRHF+9JjWU=;
        h=Date:To:From:Subject:From;
        b=EHZZkWFx5fyKyeY/vG17Sor2Q55Qlpbdxk8TUZG3SLM5bONw3Ok3F6fElSpNolnfJ
         k5cxmfHhOjNxg6BK8NQVFCnAk4bxNBacaVRv9s7mhEshcktJYg/fMznsaprX7gNC0c
         aBg1xuQoQoy7YU1HVT9buqaVTWjnfvuJR/P1N26U=
Date:   Thu, 24 Mar 2022 18:29:44 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-improve-cleanup-when-readpages-doesnt-process-all-pages.patch removed from -mm tree
Message-Id: <20220325012945.0DDBEC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve cleanup when ->readpages doesn't process all pages
has been removed from the -mm tree.  Its filename was
     mm-improve-cleanup-when-readpages-doesnt-process-all-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: improve cleanup when ->readpages doesn't process all pages

If ->readpages doesn't process all the pages, then it is best to act as
though they weren't requested so that a subsequent readahead can try
again.

So:
  - remove any 'ahead' pages from the page cache so they can be loaded
    with ->readahead() rather then multiple ->read()s
  - update the file_ra_state to reflect the reads that were actually
    submitted.

This allows ->readpages() to abort early due e.g.  to congestion, which
will then allow us to remove the inode_read_congested() test from
page_Cache_async_ra().

Link: https://lkml.kernel.org/r/164549983736.9187.16755913785880819183.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~mm-improve-cleanup-when-readpages-doesnt-process-all-pages
+++ a/mm/readahead.c
@@ -104,7 +104,13 @@
  * for necessary resources (e.g.  memory or indexing information) to
  * become available.  Pages in the final ``async_size`` may be
  * considered less urgent and failure to read them is more acceptable.
- * They will eventually be read individually using ->readpage().
+ * In this case it is best to use delete_from_page_cache() to remove the
+ * pages from the page cache as is automatically done for pages that
+ * were not fetched with readahead_page().  This will allow a
+ * subsequent synchronous read ahead request to try them again.  If they
+ * are left in the page cache, then they will be read individually using
+ * ->readpage().
+ *
  */
 
 #include <linux/kernel.h>
@@ -226,8 +232,17 @@ static void read_pages(struct readahead_
 
 	if (aops->readahead) {
 		aops->readahead(rac);
-		/* Clean up the remaining pages */
+		/*
+		 * Clean up the remaining pages.  The sizes in ->ra
+		 * maybe be used to size next read-ahead, so make sure
+		 * they accurately reflect what happened.
+		 */
 		while ((page = readahead_page(rac))) {
+			rac->ra->size -= 1;
+			if (rac->ra->async_size > 0) {
+				rac->ra->async_size -= 1;
+				delete_from_page_cache(page);
+			}
 			unlock_page(page);
 			put_page(page);
 		}
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

