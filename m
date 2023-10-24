Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A27EC07545
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 14:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbjJXOwr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 10:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbjJXOwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 10:52:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33613118
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 07:52:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C91C433C7;
        Tue, 24 Oct 2023 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698159163;
        bh=ely9Kn9SilC8pJ3wePVYfam6/SJvJfUFfeML7AfDc18=;
        h=Date:To:From:Subject:From;
        b=gJWCtq4Hs8Q4nKz5G/Wys0m511cITI/+kKb0tCVsjcmHE5gHn62lqXxSd4/zsM/WF
         RrbDongf6aUu7V3sbd1ZuhF4xDuBonIUJFgILcVMQTmutvrhXk8O1d/YeXI7MoqEn1
         hITYI79Bu+HeRBTDABmBMmGKtV8CWU9Mpjn8k0PM=
Date:   Tue, 24 Oct 2023 07:52:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        teawater@antgroup.com, jack@suse.cz, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch added to mm-unstable branch
Message-Id: <20231024145243.97C91C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: add __GFP_NOWARN to GFP_NOWAIT in readahead
has been added to the -mm mm-unstable branch.  Its filename is
     ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch

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

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch
ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch

