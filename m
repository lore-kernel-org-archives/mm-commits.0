From: akpm@linux-foundation.org
Subject: [merged] ext2-remove-ext2_aops_xip.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:57 -0800
Message-ID: <54e39f25.tBDBx6qsIt34/HYc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: remove ext2_aops_xip
has been removed from the -mm tree.  Its filename was
     ext2-remove-ext2_aops_xip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: ext2: remove ext2_aops_xip

We shouldn't need a special address_space_operations any more

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h  |    1 -
 fs/ext2/inode.c |    7 +------
 fs/ext2/namei.c |    4 ++--
 3 files changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/ext2/ext2.h~ext2-remove-ext2_aops_xip fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-remove-ext2_aops_xip
+++ a/fs/ext2/ext2.h
@@ -796,7 +796,6 @@ extern const struct file_operations ext2
 
 /* inode.c */
 extern const struct address_space_operations ext2_aops;
-extern const struct address_space_operations ext2_aops_xip;
 extern const struct address_space_operations ext2_nobh_aops;
 
 /* namei.c */
diff -puN fs/ext2/inode.c~ext2-remove-ext2_aops_xip fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-remove-ext2_aops_xip
+++ a/fs/ext2/inode.c
@@ -891,11 +891,6 @@ const struct address_space_operations ex
 	.error_remove_page	= generic_error_remove_page,
 };
 
-const struct address_space_operations ext2_aops_xip = {
-	.bmap			= ext2_bmap,
-	.direct_IO		= ext2_direct_IO,
-};
-
 const struct address_space_operations ext2_nobh_aops = {
 	.readpage		= ext2_readpage,
 	.readpages		= ext2_readpages,
@@ -1394,7 +1389,7 @@ struct inode *ext2_iget (struct super_bl
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
 		if (test_opt(inode->i_sb, XIP)) {
-			inode->i_mapping->a_ops = &ext2_aops_xip;
+			inode->i_mapping->a_ops = &ext2_aops;
 			inode->i_fop = &ext2_xip_file_operations;
 		} else if (test_opt(inode->i_sb, NOBH)) {
 			inode->i_mapping->a_ops = &ext2_nobh_aops;
diff -puN fs/ext2/namei.c~ext2-remove-ext2_aops_xip fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-remove-ext2_aops_xip
+++ a/fs/ext2/namei.c
@@ -105,7 +105,7 @@ static int ext2_create (struct inode * d
 
 	inode->i_op = &ext2_file_inode_operations;
 	if (test_opt(inode->i_sb, XIP)) {
-		inode->i_mapping->a_ops = &ext2_aops_xip;
+		inode->i_mapping->a_ops = &ext2_aops;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
@@ -126,7 +126,7 @@ static int ext2_tmpfile(struct inode *di
 
 	inode->i_op = &ext2_file_inode_operations;
 	if (test_opt(inode->i_sb, XIP)) {
-		inode->i_mapping->a_ops = &ext2_aops_xip;
+		inode->i_mapping->a_ops = &ext2_aops;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

