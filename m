From: akpm@linux-foundation.org
Subject: + ext2-remove-ext2_use_xip.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:11:02 -0800
Message-ID: <54b45486.3BYapZZMhbVjqPRs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbALXLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:11:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: remove ext2_use_xip
has been added to the -mm tree.  Its filename is
     ext2-remove-ext2_use_xip.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext2-remove-ext2_use_xip.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext2-remove-ext2_use_xip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: ext2: remove ext2_use_xip

Replace ext2_use_xip() with test_opt(XIP) which expands to the same code

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

 fs/ext2/ext2.h  |    4 ++++
 fs/ext2/inode.c |    2 +-
 fs/ext2/namei.c |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ext2/ext2.h~ext2-remove-ext2_use_xip fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-remove-ext2_use_xip
+++ a/fs/ext2/ext2.h
@@ -380,7 +380,11 @@ struct ext2_inode {
 #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
 #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
 #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
+#ifdef CONFIG_FS_XIP
 #define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
+#else
+#define EXT2_MOUNT_XIP			0
+#endif
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
diff -puN fs/ext2/inode.c~ext2-remove-ext2_use_xip fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-remove-ext2_use_xip
+++ a/fs/ext2/inode.c
@@ -1394,7 +1394,7 @@ struct inode *ext2_iget (struct super_bl
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
-		if (ext2_use_xip(inode->i_sb)) {
+		if (test_opt(inode->i_sb, XIP)) {
 			inode->i_mapping->a_ops = &ext2_aops_xip;
 			inode->i_fop = &ext2_xip_file_operations;
 		} else if (test_opt(inode->i_sb, NOBH)) {
diff -puN fs/ext2/namei.c~ext2-remove-ext2_use_xip fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-remove-ext2_use_xip
+++ a/fs/ext2/namei.c
@@ -105,7 +105,7 @@ static int ext2_create (struct inode * d
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (ext2_use_xip(inode->i_sb)) {
+	if (test_opt(inode->i_sb, XIP)) {
 		inode->i_mapping->a_ops = &ext2_aops_xip;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
@@ -126,7 +126,7 @@ static int ext2_tmpfile(struct inode *di
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (ext2_use_xip(inode->i_sb)) {
+	if (test_opt(inode->i_sb, XIP)) {
 		inode->i_mapping->a_ops = &ext2_aops_xip;
 		inode->i_fop = &ext2_xip_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

axonram-fix-bug-in-direct_access.patch
block-change-direct_access-calling-convention.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

