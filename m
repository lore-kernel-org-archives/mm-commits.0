Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372927462
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 01:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736646530; cv=none; b=I0msev0S82kcCoEmIKCm5txOy1m/tqwRyuD2pR5L4i449aF2Jo1tTqNrr5vIA+BhcghsfeOgJLauyUW+wYaR5BB2DcUxAqaI9q4qtQkbwADNh25uU1fYUQEH8Bi7YD287BQNXS2aIOPONgI7LDAMLPVh11j0hZ/ZZpc5b0gVCv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736646530; c=relaxed/simple;
	bh=0Viu2+kxrjwneC9SFi7Zv4Bb7pAn8J2DGCnJlfnW0mI=;
	h=Date:To:From:Subject:Message-Id; b=KsM4eCK/W1OMxM38LILoXStB2mnLzFHzaQiL8WvSb8W2lo7a6rhsKNpj8vx82bbZgu33xUthPB8LJzxYpKHl/2HOZfv5wEQSr7jHBu/OK0XD6SzlQzRmFnV3A1YPxTCneKrtel0v+V5aukUGwzqGOrNCjnPOzkQi7BON7DYAwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X23v5Bqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X23v5Bqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B03C4CED2;
	Sun, 12 Jan 2025 01:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736646529;
	bh=0Viu2+kxrjwneC9SFi7Zv4Bb7pAn8J2DGCnJlfnW0mI=;
	h=Date:To:From:Subject:From;
	b=X23v5Bqoy29Id2cULV1rSzrQTPeDE79yedX8A1MRs1TjITcH9o36floqK08t8YoCs
	 +WkOLFKvVWqUwRH3wX/8DH9/wGZkzsuFrtcrOJNUfrglXMJPOuYlkM7hfTwH0TWNHg
	 xLl6yNbb9S9JJnXlZBoQ5hUWGKnAj7BkkrTxPJDI=
Date: Sat, 11 Jan 2025 17:48:48 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch added to mm-nonmm-unstable branch
Message-Id: <20250112014849.82B03C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: handle errors that nilfs_prepare_chunk() may return
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-handle-errors-that-nilfs_prepare_chunk-may-return.patch

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

