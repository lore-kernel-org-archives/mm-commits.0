Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBAB170826
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742286; cv=none; b=FAXtbCrm0DJovZlXak4bMNvXoAhwU3RVV32f5cam89mNAPkm3zgKJSWffqqTc0EBKxXsvGGYrfXGTUjss8e3IxpNj+FvMrIFNzmB5p5I1ZSIOdguiub2t7NNUVUpu2JiDhql8LaIq5Bj29+hpjyEYVEYNqkSSNo99NWVVlEk4Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742286; c=relaxed/simple;
	bh=wGJwR8U3SavizCZWrHbFd2ZcCgMUMXZite40EMEEpoY=;
	h=Date:To:From:Subject:Message-Id; b=INTi9d/b3vyoLffYMrCqrb4gvKNVtJyByHG3x8lQvOZZ5TGT3OahXwYHfKIMSmrZM1oc9QuYdv8pX0KBFy46IZEXyhQKZD62PeXmNm0zCCzJSl1iqJPYBYF9zAYQ0TXJ3QpqynHBAqv4o+RJIO031uKPOKNE2wIqkZlDmx6muOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMkuphck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMkuphck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65325C4CED6;
	Mon, 13 Jan 2025 04:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742286;
	bh=wGJwR8U3SavizCZWrHbFd2ZcCgMUMXZite40EMEEpoY=;
	h=Date:To:From:Subject:From;
	b=fMkuphckE5ks6GNSS7RA/raiyqGd3oOorX2QsJpzIE/PZHNHXkHQg7PR43BSYlPH7
	 bduCapR9zNmPcNSQD3OrYfT+V+yqRcYNs5ap101Q1RDEInp4AHH1utNEmaHAzM91pP
	 0B5pmHsmm/bBcTOl8uRZ2AOtDPSNQtdeYB+Qf1PQ=
Date: Sun, 12 Jan 2025 20:24:45 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch removed from -mm tree
Message-Id: <20250113042446.65325C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not update mtime of renamed directory that is not moved
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-update-mtime-of-renamed-directory-that-is-not-moved.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


