From: akpm@linux-foundation.org
Subject: + ext3-dirindex-error-pointer-issues.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:37:26 -0800
Message-ID: <200703060337.l263bQ32010808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbXCFDii (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:38:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, adilger@clusterfs.com, dmonakhov@openvz.org, tytso@mit.edu


The patch titled
     ext3: dirindex error pointer issues
has been added to the -mm tree.  Its filename is
     ext3-dirindex-error-pointer-issues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: dirindex error pointer issues
From: Dmitriy Monakhov <dmonakhov@sw.ru>

- ext3_dx_find_entry() exit with out setting proper error pointer

- do_split() exit with out setting proper error pointer
  it is realy painful because many callers contain folowing code:

          de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
          if (!(de))
                       return retval;
          <<< WOW retval wasn't changed by do_split(), so caller failed
          <<< but return SUCCESS :)

- Rearrange do_split() error path. Current error path is realy ugly, all
  this up and down jump stuff doesn't make code easy to understand.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   26 +++++++++++++++-----------
 fs/ext4/namei.c |   26 +++++++++++++++-----------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff -puN fs/ext3/namei.c~ext3-dirindex-error-pointer-issues fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-dirindex-error-pointer-issues
+++ a/fs/ext3/namei.c
@@ -969,6 +969,7 @@ static struct buffer_head * ext3_dx_find
 				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
 					  +((char *)de - bh->b_data))) {
 				brelse (bh);
+				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
 			*res_dir = de;
@@ -1134,9 +1135,9 @@ static struct ext3_dir_entry_2 *do_split
 	char *data1 = (*bh)->b_data, *data2;
 	unsigned split;
 	struct ext3_dir_entry_2 *de = NULL, *de2;
-	int	err;
+	int	err = 0;
 
-	bh2 = ext3_append (handle, dir, &newblock, error);
+	bh2 = ext3_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1145,14 +1146,9 @@ static struct ext3_dir_entry_2 *do_split
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, *bh);
-	if (err) {
-	journal_error:
-		brelse(*bh);
-		brelse(bh2);
-		*bh = NULL;
-		ext3_std_error(dir->i_sb, err);
-		goto errout;
-	}
+	if (err)
+		goto journal_error;
+
 	BUFFER_TRACE(frame->bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, frame->bh);
 	if (err)
@@ -1195,8 +1191,16 @@ static struct ext3_dir_entry_2 *do_split
 		goto journal_error;
 	brelse (bh2);
 	dxtrace(dx_show_index ("frame", frame->entries));
-errout:
 	return de;
+
+journal_error:
+	brelse(*bh);
+	brelse(bh2);
+	*bh = NULL;
+errout:
+	ext3_std_error(dir->i_sb, err);
+	*error = err;
+	return NULL;
 }
 #endif
 
diff -puN fs/ext4/namei.c~ext3-dirindex-error-pointer-issues fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext3-dirindex-error-pointer-issues
+++ a/fs/ext4/namei.c
@@ -967,6 +967,7 @@ static struct buffer_head * ext4_dx_find
 				  (block<<EXT4_BLOCK_SIZE_BITS(sb))
 					  +((char *)de - bh->b_data))) {
 				brelse (bh);
+				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
 			*res_dir = de;
@@ -1132,9 +1133,9 @@ static struct ext4_dir_entry_2 *do_split
 	char *data1 = (*bh)->b_data, *data2;
 	unsigned split;
 	struct ext4_dir_entry_2 *de = NULL, *de2;
-	int	err;
+	int	err = 0;
 
-	bh2 = ext4_append (handle, dir, &newblock, error);
+	bh2 = ext4_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1143,14 +1144,9 @@ static struct ext4_dir_entry_2 *do_split
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, *bh);
-	if (err) {
-	journal_error:
-		brelse(*bh);
-		brelse(bh2);
-		*bh = NULL;
-		ext4_std_error(dir->i_sb, err);
-		goto errout;
-	}
+	if (err)
+		goto journal_error;
+
 	BUFFER_TRACE(frame->bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, frame->bh);
 	if (err)
@@ -1193,8 +1189,16 @@ static struct ext4_dir_entry_2 *do_split
 		goto journal_error;
 	brelse (bh2);
 	dxtrace(dx_show_index ("frame", frame->entries));
-errout:
 	return de;
+
+journal_error:
+	brelse(*bh);
+	brelse(bh2);
+	*bh = NULL;
+errout:
+	ext4_std_error(dir->i_sb, err);
+	*error = err;
+	return NULL;
 }
 #endif
 
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
