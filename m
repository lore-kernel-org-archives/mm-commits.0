From: akpm@linux-foundation.org
Subject: [merged] ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index.patch removed from -mm tree
Date: Tue, 22 Jan 2013 13:23:17 -0800
Message-ID: <20130122212317.AC25D31C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38202 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3AVVXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:23:18 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so860513ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:23:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, jack@suse.cz, mfasheh@suse.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX
has been removed from the -mm tree.  Its filename was
     ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX

This macro, initially introduced by ext2 in v0.99.15, does not have any
users from the beginning.  It has been removed in later ext2 version but
still remains in the code of ext3, ext4, ocfs2.  Remove this macro there.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    1 -
 fs/ext4/namei.c |    1 -
 fs/ocfs2/dir.c  |    1 -
 3 files changed, 3 deletions(-)

diff -puN fs/ext3/namei.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index
+++ a/fs/ext3/namei.c
@@ -36,7 +36,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext3_append(handle_t *handle,
 					struct inode *inode,
diff -puN fs/ext4/namei.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index
+++ a/fs/ext4/namei.c
@@ -47,7 +47,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
diff -puN fs/ocfs2/dir.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ext3-ext4-ocfs2-remove-unused-macro-namei_ra_index
+++ a/fs/ocfs2/dir.c
@@ -67,7 +67,6 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static unsigned char ocfs2_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

