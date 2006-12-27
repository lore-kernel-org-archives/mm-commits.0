From: akpm@osdl.org
Subject: + mm-ramfs-breaks-without-config_block.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:03:54 -0800
Message-ID: <200612270903.kBR93sb0006321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbWL0JEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dimitri.gorokhovik@free.fr, stable@kernel.org


The patch titled
     ramfs breaks without CONFIG_BLOCK
has been added to the -mm tree.  Its filename is
     mm-ramfs-breaks-without-config_block.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ramfs breaks without CONFIG_BLOCK
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>

ramfs doesn't provide the .set_dirty_page a_op, and when the BLOCK layer is
not configured in, 'set_page_dirty' makes a call via a NULL pointer.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ramfs/file-mmu.c   |    4 +++-
 fs/ramfs/file-nommu.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ramfs/file-mmu.c~mm-ramfs-breaks-without-config_block fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~mm-ramfs-breaks-without-config_block
+++ a/fs/ramfs/file-mmu.c
@@ -25,11 +25,13 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mm.h>
 
 const struct address_space_operations ramfs_aops = {
 	.readpage	= simple_readpage,
 	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write
+	.commit_write	= simple_commit_write,
+	.set_page_dirty = __set_page_dirty_nobuffers,
 };
 
 const struct file_operations ramfs_file_operations = {
diff -puN fs/ramfs/file-nommu.c~mm-ramfs-breaks-without-config_block fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~mm-ramfs-breaks-without-config_block
+++ a/fs/ramfs/file-nommu.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -30,7 +31,8 @@ static int ramfs_nommu_setattr(struct de
 const struct address_space_operations ramfs_aops = {
 	.readpage		= simple_readpage,
 	.prepare_write		= simple_prepare_write,
-	.commit_write		= simple_commit_write
+	.commit_write		= simple_commit_write,
+	.set_page_dirty = __set_page_dirty_nobuffers,
 };
 
 const struct file_operations ramfs_file_operations = {
_

Patches currently in -mm which might be from dimitri.gorokhovik@free.fr are

mm-ramfs-breaks-without-config_block.patch

