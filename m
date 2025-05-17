Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1536202960
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747496366; cv=none; b=elph4e2iceJ5Io5HlrghuT5553ZIDKXw9aHwGhFq6by1bKxLFtuG6gaXuZ36vtDIP19v5Q2Pj1l47dGX/n1TEjHxtuRa7wu0n94KdVCo3NzYnsvh+mh4GCrn+BsCVqwMXjMOlCuQIqi4BFczAYvs23EnRyWI91ktzhcicZSuXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747496366; c=relaxed/simple;
	bh=YmHXLxAmP+PX3pCFpjt7MiRq87WiiS3n+kdrr2SYtKw=;
	h=Date:To:From:Subject:Message-Id; b=ECp9Ktj0vOJTfXm+gFogK5evLEVahCK5o9UPD48rWotuXuTSPipY1CNRFhc/ncd9XiJgDRlFPz0eDUhewxstoUF5tYeJwH2GZYr2QP9qLS01TfRiWQHmQsIEQhD5MtDwXFxI6JC/LiIRbRDMrUh+Mz2rvhQMif4Rw9r5QdmLC7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mDfD0ouC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mDfD0ouC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A89FC4CEE3;
	Sat, 17 May 2025 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747496366;
	bh=YmHXLxAmP+PX3pCFpjt7MiRq87WiiS3n+kdrr2SYtKw=;
	h=Date:To:From:Subject:From;
	b=mDfD0ouCU8uiVArG05+/QqC1YNW/AqOrDDVPECjjjxs4MSdH20DJdHOs6s0HQ/dRs
	 3flwTQS7JIkqgh1MF4c8U+nqxpHah3z2W8nEtMkDoN/93axdkDjvXUjE84DTIXU/C5
	 K+a5Ahgs6kSMc2Ftp/v0HW+NPgkPXuwchyeHq7uc=
Date: Sat, 17 May 2025 08:39:25 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-wbc-for_reclaim-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20250517153926.0A89FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: remove wbc->for_reclaim handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-wbc-for_reclaim-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-wbc-for_reclaim-handling.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

nilfs2-remove-wbc-for_reclaim-handling.patch

