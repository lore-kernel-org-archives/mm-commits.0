Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4FDC25B71
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbjJYXut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbjJYXtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7AF10FB
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEA7C433CC;
        Wed, 25 Oct 2023 23:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277752;
        bh=i2D8uV9shy6QCscQADZ83xdaG/ZDC040jiOZyWuDIQU=;
        h=Date:To:From:Subject:From;
        b=Q1j/o+uumHmT2IHvmF26CWH+yRCZBmI7B7Lw1AVjSvOwGV8wbFB8Aj8nD5CSnOPPO
         OkojUlABwkDqqOXM1J2B5nusPGJ5rSYNGud7lM6tHMIcsB7I7FQoI0DYS1Mly0UJZR
         FGkON3Bqi1gUjjEg6Y8sYhvx0S8mh4LZbZygJNYg=
Date:   Wed, 25 Oct 2023 16:49:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        teawater@antgroup.com, jack@suse.cz, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch removed from -mm tree
Message-Id: <20231025234912.0BEA7C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: add __GFP_NOWARN to GFP_NOWAIT in readahead
has been removed from the -mm tree.  Its filename was
     ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ext4: add __GFP_NOWARN to GFP_NOWAIT in readahead
Date: Mon, 23 Oct 2023 23:26:08 -0700 (PDT)

Since commit e509ad4d77e6 ("ext4: use bdev_getblk() to avoid memory
reclaim in readahead path") rightly replaced GFP_NOFAIL allocations by
GFP_NOWAIT allocations, I've occasionally been seeing "page allocation
failure: order:0" warnings under load: all with
ext4_sb_breadahead_unmovable() in the stack.  I don't think those warnings
are of any interest: suppress them with __GFP_NOWARN.

Link: https://lkml.kernel.org/r/7bc6ad16-9a4d-dd90-202e-47d6cbb5a136@google.com
Fixes: e509ad4d77e6 ("ext4: use bdev_getblk() to avoid memory reclaim in readahead path")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hui Zhu <teawater@antgroup.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c~ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead
+++ a/fs/ext4/super.c
@@ -262,7 +262,7 @@ struct buffer_head *ext4_sb_bread_unmova
 void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 {
 	struct buffer_head *bh = bdev_getblk(sb->s_bdev, block,
-			sb->s_blocksize, GFP_NOWAIT);
+			sb->s_blocksize, GFP_NOWAIT | __GFP_NOWARN);
 
 	if (likely(bh)) {
 		if (trylock_buffer(bh))
_

Patches currently in -mm which might be from hughd@google.com are


