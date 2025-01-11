Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B08610D
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736562231; cv=none; b=kyi0SUsK77HwZuyjx8e7ulg/Eu27aHXbEu4B6gOm1/Pj9+JkAS9oyqrcN+qaUbGEAY9/HHikz/UNJB8w3zQNi2kjFevC6i+PAlfSFl7ssmA59LryR4x6ss5ROcUY0K4jh+umoIlaItNalEKEWppcc7TYDeoLi2knuvUxNNV8Fq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736562231; c=relaxed/simple;
	bh=0Mfc/C4uMQ9cMP1tUWgrTY7G9bCxxGsLLh2I9BhkGtk=;
	h=Date:To:From:Subject:Message-Id; b=nNWP+lFAthWwVy2TIKzJm/fZOWFy1pk4TujfGJsNio3h36/Uj0Ej+6p9rOTXAQzogauvyHFnExrYI4gngML6j8pg6r6LOiYLgJRq9fTehV+qevj7I0xM44KF9TozLpihmG8acvmFqzTD/eh6TedgER2XrWffnlOHBIIU9r232Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baEP8ww0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baEP8ww0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1938C4CED6;
	Sat, 11 Jan 2025 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736562231;
	bh=0Mfc/C4uMQ9cMP1tUWgrTY7G9bCxxGsLLh2I9BhkGtk=;
	h=Date:To:From:Subject:From;
	b=baEP8ww0lb72cu4KPvY/K1ZuGrQhkJvYb64FO5LpWmWiYttaidAtCXFPHEppA5YKU
	 ll7MIRvYoMcja7rhubo/vSPlBw8/jMyCdbzp8HkYguSWQkSPyWzbXAb4MXQ/D73kBV
	 xqWNa7ec8E/boQX/Uqm3dJrUgJj+QPBO/uLASDFw=
Date: Fri, 10 Jan 2025 18:23:50 -0800
To: mm-commits@vger.kernel.org,gissf1@gmail.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20250111022350.F1938C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: correct return value kernel-doc descriptions for bmap functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch

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
Subject: nilfs2: correct return value kernel-doc descriptions for bmap functions
Date: Fri, 10 Jan 2025 10:01:45 +0900

Similar to the previous patch to fix the ioctl return value descriptions,
this fixes the format of the return value descriptions for bmap (and
btree)-related functions, which was causing the kernel-doc script to emit
a number of warnings.

Link: https://lkml.kernel.org/r/20250110010530.21872-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: "Brian G ." <gissf1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c  |  122 ++++++++++++++++++--------------------------
 fs/nilfs2/btree.c |    7 +-
 2 files changed, 55 insertions(+), 74 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions
+++ a/fs/nilfs2/bmap.c
@@ -47,17 +47,14 @@ static int nilfs_bmap_convert_error(stru
  * @ptrp: place to store the value associated to @key
  *
  * Description: nilfs_bmap_lookup_at_level() finds a record whose key
- * matches @key in the block at @level of the bmap.
+ * matches @key in the block at @level of the bmap.  The record associated
+ * with @key is stored in the place pointed to by @ptrp.
  *
- * Return Value: On success, 0 is returned and the record associated with @key
- * is stored in the place pointed by @ptrp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			       __u64 *ptrp)
@@ -138,14 +135,11 @@ static int nilfs_bmap_do_insert(struct n
  * Description: nilfs_bmap_insert() inserts the new key-record pair specified
  * by @key and @rec into @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EEXIST - A record associated with @key already exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EEXIST	- A record associated with @key already exists.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec)
 {
@@ -193,14 +187,11 @@ static int nilfs_bmap_do_delete(struct n
  * Description: nilfs_bmap_seek_key() seeks a valid key on @bmap
  * starting from @start, and stores it to @keyp if found.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - No valid entry was found
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No valid entry was found.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp)
 {
@@ -236,14 +227,11 @@ int nilfs_bmap_last_key(struct nilfs_bma
  * Description: nilfs_bmap_delete() deletes the key-record pair specified by
  * @key from @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A record associated with @key does not exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A record associated with @key does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -290,12 +278,10 @@ static int nilfs_bmap_do_truncate(struct
  * Description: nilfs_bmap_truncate() removes key-record pairs whose keys are
  * greater than or equal to @key from @bmap.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
@@ -330,12 +316,10 @@ void nilfs_bmap_clear(struct nilfs_bmap
  * Description: nilfs_bmap_propagate() marks the buffers that directly or
  * indirectly refer to the block specified by @bh dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 {
@@ -362,22 +346,22 @@ void nilfs_bmap_lookup_dirty_buffers(str
 
 /**
  * nilfs_bmap_assign - assign a new block number to a block
- * @bmap: bmap
- * @bh: pointer to buffer head
+ * @bmap:    bmap
+ * @bh:      place to store a pointer to the buffer head to which a block
+ *           address is assigned (in/out)
  * @blocknr: block number
- * @binfo: block information
+ * @binfo:   block information
  *
  * Description: nilfs_bmap_assign() assigns the block number @blocknr to the
- * buffer specified by @bh.
- *
- * Return Value: On success, 0 is returned and the buffer head of a newly
- * create buffer and the block information associated with the buffer are
- * stored in the place pointed by @bh and @binfo, respectively. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * buffer specified by @bh.  The block information is stored in the memory
+ * pointed to by @binfo, and the buffer head may be replaced as a block
+ * address is assigned, in which case a pointer to the new buffer head is
+ * stored in the memory pointed to by @bh.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_assign(struct nilfs_bmap *bmap,
 		      struct buffer_head **bh,
@@ -402,12 +386,10 @@ int nilfs_bmap_assign(struct nilfs_bmap
  * Description: nilfs_bmap_mark() marks the block specified by @key and @level
  * as dirty.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 {
@@ -430,7 +412,7 @@ int nilfs_bmap_mark(struct nilfs_bmap *b
  * Description: nilfs_test_and_clear() is the atomic operation to test and
  * clear the dirty state of @bmap.
  *
- * Return Value: 1 is returned if @bmap is dirty, or 0 if clear.
+ * Return: 1 if @bmap is dirty, or 0 if clear.
  */
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 {
@@ -490,10 +472,10 @@ static struct lock_class_key nilfs_bmap_
  *
  * Description: nilfs_bmap_read() initializes the bmap @bmap.
  *
- * Return Value: On success, 0 is returned. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (corrupted bmap).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
--- a/fs/nilfs2/btree.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions
+++ a/fs/nilfs2/btree.c
@@ -334,7 +334,7 @@ static int nilfs_btree_node_lookup(const
  * @inode: host inode of btree
  * @blocknr: block number
  *
- * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ * Return: 0 if normal, 1 if the node is broken.
  */
 static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 				   size_t size, struct inode *inode,
@@ -366,7 +366,7 @@ static int nilfs_btree_node_broken(const
  * @node: btree root node to be examined
  * @inode: host inode of btree
  *
- * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
+ * Return: 0 if normal, 1 if the root node is broken.
  */
 static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 				   struct inode *inode)
@@ -652,8 +652,7 @@ static int nilfs_btree_do_lookup_last(co
  * @minlevel: start level
  * @nextkey: place to store the next valid key
  *
- * Return Value: If a next key was found, 0 is returned. Otherwise,
- * -ENOENT is returned.
+ * Return: 0 if the next key was found, %-ENOENT if not found.
  */
 static int nilfs_btree_get_next_key(const struct nilfs_bmap *btree,
 				    const struct nilfs_btree_path *path,
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

