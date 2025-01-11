Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A92033A
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736562236; cv=none; b=YHYZFUR/z8e9uH2u/60Q/VIcfSU7z3qX6IorRs2gU6tDzFiIRUgwGEY1SqTw2grMM1o1buus3+7jJvZt6le9Dlf36P0eYg/+G+chylmVNNycY4bpbOzNwkqUxbh7qq6xfwEyuFUrPFqunR1ARFr0Qz5+9ElqwoZOoNdwxCas6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736562236; c=relaxed/simple;
	bh=z/6RtEyCVg7DHpPLYqgHz5GtYXlu8UDmTZow3WLQabk=;
	h=Date:To:From:Subject:Message-Id; b=qhyYM6oYD4FknA+zhjUiit0p7B33vmSUvU1j5wiQDfH3CZ8YgUflCdKUYTfugVOPHrp2i2fZkFAUg6fSKzS74ndox+A8LNg9NyeXRO8ow5p0VfmxqesRlet7hhT0jwBRee0tanyH4BpRAQTdBMRc5JzsUBdhH1SZCbjgEGSYsZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PR9MgtkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PR9MgtkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0119C4CED6;
	Sat, 11 Jan 2025 02:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736562235;
	bh=z/6RtEyCVg7DHpPLYqgHz5GtYXlu8UDmTZow3WLQabk=;
	h=Date:To:From:Subject:From;
	b=PR9MgtkVlMrE6EvGpDrxBplcG2RKvXukPeV6iqwZXyBnt2xAWsD7VQsXbMGjG0hk1
	 JZcZqdqvXhgp75EvUGceZJGO4GGw8OQ+1089Sq77b9F2d0rnUitOkUpJMTWVkKs0oc
	 gz/2mzZ+D3F7uYi06BHFJbA8u73/qCq79b43qySg=
Date: Fri, 10 Jan 2025 18:23:55 -0800
To: mm-commits@vger.kernel.org,gissf1@gmail.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch added to mm-nonmm-unstable branch
Message-Id: <20250111022355.C0119C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: correct return value kernel-doc descriptions for metadata files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch

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
Subject: nilfs2: correct return value kernel-doc descriptions for metadata files
Date: Fri, 10 Jan 2025 10:01:47 +0900

Similar to the previous changes to fix return value descriptions, this
fixes the format of the return value descriptions for metadata file
functions other than sufile.

Link: https://lkml.kernel.org/r/20250110010530.21872-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: "Brian G ." <gissf1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   51 +++++++++++++---------------------
 fs/nilfs2/dat.c    |   40 ++++++++++-----------------
 fs/nilfs2/ifile.c  |   34 ++++++++++-------------
 fs/nilfs2/mdt.c    |   63 +++++++++++++++++++------------------------
 4 files changed, 80 insertions(+), 108 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files
+++ a/fs/nilfs2/cpfile.c
@@ -191,14 +191,11 @@ static inline int nilfs_cpfile_get_check
  * @cnop: place to store the next checkpoint number
  * @bhp: place to store a pointer to buffer_head struct
  *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - no block exists in the range.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- no block exists in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_cpfile_find_checkpoint_block(struct inode *cpfile,
 					      __u64 start_cno, __u64 end_cno,
@@ -447,14 +444,11 @@ error:
  * the period from @start to @end, excluding @end itself. The checkpoints
  * which have been already deleted are ignored.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - invalid checkpoints.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid checkpoints.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 				    __u64 start,
@@ -1058,14 +1052,11 @@ int nilfs_cpfile_is_snapshot(struct inod
  * Description: nilfs_change_cpmode() changes the mode of the checkpoint
  * specified by @cno. The mode @mode is NILFS_CHECKPOINT or NILFS_SNAPSHOT.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - No such checkpoint.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No such checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 {
@@ -1097,14 +1088,12 @@ int nilfs_cpfile_change_cpmode(struct in
  * @cpstat: pointer to a structure of checkpoint statistics
  *
  * Description: nilfs_cpfile_get_stat() returns information about checkpoints.
+ * The checkpoint statistics are stored in the location pointed to by @cpstat.
  *
- * Return Value: On success, 0 is returned, and checkpoints information is
- * stored in the place pointed by @cpstat. On error, one of the following
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
 int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 {
--- a/fs/nilfs2/dat.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files
+++ a/fs/nilfs2/dat.c
@@ -302,14 +302,11 @@ int nilfs_dat_mark_dirty(struct inode *d
  * Description: nilfs_dat_freev() frees the virtual block numbers specified by
  * @vblocknrs and @nitems.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The virtual block number have not been allocated.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The virtual block number have not been allocated.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 {
@@ -325,12 +322,10 @@ int nilfs_dat_freev(struct inode *dat, _
  * Description: nilfs_dat_move() changes the block number associated with
  * @vblocknr to @blocknr.
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
 int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 {
@@ -390,17 +385,14 @@ int nilfs_dat_move(struct inode *dat, __
  * @blocknrp: pointer to a block number
  *
  * Description: nilfs_dat_translate() maps the virtual block number @vblocknr
- * to the corresponding block number.
- *
- * Return Value: On success, 0 is returned and the block number associated
- * with @vblocknr is stored in the place pointed by @blocknrp. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * to the corresponding block number.  The block number associated with
+ * @vblocknr is stored in the place pointed to by @blocknrp.
  *
- * %-ENOENT - A block number associated with @vblocknr does not exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A block number associated with @vblocknr does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 {
--- a/fs/nilfs2/ifile.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files
+++ a/fs/nilfs2/ifile.c
@@ -38,17 +38,16 @@ static inline struct nilfs_ifile_info *N
  * @out_ino: pointer to a variable to store inode number
  * @out_bh: buffer_head contains newly allocated disk inode
  *
- * Return Value: On success, 0 is returned and the newly allocated inode
- * number is stored in the place pointed by @ino, and buffer_head pointer
- * that contains newly allocated disk inode structure is stored in the
- * place pointed by @out_bh
- * On error, one of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - No inode left.
+ * nilfs_ifile_create_inode() allocates a new inode in the ifile metadata
+ * file and stores the inode number in the variable pointed to by @out_ino,
+ * as well as storing the ifile's buffer with the disk inode in the location
+ * pointed to by @out_bh.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No inode left.
  */
 int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 			     struct buffer_head **out_bh)
@@ -83,14 +82,11 @@ int nilfs_ifile_create_inode(struct inod
  * @ifile: ifile inode
  * @ino: inode number
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The inode number @ino have not been allocated.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Inode number unallocated.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 {
--- a/fs/nilfs2/mdt.c~nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files
+++ a/fs/nilfs2/mdt.c
@@ -226,20 +226,21 @@ static int nilfs_mdt_read_block(struct i
  * @out_bh: output of a pointer to the buffer_head
  *
  * nilfs_mdt_get_block() looks up the specified buffer and tries to create
- * a new buffer if @create is not zero.  On success, the returned buffer is
- * assured to be either existing or formatted using a buffer lock on success.
- * @out_bh is substituted only when zero is returned.
- *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - the specified block does not exist (hole block)
- *
- * %-EROFS - Read only filesystem (for create mode)
+ * a new buffer if @create is not zero.  If (and only if) this function
+ * succeeds, it stores a pointer to the retrieved buffer head in the location
+ * pointed to by @out_bh.
+ *
+ * The retrieved buffer may be either an existing one or a newly allocated one.
+ * For a newly created buffer, if the callback function argument @init_block
+ * is non-NULL, the callback will be called with the buffer locked to format
+ * the block.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The specified block does not exist (hole block).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EROFS	- Read only filesystem (for create mode).
  */
 int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 			void (*init_block)(struct inode *,
@@ -275,14 +276,11 @@ int nilfs_mdt_get_block(struct inode *in
  * @out_bh, and block offset to @blkoff, respectively.  @out_bh and
  * @blkoff are substituted only when zero is returned.
  *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - no block was found in the range
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No block was found in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
 			 unsigned long end, unsigned long *blkoff,
@@ -321,12 +319,11 @@ out:
  * @inode: inode of the meta data file
  * @block: block offset
  *
- * Return Value: On success, zero is returned.
- * On error, one of the following negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Non-existent block.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 {
@@ -349,12 +346,10 @@ int nilfs_mdt_delete_block(struct inode
  * nilfs_mdt_forget_block() clears a dirty flag of the specified buffer, and
  * tries to release the page including the buffer from a page cache.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-EBUSY - page has an active buffer.
- *
- * %-ENOENT - page cache has no page addressed by the offset.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Page has an active buffer.
+ * * %-ENOENT	- Page cache has no page addressed by the offset.
  */
 int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 {
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

