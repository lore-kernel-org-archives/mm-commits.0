Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A69EACD
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHA3kFqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35455C433C8;
	Mon, 11 Dec 2023 01:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257849;
	bh=QYQbRruQ5vkx669FV/LlQ3wGj3chQ1F493jZNhVYzUc=;
	h=Date:To:From:Subject:From;
	b=ZHA3kFqTq6DtBH0bxd7L3/HyA/AyLQU3G8t//kozX3T+HJW4yA3wsnm/YG5fzkNEW
	 0xPtnqvzEDug3HCS8ybpHHWIjHGk6eoGC6Y8Ifk7JuLbiKZCdG3ujGoYCTB8kxENki
	 OtrnYwITlqH0ZsDDnpwV5QUPFz1z5Wzvw74pFsc8=
Date: Sun, 10 Dec 2023 17:24:08 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-switch-to-kmap_local-for-directory-handling.patch removed from -mm tree
Message-Id: <20231211012409.35455C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: switch to kmap_local for directory handling
has been removed from the -mm tree.  Its filename was
     nilfs2-switch-to-kmap_local-for-directory-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: switch to kmap_local for directory handling
Date: Mon, 27 Nov 2023 23:30:27 +0900

Match ext2 by using kmap_local() instead of kmap().  This is more
efficient.  Also use unmap_and_put_page() instead of duplicating it as a
nilfs function.

[konishi.ryusuke: followed the change of page release helper call sites]
Link: https://lkml.kernel.org/r/20231127143036.2425-9-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   27 +++++++++++++--------------
 fs/nilfs2/namei.c |   12 ++++++------
 fs/nilfs2/nilfs.h |    6 ------
 3 files changed, 19 insertions(+), 26 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/dir.c
@@ -189,7 +189,7 @@ static void *nilfs_get_page(struct inode
 	if (IS_ERR(page))
 		return page;
 
-	kaddr = kmap(page);
+	kaddr = kmap_local_page(page);
 	if (unlikely(!PageChecked(page))) {
 		if (!nilfs_check_page(page, kaddr))
 			goto fail;
@@ -199,7 +199,7 @@ static void *nilfs_get_page(struct inode
 	return kaddr;
 
 fail:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return ERR_PTR(-EIO);
 }
 
@@ -287,7 +287,7 @@ static int nilfs_readdir(struct file *fi
 		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
 			if (de->rec_len == 0) {
 				nilfs_error(sb, "zero-length directory entry");
-				nilfs_put_page(page);
+				unmap_and_put_page(page, kaddr);
 				return -EIO;
 			}
 			if (de->inode) {
@@ -300,13 +300,13 @@ static int nilfs_readdir(struct file *fi
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					return 0;
 				}
 			}
 			ctx->pos += nilfs_rec_len_from_disk(de->rec_len);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 0;
 }
@@ -352,14 +352,14 @@ nilfs_find_entry(struct inode *dir, cons
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			nilfs_put_page(page);
+			unmap_and_put_page(page, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -399,8 +399,7 @@ ino_t nilfs_inode_by_name(struct inode *
 	de = nilfs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le64_to_cpu(de->inode);
-		kunmap(page);
-		put_page(page);
+		unmap_and_put_page(page, de);
 	}
 	return res;
 }
@@ -484,7 +483,7 @@ int nilfs_add_link(struct dentry *dentry
 			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
 		}
 		unlock_page(page);
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	BUG();
 	return -EINVAL;
@@ -512,7 +511,7 @@ got_it:
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 out:
 	return err;
 out_unlock:
@@ -609,10 +608,10 @@ fail:
 int nilfs_empty_dir(struct inode *inode)
 {
 	struct page *page = NULL;
+	char *kaddr;
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
-		char *kaddr;
 		struct nilfs_dir_entry *de;
 
 		kaddr = nilfs_get_page(inode, i, &page);
@@ -644,12 +643,12 @@ int nilfs_empty_dir(struct inode *inode)
 			}
 			de = nilfs_next_entry(de);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 1;
 
 not_empty:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return 0;
 }
 
--- a/fs/nilfs2/namei.c~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/namei.c
@@ -280,7 +280,7 @@ static int nilfs_do_unlink(struct inode
 		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 	if (err)
 		goto out;
 
@@ -387,7 +387,7 @@ static int nilfs_rename(struct mnt_idmap
 		if (!new_de)
 			goto out_dir;
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
-		nilfs_put_page(new_page);
+		unmap_and_put_page(new_page, new_de);
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -414,10 +414,10 @@ static int nilfs_rename(struct mnt_idmap
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
-		nilfs_put_page(dir_page);
+		unmap_and_put_page(dir_page, dir_de);
 		drop_nlink(old_dir);
 	}
-	nilfs_put_page(old_page);
+	unmap_and_put_page(old_page, old_de);
 
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
@@ -427,9 +427,9 @@ static int nilfs_rename(struct mnt_idmap
 
 out_dir:
 	if (dir_de)
-		nilfs_put_page(dir_page);
+		unmap_and_put_page(dir_page, dir_de);
 out_old:
-	nilfs_put_page(old_page);
+	unmap_and_put_page(old_page, old_de);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
--- a/fs/nilfs2/nilfs.h~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/nilfs.h
@@ -237,12 +237,6 @@ extern struct nilfs_dir_entry *nilfs_dot
 extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
-static inline void nilfs_put_page(struct page *page)
-{
-	kunmap(page);
-	put_page(page);
-}
-
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

