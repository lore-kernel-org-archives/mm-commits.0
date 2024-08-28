Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3365BE6C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803805; cv=none; b=X19eIpW1ViOTv1/E03TEe2iQbv/OMdeXcdEDEcc+eRPRoj39eHsA9fy2Pj8O1n1XmRreBC6V3e6dkO3K6fceVTzQHYwsvAwWZjW9hYBCEVFkWLRuAVbBbakclvDb/AM2gseOQaWiDQRnmHQixS1+yYXtXcVKnQso9NtZY2mSPIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803805; c=relaxed/simple;
	bh=XezwsPm1qAiqTGJdwTr3BjJ3e9ditbGD8hW4v3744eE=;
	h=Date:To:From:Subject:Message-Id; b=umjYrdwCkiCX83d/URbU8+QcyY8bDl9nc2ETmXuEA0b+duvaT6DRGAo5cPqVkbpZMIDaGZxv0GbFwdhl7eoHTYjSlyKm6/yZQhQaSUpcUfsjKWqbMU3yZ9bNEf0w/wc3wXf5rkQgO+XQI+hDyUXOlX6Wp7hP54eJuuFXau6pzJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q61WpxSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q61WpxSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E84C4AF61;
	Wed, 28 Aug 2024 00:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803805;
	bh=XezwsPm1qAiqTGJdwTr3BjJ3e9ditbGD8hW4v3744eE=;
	h=Date:To:From:Subject:From;
	b=Q61WpxSiKtJvCxwjf4w8XARA48lkpmUVI6ooodvLUp9znmPYzcXnQem3rSpfzbl2R
	 6jDc+Eo+Ix7ntuHDR5ZXfaqAaTi72ecUgp3TqkYGGhmyUHp3N62VPufSBHLwYPLLrx
	 3Du444lpYfJQZd7kUo9eBWPBihDfaeB35i/C7ZwA=
Date: Tue, 27 Aug 2024 17:10:04 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001005.08E84C4AF61@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch

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
Subject: nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
Date: Tue, 27 Aug 2024 02:41:13 +0900

After commit 93aef9eda1ce ("nilfs2: fix incorrect inode allocation from
reserved inodes") is applied, the inode number returned by
nilfs_ifile_create_inode() is guaranteed to always be greater than or
equal to NILFS_USER_INO, so if the inode number is a reserved inode number
(less than NILFS_USER_INO), the code to repair the bitmap immediately
following it is no longer executed.  So, delete it.

Link: https://lkml.kernel.org/r/20240826174116.5008-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode
+++ a/fs/nilfs2/inode.c
@@ -345,19 +345,6 @@ struct inode *nilfs_new_inode(struct ino
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
-
-	if (unlikely(ino < NILFS_USER_INO)) {
-		nilfs_warn(sb,
-			   "inode bitmap is inconsistent for reserved inodes");
-		do {
-			brelse(bh);
-			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
-			if (unlikely(err))
-				goto failed_ifile_create_inode;
-		} while (ino < NILFS_USER_INO);
-
-		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
-	}
 	ii->i_bh = bh;
 
 	atomic64_inc(&root->inodes_count);
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
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

