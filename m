From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-data-types.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:04 -0700
Message-ID: <200710162041.l9GKf4vn015753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935676AbXJPVGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: fix data types
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-data-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: fix data types
From: Michael Halcrow <mhalcrow@us.ibm.com>

Update data types and add casts in order to avoid potential overflow
issues.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c     |   21 +++++++++++----------
 fs/ecryptfs/mmap.c       |    5 +++--
 fs/ecryptfs/read_write.c |   11 +++++++----
 3 files changed, 21 insertions(+), 16 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-data-types fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-data-types
+++ a/fs/ecryptfs/crypto.c
@@ -149,7 +149,7 @@ out:
  * ecryptfs_derive_iv
  * @iv: destination for the derived iv vale
  * @crypt_stat: Pointer to crypt_stat struct for the current inode
- * @offset: Offset of the page whose's iv we are to derive
+ * @offset: Offset of the extent whose IV we are to derive
  *
  * Generate the initialization vector from the given root IV and page
  * offset.
@@ -157,7 +157,7 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
-			      pgoff_t offset)
+			      loff_t offset)
 {
 	int rc = 0;
 	char dst[MD5_DIGEST_SIZE];
@@ -173,7 +173,7 @@ static int ecryptfs_derive_iv(char *iv, 
 	 * hashing business. -Halcrow */
 	memcpy(src, crypt_stat->root_iv, crypt_stat->iv_bytes);
 	memset((src + crypt_stat->iv_bytes), 0, 16);
-	snprintf((src + crypt_stat->iv_bytes), 16, "%ld", offset);
+	snprintf((src + crypt_stat->iv_bytes), 16, "%lld", offset);
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(KERN_DEBUG, "source:\n");
 		ecryptfs_dump_hex(src, (crypt_stat->iv_bytes + 16));
@@ -497,11 +497,11 @@ static int ecryptfs_encrypt_extent(struc
 				   struct page *page,
 				   unsigned long extent_offset)
 {
-	unsigned long extent_base;
+	loff_t extent_base;
 	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
 	int rc;
 
-	extent_base = (page->index
+	extent_base = (((loff_t)page->index)
 		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
 	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
 				(extent_base + extent_offset));
@@ -605,8 +605,9 @@ int ecryptfs_encrypt_page(struct page *p
 			goto out;
 		}
 		ecryptfs_lower_offset_for_extent(
-			&offset, ((page->index * (PAGE_CACHE_SIZE
-						  / crypt_stat->extent_size))
+			&offset, ((((loff_t)page->index)
+				   * (PAGE_CACHE_SIZE
+				      / crypt_stat->extent_size))
 				  + extent_offset), crypt_stat);
 		rc = ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
 					  offset, crypt_stat->extent_size);
@@ -628,11 +629,11 @@ static int ecryptfs_decrypt_extent(struc
 				   struct page *enc_extent_page,
 				   unsigned long extent_offset)
 {
-	unsigned long extent_base;
+	loff_t extent_base;
 	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
 	int rc;
 
-	extent_base = (page->index
+	extent_base = (((loff_t)page->index)
 		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
 	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
 				(extent_base + extent_offset));
@@ -1471,7 +1472,7 @@ ecryptfs_write_metadata_to_contents(stru
 	while (current_header_page < header_pages) {
 		loff_t offset;
 
-		offset = (current_header_page << PAGE_CACHE_SHIFT);
+		offset = (((loff_t)current_header_page) << PAGE_CACHE_SHIFT);
 		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
 					       page_virt, offset,
 					       PAGE_CACHE_SIZE))) {
diff -puN fs/ecryptfs/mmap.c~ecryptfs-fix-data-types fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-fix-data-types
+++ a/fs/ecryptfs/mmap.c
@@ -286,7 +286,8 @@ ecryptfs_copy_up_encrypted_with_header(s
 	int rc = 0;
 
 	while (extent_num_in_page < num_extents_per_page) {
-		loff_t view_extent_num = ((page->index * num_extents_per_page)
+		loff_t view_extent_num = ((((loff_t)page->index)
+					   * num_extents_per_page)
 					  + extent_num_in_page);
 
 		if (view_extent_num < crypt_stat->num_header_extents_at_front) {
@@ -706,7 +707,7 @@ static int ecryptfs_commit_write(struct 
 				"index [0x%.16x])\n", page->index);
 		goto out;
 	}
-	pos = (page->index << PAGE_CACHE_SHIFT) + to;
+	pos = (((loff_t)page->index) << PAGE_CACHE_SHIFT) + to;
 	if (pos > i_size_read(ecryptfs_inode)) {
 		i_size_write(ecryptfs_inode, pos);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
diff -puN fs/ecryptfs/read_write.c~ecryptfs-fix-data-types fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-fix-data-types
+++ a/fs/ecryptfs/read_write.c
@@ -87,7 +87,8 @@ int ecryptfs_write_lower_page_segment(st
 	loff_t offset;
 	int rc;
 
-	offset = (page_for_lower->index << PAGE_CACHE_SHIFT) + offset_in_page;
+	offset = ((((off_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
+		  + offset_in_page);
 	virt = kmap(page_for_lower);
 	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
 	kunmap(page_for_lower);
@@ -117,7 +118,8 @@ int ecryptfs_write(struct file *ecryptfs
 {
 	struct page *ecryptfs_page;
 	char *ecryptfs_page_virt;
-	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);
+	loff_t ecryptfs_file_size =
+		i_size_read(ecryptfs_file->f_dentry->d_inode);
 	loff_t data_offset = 0;
 	loff_t pos;
 	int rc = 0;
@@ -277,7 +279,7 @@ int ecryptfs_read_lower_page_segment(str
 	loff_t offset;
 	int rc;
 
-	offset = ((page_index << PAGE_CACHE_SHIFT) + offset_in_page);
+	offset = ((((loff_t)page_index) << PAGE_CACHE_SHIFT) + offset_in_page);
 	virt = kmap(page_for_ecryptfs);
 	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
 	kunmap(page_for_ecryptfs);
@@ -306,7 +308,8 @@ int ecryptfs_read(char *data, loff_t off
 {
 	struct page *ecryptfs_page;
 	char *ecryptfs_page_virt;
-	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);
+	loff_t ecryptfs_file_size =
+		i_size_read(ecryptfs_file->f_dentry->d_inode);
 	loff_t data_offset = 0;
 	loff_t pos;
 	int rc = 0;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
