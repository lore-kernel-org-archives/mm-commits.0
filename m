From: akpm@linux-foundation.org
Subject: - afs-convert-to-new-aops-update.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:57:27 -0700
Message-ID: <200810152357.m9FNvRUN024518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbYJOX6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     afs-convert-to-new-aops update
has been removed from the -mm tree.  Its filename was
     afs-convert-to-new-aops-update.patch

This patch was dropped because it was folded into afs-convert-to-new-aops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs-convert-to-new-aops update
From: David Howells <dhowells@redhat.com>

David sent a secretly different version.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/afs/write.c~afs-convert-to-new-aops-update fs/afs/write.c
--- a/fs/afs/write.c~afs-convert-to-new-aops-update
+++ a/fs/afs/write.c
@@ -84,7 +84,7 @@ void afs_put_writeback(struct afs_writeb
  * partly or wholly fill a page that's under preparation for writing
  */
 static int afs_fill_page(struct afs_vnode *vnode, struct key *key,
-			loff_t pos, unsigned len, struct page *page)
+			 loff_t pos, unsigned len, struct page *page)
 {
 	loff_t i_size;
 	unsigned eof;
@@ -118,16 +118,16 @@ static int afs_fill_page(struct afs_vnod
  * prepare to perform part of a write to a page
  */
 int afs_write_begin(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned flags,
-			struct page **pagep, void **fsdata)
+		    loff_t pos, unsigned len, unsigned flags,
+		    struct page **pagep, void **fsdata)
 {
-	struct page *page;
 	struct afs_writeback *candidate, *wb;
 	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
+	struct page *page;
 	struct key *key = file->private_data;
-	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned to = from + len;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	int ret;
 
 	_enter("{%x:%u},{%lx},%u,%u",
@@ -244,8 +244,8 @@ flush_conflicting_wb:
  * finalise part of a write to a page
  */
 int afs_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
+		  loff_t pos, unsigned len, unsigned copied,
+		  struct page *page, void *fsdata)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
 	loff_t i_size, maybe_i_size;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
sysctl-simplify-strategy.patch
afs-convert-to-new-aops.patch
afs-convert-to-new-aops-update.patch

