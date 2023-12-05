Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D201BC4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjLETxg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjLETxg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:53:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6B2183
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:53:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDF5C433C8;
        Tue,  5 Dec 2023 19:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701806022;
        bh=VaKf+FrYiBCfaSaWPqWEluaAsiYBS4VobM/5bxQo0M0=;
        h=Date:To:From:Subject:From;
        b=POFZI7Lsmw9fXseT/FDHmepQxlAqVP++MMiPZ/llk8W8VMphInljuufJ/vk/gCNEo
         pdPPZLrILnLweDm6GGg0/+xclC37KMwVxvvES4soqO+WPoepOxWwzU6lxUzRpXnEAb
         BVbQJYy4RSbVTHxqUljUi5/NsB9feEZ0NZigJ4jU=
Date:   Tue, 05 Dec 2023 11:53:41 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-prevent-warning-in-nilfs_sufile_set_segment_usage.patch added to mm-hotfixes-unstable branch
Message-Id: <20231205195342.3CDF5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: prevent WARNING in nilfs_sufile_set_segment_usage()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-prevent-warning-in-nilfs_sufile_set_segment_usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-prevent-warning-in-nilfs_sufile_set_segment_usage.patch

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
Subject: nilfs2: prevent WARNING in nilfs_sufile_set_segment_usage()
Date: Tue, 5 Dec 2023 17:59:47 +0900

If nilfs2 reads a disk image with corrupted segment usage metadata, and
its segment usage information is marked as an error for the segment at the
write location, nilfs_sufile_set_segment_usage() can trigger WARN_ONs
during log writing.

Segments newly allocated for writing with nilfs_sufile_alloc() will not
have this error flag set, but this unexpected situation will occur if the
segment indexed by either nilfs->ns_segnum or nilfs->ns_nextnum (active
segment) was marked in error.

Fix this issue by inserting a sanity check to treat it as a file system
corruption.

Since error returns are not allowed during the execution phase where
nilfs_sufile_set_segment_usage() is used, this inserts the sanity check
into nilfs_sufile_mark_dirty() which pre-reads the buffer containing the
segment usage record to be updated and sets it up in a dirty state for
writing.

In addition, nilfs_sufile_set_segment_usage() is also called when
canceling log writing and undoing segment usage update, so in order to
avoid issuing the same kernel warning in that case, in case of
cancellation, avoid checking the error flag in
nilfs_sufile_set_segment_usage().

Link: https://lkml.kernel.org/r/20231205085947.4431-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+14e9f834f6ddecece094@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14e9f834f6ddecece094
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-prevent-warning-in-nilfs_sufile_set_segment_usage
+++ a/fs/nilfs2/sufile.c
@@ -501,15 +501,38 @@ int nilfs_sufile_mark_dirty(struct inode
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
-	if (!ret) {
-		mark_buffer_dirty(bh);
-		nilfs_mdt_mark_dirty(sufile);
-		kaddr = kmap_atomic(bh->b_page);
-		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+	if (ret)
+		goto out_sem;
+
+	kaddr = kmap_atomic(bh->b_page);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+	if (unlikely(nilfs_segment_usage_error(su))) {
+		struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+
+		kunmap_atomic(kaddr);
+		brelse(bh);
+		if (nilfs_segment_is_active(nilfs, segnum)) {
+			nilfs_error(sufile->i_sb,
+				    "active segment %llu is erroneous",
+				    (unsigned long long)segnum);
+		} else {
+			/*
+			 * Segments marked erroneous are never allocated by
+			 * nilfs_sufile_alloc(); only active segments, ie,
+			 * the segments indexed by ns_segnum or ns_nextnum,
+			 * can be erroneous here.
+			 */
+			WARN_ON_ONCE(1);
+		}
+		ret = -EIO;
+	} else {
 		nilfs_segment_usage_set_dirty(su);
 		kunmap_atomic(kaddr);
+		mark_buffer_dirty(bh);
+		nilfs_mdt_mark_dirty(sufile);
 		brelse(bh);
 	}
+out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
@@ -536,9 +559,14 @@ int nilfs_sufile_set_segment_usage(struc
 
 	kaddr = kmap_atomic(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
-	WARN_ON(nilfs_segment_usage_error(su));
-	if (modtime)
+	if (modtime) {
+		/*
+		 * Check segusage error and set su_lastmod only when updating
+		 * this entry with a valid timestamp, not for cancellation.
+		 */
+		WARN_ON_ONCE(nilfs_segment_usage_error(su));
 		su->su_lastmod = cpu_to_le64(modtime);
+	}
 	su->su_nblocks = cpu_to_le32(nblocks);
 	kunmap_atomic(kaddr);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-missing-error-check-for-sb_set_blocksize-call.patch
nilfs2-prevent-warning-in-nilfs_sufile_set_segment_usage.patch
nilfs2-move-page-release-outside-of-nilfs_delete_entry-and-nilfs_set_link.patch
nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

