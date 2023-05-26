Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2944BC7EE2C
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 16:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjEZQtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 May 2023 12:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbjEZQtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 May 2023 12:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F18D3;
        Fri, 26 May 2023 09:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90DA664DAD;
        Fri, 26 May 2023 16:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EF1C4339B;
        Fri, 26 May 2023 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685119757;
        bh=xMkkgU7tHEseVeR1b5KRK1QPblVCYXjRfI6afyQyfS0=;
        h=Date:To:From:Subject:From;
        b=ywFHHK+jhYM4oaM+gzOmtrHF28h+YyilbDa+z5yK3giUYL78k42cetJAAwvU3COIN
         zgF/eG5gLEBHEtK/NMBCXi0R/ApIZPBz5SAiFG6/JrbwJDplnND8k66WLE5E0wKwOj
         xC+m9L+TLprmut/ICZnvBl0YdSZ5Rly76mYNDYlo=
Date:   Fri, 26 May 2023 09:49:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-reject-devices-with-insufficient-block-count.patch added to mm-hotfixes-unstable branch
Message-Id: <20230526164916.E7EF1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: reject devices with insufficient block count
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-reject-devices-with-insufficient-block-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-reject-devices-with-insufficient-block-count.patch

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
Subject: nilfs2: reject devices with insufficient block count
Date: Fri, 26 May 2023 11:13:32 +0900

The current sanity check for nilfs2 geometry information lacks checks for
the number of segments stored in superblocks, so even for device images
that have been destructively truncated or have an unusually high number of
segments, the mount operation may succeed.

This causes out-of-bounds block I/O on file system block reads or log
writes to the segments, the latter in particular causing
"a_ops->writepages" to repeatedly fail, resulting in sync_inodes_sb() to
hang.

Fix this issue by checking the number of segments stored in the superblock
and avoiding mounting devices that can cause out-of-bounds accesses.  To
eliminate the possibility of overflow when calculating the number of
blocks required for the device from the number of segments, this also adds
a helper function to calculate the upper bound on the number of segments
and inserts a check using it.

Link: https://lkml.kernel.org/r/20230526021332.3431-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+7d50f1e54a12ba3aeae2@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?extid=7d50f1e54a12ba3aeae2
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |   43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-reject-devices-with-insufficient-block-count
+++ a/fs/nilfs2/the_nilfs.c
@@ -405,6 +405,18 @@ unsigned long nilfs_nrsvsegs(struct the_
 				  100));
 }
 
+/**
+ * nilfs_max_segment_count - calculate the maximum number of segments
+ * @nilfs: nilfs object
+ */
+static u64 nilfs_max_segment_count(struct the_nilfs *nilfs)
+{
+	u64 max_count = U64_MAX;
+
+	do_div(max_count, nilfs->ns_blocks_per_segment);
+	return min_t(u64, max_count, ULONG_MAX);
+}
+
 void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs)
 {
 	nilfs->ns_nsegments = nsegs;
@@ -414,6 +426,8 @@ void nilfs_set_nsegments(struct the_nilf
 static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 				   struct nilfs_super_block *sbp)
 {
+	u64 nsegments, nblocks;
+
 	if (le32_to_cpu(sbp->s_rev_level) < NILFS_MIN_SUPP_REV) {
 		nilfs_err(nilfs->ns_sb,
 			  "unsupported revision (superblock rev.=%d.%d, current rev.=%d.%d). Please check the version of mkfs.nilfs(2).",
@@ -457,7 +471,34 @@ static int nilfs_store_disk_layout(struc
 		return -EINVAL;
 	}
 
-	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
+	nsegments = le64_to_cpu(sbp->s_nsegments);
+	if (nsegments > nilfs_max_segment_count(nilfs)) {
+		nilfs_err(nilfs->ns_sb,
+			  "segment count %llu exceeds upper limit (%llu segments)",
+			  (unsigned long long)nsegments,
+			  (unsigned long long)nilfs_max_segment_count(nilfs));
+		return -EINVAL;
+	}
+
+	nblocks = sb_bdev_nr_blocks(nilfs->ns_sb);
+	if (nblocks) {
+		u64 min_block_count = nsegments * nilfs->ns_blocks_per_segment;
+		/*
+		 * To avoid failing to mount early device images without a
+		 * second superblock, exclude that block count from the
+		 * "min_block_count" calculation.
+		 */
+
+		if (nblocks < min_block_count) {
+			nilfs_err(nilfs->ns_sb,
+				  "total number of segment blocks %llu exceeds device size (%llu blocks)",
+				  (unsigned long long)min_block_count,
+				  (unsigned long long)nblocks);
+			return -EINVAL;
+		}
+	}
+
+	nilfs_set_nsegments(nilfs, nsegments);
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch
nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl.patch
nilfs2-reject-devices-with-insufficient-block-count.patch

