Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10946175AD;
	Fri,  4 Oct 2024 03:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728014144; cv=none; b=OfPWEK0wQp17CtXeil4dPqEG31Kbc6qDAicnPIS0BjKIFmXybltFxiZO3+76GWunfsobGEqEk4HwYYSyvBarMjTNG0xllHmyLeN4kzaa35sbb2ISW3ZoBQNuGD7FH/Gqjcn7ZfFMV2jwe9oiKYtmSh8zuCZBSWXZ4TOB4wicCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728014144; c=relaxed/simple;
	bh=CT6Z7a5LWnzPyuGN8gyUKsOkCOF+7zrH9Yw7SB/ytS8=;
	h=Date:To:From:Subject:Message-Id; b=TYDjsw+ljWH2LfehFaMFH5WwlxepkSj54NPhpNyKYknvOIYBNAHELyHSnQI4xa3fBqbIZyDhRyt1/1VE2uTbGWqongyt64X11jmo317WEMcZHjzPlhsMGf5scttBg07J96fZSRgUYqZdIrZlO8WnNmY0v/flMO97VBRZaslSoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BluC7je9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BluC7je9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86257C4CEC6;
	Fri,  4 Oct 2024 03:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728014143;
	bh=CT6Z7a5LWnzPyuGN8gyUKsOkCOF+7zrH9Yw7SB/ytS8=;
	h=Date:To:From:Subject:From;
	b=BluC7je9bl4B9DpIZBnnqNsGYMfBZmH7cf6H2XKoKfVUHcOH9AvPu2fcDWWJhRVXe
	 qOQCRK7PNznROXM98j2eoW00D1daxs+cZ99pEomvs9ltjim0UmE6MhSoQOcSYYES+t
	 rkacNtk4GwQPz34jCDWzRbvee55rxeQ3/fY41Phg=
Date: Thu, 03 Oct 2024 20:55:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-propagate-directory-read-errors-from-nilfs_find_entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20241004035543.86257C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: propagate directory read errors from nilfs_find_entry()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-propagate-directory-read-errors-from-nilfs_find_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-propagate-directory-read-errors-from-nilfs_find_entry.patch

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
Subject: nilfs2: propagate directory read errors from nilfs_find_entry()
Date: Fri, 4 Oct 2024 12:35:31 +0900

Syzbot reported that a task hang occurs in vcs_open() during a fuzzing
test for nilfs2.

The root cause of this problem is that in nilfs_find_entry(), which
searches for directory entries, ignores errors when loading a directory
page/folio via nilfs_get_folio() fails.

If the filesystem images is corrupted, and the i_size of the directory
inode is large, and the directory page/folio is successfully read but
fails the sanity check, for example when it is zero-filled,
nilfs_check_folio() may continue to spit out error messages in bursts.

Fix this issue by propagating the error to the callers when loading a
page/folio fails in nilfs_find_entry().

The current interface of nilfs_find_entry() and its callers is outdated
and cannot propagate error codes such as -EIO and -ENOMEM returned via
nilfs_find_entry(), so fix it together.

Link: https://lkml.kernel.org/r/20241004033640.6841-1-konishi.ryusuke@gmail.com
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Lizhi Xu <lizhi.xu@windriver.com>
Closes: https://lkml.kernel.org/r/20240927013806.3577931-1-lizhi.xu@windriver.com
Reported-by: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8a192e8d090fa9a31135
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   48 ++++++++++++++++++++++----------------------
 fs/nilfs2/namei.c |   39 +++++++++++++++++++++++------------
 fs/nilfs2/nilfs.h |    2 -
 3 files changed, 52 insertions(+), 37 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-propagate-directory-read-errors-from-nilfs_find_entry
+++ a/fs/nilfs2/dir.c
@@ -289,7 +289,7 @@ static int nilfs_readdir(struct file *fi
  * The folio is mapped and unlocked.  When the caller is finished with
  * the entry, it should call folio_release_kmap().
  *
- * On failure, returns NULL and the caller should ignore foliop.
+ * On failure, returns an error pointer and the caller should ignore foliop.
  */
 struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 		const struct qstr *qstr, struct folio **foliop)
@@ -312,22 +312,24 @@ struct nilfs_dir_entry *nilfs_find_entry
 	do {
 		char *kaddr = nilfs_get_folio(dir, n, foliop);
 
-		if (!IS_ERR(kaddr)) {
-			de = (struct nilfs_dir_entry *)kaddr;
-			kaddr += nilfs_last_byte(dir, n) - reclen;
-			while ((char *) de <= kaddr) {
-				if (de->rec_len == 0) {
-					nilfs_error(dir->i_sb,
-						"zero-length directory entry");
-					folio_release_kmap(*foliop, kaddr);
-					goto out;
-				}
-				if (nilfs_match(namelen, name, de))
-					goto found;
-				de = nilfs_next_entry(de);
+		if (IS_ERR(kaddr))
+			return ERR_CAST(kaddr);
+
+		de = (struct nilfs_dir_entry *)kaddr;
+		kaddr += nilfs_last_byte(dir, n) - reclen;
+		while ((char *)de <= kaddr) {
+			if (de->rec_len == 0) {
+				nilfs_error(dir->i_sb,
+					    "zero-length directory entry");
+				folio_release_kmap(*foliop, kaddr);
+				goto out;
 			}
-			folio_release_kmap(*foliop, kaddr);
+			if (nilfs_match(namelen, name, de))
+				goto found;
+			de = nilfs_next_entry(de);
 		}
+		folio_release_kmap(*foliop, kaddr);
+
 		if (++n >= npages)
 			n = 0;
 		/* next folio is past the blocks we've got */
@@ -340,7 +342,7 @@ struct nilfs_dir_entry *nilfs_find_entry
 		}
 	} while (n != start);
 out:
-	return NULL;
+	return ERR_PTR(-ENOENT);
 
 found:
 	ei->i_dir_start_lookup = n;
@@ -384,18 +386,18 @@ fail:
 	return NULL;
 }
 
-ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino)
 {
-	ino_t res = 0;
 	struct nilfs_dir_entry *de;
 	struct folio *folio;
 
 	de = nilfs_find_entry(dir, qstr, &folio);
-	if (de) {
-		res = le64_to_cpu(de->inode);
-		folio_release_kmap(folio, de);
-	}
-	return res;
+	if (IS_ERR(de))
+		return PTR_ERR(de);
+
+	*ino = le64_to_cpu(de->inode);
+	folio_release_kmap(folio, de);
+	return 0;
 }
 
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
--- a/fs/nilfs2/namei.c~nilfs2-propagate-directory-read-errors-from-nilfs_find_entry
+++ a/fs/nilfs2/namei.c
@@ -55,12 +55,20 @@ nilfs_lookup(struct inode *dir, struct d
 {
 	struct inode *inode;
 	ino_t ino;
+	int res;
 
 	if (dentry->d_name.len > NILFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ino = nilfs_inode_by_name(dir, &dentry->d_name);
-	inode = ino ? nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino) : NULL;
+	res = nilfs_inode_by_name(dir, &dentry->d_name, &ino);
+	if (res) {
+		if (res != -ENOENT)
+			return ERR_PTR(res);
+		inode = NULL;
+	} else {
+		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+	}
+
 	return d_splice_alias(inode, dentry);
 }
 
@@ -263,10 +271,11 @@ static int nilfs_do_unlink(struct inode
 	struct folio *folio;
 	int err;
 
-	err = -ENOENT;
 	de = nilfs_find_entry(dir, &dentry->d_name, &folio);
-	if (!de)
+	if (IS_ERR(de)) {
+		err = PTR_ERR(de);
 		goto out;
+	}
 
 	inode = d_inode(dentry);
 	err = -EIO;
@@ -362,10 +371,11 @@ static int nilfs_rename(struct mnt_idmap
 	if (unlikely(err))
 		return err;
 
-	err = -ENOENT;
 	old_de = nilfs_find_entry(old_dir, &old_dentry->d_name, &old_folio);
-	if (!old_de)
+	if (IS_ERR(old_de)) {
+		err = PTR_ERR(old_de);
 		goto out;
+	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
 		err = -EIO;
@@ -382,10 +392,12 @@ static int nilfs_rename(struct mnt_idmap
 		if (dir_de && !nilfs_empty_dir(new_inode))
 			goto out_dir;
 
-		err = -ENOENT;
-		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name, &new_folio);
-		if (!new_de)
+		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name,
+					  &new_folio);
+		if (IS_ERR(new_de)) {
+			err = PTR_ERR(new_de);
 			goto out_dir;
+		}
 		nilfs_set_link(new_dir, new_de, new_folio, old_inode);
 		folio_release_kmap(new_folio, new_de);
 		nilfs_mark_inode_dirty(new_dir);
@@ -440,12 +452,13 @@ out:
  */
 static struct dentry *nilfs_get_parent(struct dentry *child)
 {
-	unsigned long ino;
+	ino_t ino;
+	int res;
 	struct nilfs_root *root;
 
-	ino = nilfs_inode_by_name(d_inode(child), &dotdot_name);
-	if (!ino)
-		return ERR_PTR(-ENOENT);
+	res = nilfs_inode_by_name(d_inode(child), &dotdot_name, &ino);
+	if (res)
+		return ERR_PTR(res);
 
 	root = NILFS_I(d_inode(child))->i_root;
 
--- a/fs/nilfs2/nilfs.h~nilfs2-propagate-directory-read-errors-from-nilfs_find_entry
+++ a/fs/nilfs2/nilfs.h
@@ -254,7 +254,7 @@ static inline __u32 nilfs_mask_flags(umo
 
 /* dir.c */
 int nilfs_add_link(struct dentry *, struct inode *);
-ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino);
 int nilfs_make_empty(struct inode *, struct inode *);
 struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const struct qstr *,
 		struct folio **);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-propagate-directory-read-errors-from-nilfs_find_entry.patch

