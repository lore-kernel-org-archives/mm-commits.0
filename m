Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B14170826
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742285; cv=none; b=GSvB7e0x3egg6RXPPH9oQ4zzV7yYq+FeT0mqWgqmDP8xC/Q9RW8njp51E18mtSL7GkmZyKqe9v3/LxKT5RkCkXIjQ/bL7aZFuMVGhqY7v9MLuRSsn3boGfSMUxze16et6WCVzPrbytoEUZf4DSjMPacujobaWRokzZSPXKuEqGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742285; c=relaxed/simple;
	bh=ml30+EGJ3kStjy8xjYBepW6gUvKXDQ7X9Sard2GWln0=;
	h=Date:To:From:Subject:Message-Id; b=UzOHX3ij+87d/KwMF9sTbuN6Rovwc+FWT2Ht856u3JQetY5YioK2t+T2Wfs6p9rUk0FDXfAIeALo2mHOcHEfztwYAl8Oes1GM+x5v5lzp0itIYSFvRn/+FF1zdx+NcGcZ2R1AqzfdRI/y4tGtxQRkzAsks3ga9otFfiHFEI8dWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRz1PeKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRz1PeKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6FAC4CED6;
	Mon, 13 Jan 2025 04:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742285;
	bh=ml30+EGJ3kStjy8xjYBepW6gUvKXDQ7X9Sard2GWln0=;
	h=Date:To:From:Subject:From;
	b=VRz1PeKg/3yDKhKjEjx/INg1B5tid9n4Frz8BKLZaB2jUd7QaW6oVHuZFw5tnzepV
	 IR3oP4vtBNPqtIe/B0qBgks9RBdu3d8OdlsSf2WTxI1o/C6XbbE+7pDQmBxNwOUDdr
	 UVNCBPYhKKvquS5J9JFiYT7TfK3Dp01IGiejwWoY=
Date: Sun, 12 Jan 2025 20:24:44 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch removed from -mm tree
Message-Id: <20250113042445.4D6FAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: handle errors that nilfs_prepare_chunk() may return
has been removed from the -mm tree.  Its filename was
     nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: handle errors that nilfs_prepare_chunk() may return
Date: Sat, 11 Jan 2025 23:26:35 +0900

Patch series "nilfs2: fix issues with rename operations".

This series fixes BUG_ON check failures reported by syzbot around rename
operations, and a minor behavioral issue where the mtime of a child
directory changes when it is renamed instead of moved.


This patch (of 2):

The directory manipulation routines nilfs_set_link() and
nilfs_delete_entry() rewrite the directory entry in the folio/page
previously read by nilfs_find_entry(), so error handling is omitted on the
assumption that nilfs_prepare_chunk(), which prepares the buffer for
rewriting, will always succeed for these.  And if an error is returned, it
triggers the legacy BUG_ON() checks in each routine.

This assumption is wrong, as proven by syzbot: the buffer layer called by
nilfs_prepare_chunk() may call nilfs_get_block() if necessary, which may
fail due to metadata corruption or other reasons.  This has been there all
along, but improved sanity checks and error handling may have made it more
reproducible in fuzzing tests.

Fix this issue by adding missing error paths in nilfs_set_link(),
nilfs_delete_entry(), and their caller nilfs_rename().

Link: https://lkml.kernel.org/r/20250111143518.7901-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250111143518.7901-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32c3706ebf5d95046ea1
Reported-by: syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1097e95f134f37d9395c
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   13 ++++++++++---
 fs/nilfs2/namei.c |   29 +++++++++++++++--------------
 fs/nilfs2/nilfs.h |    4 ++--
 3 files changed, 27 insertions(+), 19 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return
+++ a/fs/nilfs2/dir.c
@@ -400,7 +400,7 @@ int nilfs_inode_by_name(struct inode *di
 	return 0;
 }
 
-void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct folio *folio, struct inode *inode)
 {
 	size_t from = offset_in_folio(folio, de);
@@ -410,11 +410,15 @@ void nilfs_set_link(struct inode *dir, s
 
 	folio_lock(folio);
 	err = nilfs_prepare_chunk(folio, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		folio_unlock(folio);
+		return err;
+	}
 	de->inode = cpu_to_le64(inode->i_ino);
 	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
+	return 0;
 }
 
 /*
@@ -543,7 +547,10 @@ int nilfs_delete_entry(struct nilfs_dir_
 		from = (char *)pde - kaddr;
 	folio_lock(folio);
 	err = nilfs_prepare_chunk(folio, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		folio_unlock(folio);
+		goto out;
+	}
 	if (pde)
 		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
--- a/fs/nilfs2/namei.c~nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return
+++ a/fs/nilfs2/namei.c
@@ -406,8 +406,10 @@ static int nilfs_rename(struct mnt_idmap
 			err = PTR_ERR(new_de);
 			goto out_dir;
 		}
-		nilfs_set_link(new_dir, new_de, new_folio, old_inode);
+		err = nilfs_set_link(new_dir, new_de, new_folio, old_inode);
 		folio_release_kmap(new_folio, new_de);
+		if (unlikely(err))
+			goto out_dir;
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -430,28 +432,27 @@ static int nilfs_rename(struct mnt_idmap
 	 */
 	inode_set_ctime_current(old_inode);
 
-	nilfs_delete_entry(old_de, old_folio);
-
-	if (dir_de) {
-		nilfs_set_link(old_inode, dir_de, dir_folio, new_dir);
-		folio_release_kmap(dir_folio, dir_de);
-		drop_nlink(old_dir);
+	err = nilfs_delete_entry(old_de, old_folio);
+	if (likely(!err)) {
+		if (dir_de) {
+			err = nilfs_set_link(old_inode, dir_de, dir_folio,
+					     new_dir);
+			drop_nlink(old_dir);
+		}
+		nilfs_mark_inode_dirty(old_dir);
 	}
-	folio_release_kmap(old_folio, old_de);
-
-	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
-	err = nilfs_transaction_commit(old_dir->i_sb);
-	return err;
-
 out_dir:
 	if (dir_de)
 		folio_release_kmap(dir_folio, dir_de);
 out_old:
 	folio_release_kmap(old_folio, old_de);
 out:
-	nilfs_transaction_abort(old_dir->i_sb);
+	if (likely(!err))
+		err = nilfs_transaction_commit(old_dir->i_sb);
+	else
+		nilfs_transaction_abort(old_dir->i_sb);
 	return err;
 }
 
--- a/fs/nilfs2/nilfs.h~nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return
+++ a/fs/nilfs2/nilfs.h
@@ -261,8 +261,8 @@ struct nilfs_dir_entry *nilfs_find_entry
 int nilfs_delete_entry(struct nilfs_dir_entry *, struct folio *);
 int nilfs_empty_dir(struct inode *);
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct folio **);
-void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
-			   struct folio *, struct inode *);
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+		   struct folio *folio, struct inode *inode);
 
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


