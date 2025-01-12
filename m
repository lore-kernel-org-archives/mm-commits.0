Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B51C36
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 01:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736646532; cv=none; b=bIqEwEokY9teBQSS5wmJxQPiFXlKIr12MZnH3wOI0edD/UGuf/qZlm59cRBhhltMcy6eRRnkscQ1JfDApRi7zUIPLhWLkW+MjuYp1IbrwvZ5kut7TZTMutcr82Gu0yMahimiLXMw0IHehp6bx482KanTjVL73d/Ji44VHzQmwKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736646532; c=relaxed/simple;
	bh=f1ZNdoA4BCsTxiS/9RLwnEBCRIkZJCJIgk2r+4UIs/Y=;
	h=Date:To:From:Subject:Message-Id; b=mYddV0iA1sfLqxvyWnWvRgCLinu4fpkdPtl24TTaSCdMGURt+qfrxp8jRa4hrkhR/OTF5AJSw11kiJARzZIphmrmeH2Rr/rjv8OC2QFqDm0nipgoF13XJmAcxXCchn0MVCHAlAUK3Qqx0h4C5poBb8avId41/5hNbihqrL8IDtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UfeNf1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UfeNf1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43985C4CED2;
	Sun, 12 Jan 2025 01:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736646532;
	bh=f1ZNdoA4BCsTxiS/9RLwnEBCRIkZJCJIgk2r+4UIs/Y=;
	h=Date:To:From:Subject:From;
	b=1UfeNf1QFCDLcmwHpaRuwyhqsLGQRDvP3djpILqzciS93XzHbpac41GYJSDCEvVES
	 0SerMXEYY6dAwYpzDwhwfceG2vdg/uPmGJ9kZqTfAT2W3kIAeIjORUeSl6QtvrwwH7
	 SWeRL2eL8teX1lhTzvWTmxxuqs+7mL7dReUpyBBU=
Date: Sat, 11 Jan 2025 17:48:51 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch added to mm-nonmm-unstable branch
Message-Id: <20250112014852.43985C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: do not update mtime of renamed directory that is not moved
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch

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
Subject: nilfs2: do not update mtime of renamed directory that is not moved
Date: Sat, 11 Jan 2025 23:26:36 +0900

A minor issue with nilfs_rename, originating from an old ext2
implementation, is that the mtime is updated even if the rename target is
a directory and it is renamed within the same directory, rather than moved
to a different directory.

In this case, the child directory being renamed does not change in any
way, so changing its mtime is unnecessary according to the specification,
and can unnecessarily confuse backup tools.

In ext2, this issue was fixed by commit 39fe7557b4d6 ("ext2: Do not update
mtime of a moved directory") and a few subsequent fixes, but it remained
in nilfs2.

Fix this issue by not calling nilfs_set_link(), which rewrites the inode
number of the directory entry that refers to the parent directory, when
the move target is a directory and the source and destination are the same
directory.

Here, the directory to be moved only needs to be read if the inode number
of the parent directory is rewritten with nilfs_set_link, so also adjust
the execution conditions of the preparation work to avoid unnecessary
directory reads.

Link: https://lkml.kernel.org/r/20250111143518.7901-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/namei.c~nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved
+++ a/fs/nilfs2/namei.c
@@ -370,6 +370,7 @@ static int nilfs_rename(struct mnt_idmap
 	struct folio *old_folio;
 	struct nilfs_dir_entry *old_de;
 	struct nilfs_transaction_info ti;
+	bool old_is_dir = S_ISDIR(old_inode->i_mode);
 	int err;
 
 	if (flags & ~RENAME_NOREPLACE)
@@ -385,7 +386,7 @@ static int nilfs_rename(struct mnt_idmap
 		goto out;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (old_is_dir && old_dir != new_dir) {
 		err = -EIO;
 		dir_de = nilfs_dotdot(old_inode, &dir_folio);
 		if (!dir_de)
@@ -397,7 +398,7 @@ static int nilfs_rename(struct mnt_idmap
 		struct nilfs_dir_entry *new_de;
 
 		err = -ENOTEMPTY;
-		if (dir_de && !nilfs_empty_dir(new_inode))
+		if (old_is_dir && !nilfs_empty_dir(new_inode))
 			goto out_dir;
 
 		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name,
@@ -412,7 +413,7 @@ static int nilfs_rename(struct mnt_idmap
 			goto out_dir;
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
-		if (dir_de)
+		if (old_is_dir)
 			drop_nlink(new_inode);
 		drop_nlink(new_inode);
 		nilfs_mark_inode_dirty(new_inode);
@@ -420,7 +421,7 @@ static int nilfs_rename(struct mnt_idmap
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
-		if (dir_de) {
+		if (old_is_dir) {
 			inc_nlink(new_dir);
 			nilfs_mark_inode_dirty(new_dir);
 		}
@@ -434,9 +435,10 @@ static int nilfs_rename(struct mnt_idmap
 
 	err = nilfs_delete_entry(old_de, old_folio);
 	if (likely(!err)) {
-		if (dir_de) {
-			err = nilfs_set_link(old_inode, dir_de, dir_folio,
-					     new_dir);
+		if (old_is_dir) {
+			if (old_dir != new_dir)
+				err = nilfs_set_link(old_inode, dir_de,
+						     dir_folio, new_dir);
 			drop_nlink(old_dir);
 		}
 		nilfs_mark_inode_dirty(old_dir);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch
nilfs2-protect-access-to-buffers-with-no-active-references.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-ioctl-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-the-rest.patch
nilfs2-add-missing-return-value-kernel-doc-descriptions.patch
nilfs2-revise-the-return-value-description-style-for-consistency.patch
nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch
nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch

