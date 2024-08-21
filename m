Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC70175D42
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275445; cv=none; b=hvTuVrpT3QgqgKpod8IJom4IXKJeREbtpupzXaeg3V7CZq3O8zLiac6xfEGfPbWXmVahkUTb7pDgifekflFbZH9ATIzdeEZqQRRDXqh2cRTbdCYPqp5RY8Vw/2nDTPDsxDkJugFJMvXPJeC9MhTQkjuozHT2JuSSzIhZIR98jHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275445; c=relaxed/simple;
	bh=IdEmJUdQJ6573Va1OiFC0aMrGvaG6wcqWmLwWUZ10XQ=;
	h=Date:To:From:Subject:Message-Id; b=XKK/K3Ej3kVq2h9tp79AFHJJ51InrOohCRTpNiZhW15Koca5sdnblG4dQsJGt2UYkjTyUa7pG7aFUGDue01eSa4TJTRWMZjd/N1wY/5nBIp8cC36NFRhX3l+B8udXKv02uaWY9MDw7ge2QlVtp12gcDa1lMUWuurZPc86AuFP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aU0OiSrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aU0OiSrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318DFC4AF0E;
	Wed, 21 Aug 2024 21:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275445;
	bh=IdEmJUdQJ6573Va1OiFC0aMrGvaG6wcqWmLwWUZ10XQ=;
	h=Date:To:From:Subject:From;
	b=aU0OiSrL63LtrMGfX/U68p28c5RVSqmuWn6yvsN8/A8ZxaaPa2O/JZzhteI3XHIzR
	 LF6lse9ZibhSAr/mjus/PJSU94CkKRCeaSCOoxV7HHwJIvuywHlbwm241qXSCdB78P
	 cZCTLZSC3KWVR+KwwtQbhoUB2i7vmLEdjn11TIxQ=
Date: Wed, 21 Aug 2024 14:24:04 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212405.318DFC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

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
Subject: nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
Date: Thu, 22 Aug 2024 00:46:27 +0900

nilfs_sufile_mark_dirty(), which marks a block in the sufile metadata file
as dirty in preparation for log writing, returns -ENOENT to the caller if
the block containing the segment usage of the specified segment is
missing.

This internal code can propagate through the log writer to system calls
such as fsync.  To prevent this, treat this case as a filesystem error and
return -EIO instead.

Link: https://lkml.kernel.org/r/20240821154627.11848-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/sufile.c~nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty
+++ a/fs/nilfs2/sufile.c
@@ -513,8 +513,15 @@ int nilfs_sufile_mark_dirty(struct inode
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
-	if (ret)
+	if (unlikely(ret)) {
+		if (ret == -ENOENT) {
+			nilfs_error(sufile->i_sb,
+				    "segment usage for segment %llu is unreadable due to a hole block",
+				    (unsigned long long)segnum);
+			ret = -EIO;
+		}
 		goto out_sem;
+	}
 
 	kaddr = kmap_local_page(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

