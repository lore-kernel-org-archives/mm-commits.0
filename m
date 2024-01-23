Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD8256B99
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970584; cv=none; b=KIOHZz4A7/JX4qdYnwbSV5I4HhEXlOM919GGXaCt0k7Qi5P6kcvmJ//kGYfG3TbLKeDTepGgofNJTHu1DPPdhdGl+r57J+FyouL7Z/XFiVXdfz930lhQhi8diQBbdOGu7OHYizGpdztr+B8mHR+p2AJM3vVwMjNfEDUUbGjUbk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970584; c=relaxed/simple;
	bh=dhP0PPAcW2dIl+0DEdeT7B/e3o+5H1m8FL7c2734KnA=;
	h=Date:To:From:Subject:Message-Id; b=TzVni1ZlrZ7TCG7yC95bntrraDmy7huykSdd/QR8Tj6Up4yIz+7Fg68IyK8cwaRItO6j3pXCFNX3LwiQbHsArXd0UevtLA/YJwmA8SMKlc1qPEObhi+N6yfcW9Qg2JjIVRx2F70wINx8ir42vlIpwF6aXcizOHJ0nQ2VibCKBjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mnklbd3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mnklbd3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A177C433F1;
	Tue, 23 Jan 2024 00:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970583;
	bh=dhP0PPAcW2dIl+0DEdeT7B/e3o+5H1m8FL7c2734KnA=;
	h=Date:To:From:Subject:From;
	b=mnklbd3EBBJ82L9ERyhi4i9u9qfw3QYa+ZyaFIVjtrHGoCvv4uTqQow19Xh5RsO5N
	 kbTqJ1I//JOoc6Y8cH/mlojgTzh9TECveh1qNib12MwiWs0rx5XtzbH5NMvSvUhnPh
	 QfWCtHD6vqRrKWfpxL7xB26YqdFomuxyTG2mfibw=
Date: Mon, 22 Jan 2024 16:43:00 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004303.4A177C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not acquire rwsem in nilfs_bmap_write()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not acquire rwsem in nilfs_bmap_write()
Date: Mon, 22 Jan 2024 23:01:56 +0900

It is now clear that nilfs_bmap_write() is only used to finalize logs
written to disk.  Concurrent bmap modification operations are not
performed on bmaps in this context.  Additionally, this function does not
modify data used in read-only operations such as bmap lookups.

Therefore, there is no need to acquire bmap->b_sem in nilfs_bmap_write(),
so delete it.

Link: https://lkml.kernel.org/r/20240122140202.6950-10-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write
+++ a/fs/nilfs2/bmap.c
@@ -548,13 +548,10 @@ int nilfs_bmap_read(struct nilfs_bmap *b
  */
 void nilfs_bmap_write(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
-	down_write(&bmap->b_sem);
 	memcpy(raw_inode->i_bmap, bmap->b_u.u_data,
 	       NILFS_INODE_BMAP_SIZE * sizeof(__le64));
 	if (bmap->b_inode->i_ino == NILFS_DAT_INO)
 		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
-
-	up_write(&bmap->b_sem);
 }
 
 void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-recovery-logic-to-use-kmap_local.patch
nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

