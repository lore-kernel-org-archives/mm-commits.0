Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA58F22F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849749; cv=none; b=bsQyrTfIey7oY6+Sw7QECvaiAmO29vDeOolzWtjgPtLqSTllydYCBGFsjEe+zzGBQFUCgz0E1KHpwBKygC9mP2O1vuEn0sbG4ht4Nk7EUX+sNHiC5g/REnXXPk5zx1UQUsocYhQ5wnCzrUgrrZ/HnZSUdV1HWZDGDWZmp4BQYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849749; c=relaxed/simple;
	bh=VuxEbDt8XHzB5wbofbT9uLes700BiTncNezoR4pmb+0=;
	h=Date:To:From:Subject:Message-Id; b=QpcIDPaMtzvUoHyOqbHu32MJqJgyeAQRisGd7tbTz6Geg5JtXL2CDt7TZPErjtxPnQbw57QLseF+24Y5Cr18mmoZkb4u9iUzvOcHcujOsXkljCm6+H4Sul+j8gQ9HrHE3FeRkPONCVqLLsDPs07rVyccaE2bU9YDSvAP6+e1SCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CrRMEdOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CrRMEdOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF0BC4CEE4;
	Wed, 21 May 2025 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849749;
	bh=VuxEbDt8XHzB5wbofbT9uLes700BiTncNezoR4pmb+0=;
	h=Date:To:From:Subject:From;
	b=CrRMEdOqvv6PtSEmb0RM1fi//DqLDq2qeGudMdR2f3Tv3GoTqyGMMGgfrAYUwRi/H
	 QuFW6hokq4oNyp1wsydY53IIqHCoE7f9wDBawpGn2+XSPSubZOnE6EHlHir/5KNvjP
	 y/dOdXST5TzGafoHHZtFVxHsEhAMGURXxvdrLRT0=
Date: Wed, 21 May 2025 10:49:09 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-wbc-for_reclaim-handling.patch removed from -mm tree
Message-Id: <20250521174909.ABF0BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove wbc->for_reclaim handling
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-wbc-for_reclaim-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nilfs2: remove wbc->for_reclaim handling
Date: Fri, 16 May 2025 21:31:13 +0900

Since commit 013a07052a1a ("nilfs2: convert metadata aops from writepage
to writepages"), nilfs_mdt_write_folio can't be called from reclaim
context any more.  Remove the code keyed of the wbc->for_reclaim flag,
which is now only set for writing out swap or shmem pages inside the swap
code, but never passed to file systems.

Link: https://lkml.kernel.org/r/20250508054938.15894-7-hch@lst.de
Link: https://lkml.kernel.org/r/20250516123417.6779-1-konishi.ryusuke@gmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c     |    2 --
 fs/nilfs2/segment.c |   16 ----------------
 fs/nilfs2/segment.h |    1 -
 3 files changed, 19 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-remove-wbc-for_reclaim-handling
+++ a/fs/nilfs2/mdt.c
@@ -422,8 +422,6 @@ static int nilfs_mdt_write_folio(struct
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		err = nilfs_construct_segment(sb);
-	else if (wbc->for_reclaim)
-		nilfs_flush_segment(sb, inode->i_ino);
 
 	return err;
 }
--- a/fs/nilfs2/segment.c~nilfs2-remove-wbc-for_reclaim-handling
+++ a/fs/nilfs2/segment.c
@@ -2221,22 +2221,6 @@ static void nilfs_segctor_do_flush(struc
 	spin_unlock(&sci->sc_state_lock);
 }
 
-/**
- * nilfs_flush_segment - trigger a segment construction for resource control
- * @sb: super block
- * @ino: inode number of the file to be flushed out.
- */
-void nilfs_flush_segment(struct super_block *sb, ino_t ino)
-{
-	struct the_nilfs *nilfs = sb->s_fs_info;
-	struct nilfs_sc_info *sci = nilfs->ns_writer;
-
-	if (!sci || nilfs_doing_construction())
-		return;
-	nilfs_segctor_do_flush(sci, NILFS_MDT_INODE(sb, ino) ? ino : 0);
-					/* assign bit 0 to data files */
-}
-
 struct nilfs_segctor_wait_request {
 	wait_queue_entry_t	wq;
 	__u32		seq;
--- a/fs/nilfs2/segment.h~nilfs2-remove-wbc-for_reclaim-handling
+++ a/fs/nilfs2/segment.h
@@ -226,7 +226,6 @@ extern void nilfs_relax_pressure_in_lock
 extern int nilfs_construct_segment(struct super_block *);
 extern int nilfs_construct_dsync_segment(struct super_block *, struct inode *,
 					 loff_t, loff_t);
-extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
 				void **);
 
_

Patches currently in -mm which might be from hch@lst.de are


