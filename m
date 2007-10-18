From: akpm@linux-foundation.org
Subject: - make-fs-libfscsimple_commit_write-static.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:27 -0700
Message-ID: <200710180656.l9I6uRcu030702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763106AbXJRHPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make fs/libfs.c:simple_commit_write() static
has been removed from the -mm tree.  Its filename was
     make-fs-libfscsimple_commit_write-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make fs/libfs.c:simple_commit_write() static
From: Adrian Bunk <bunk@kernel.org>

simple_commit_write() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c         |    5 ++---
 include/linux/fs.h |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/libfs.c~make-fs-libfscsimple_commit_write-static fs/libfs.c
--- a/fs/libfs.c~make-fs-libfscsimple_commit_write-static
+++ a/fs/libfs.c
@@ -371,8 +371,8 @@ int simple_write_begin(struct file *file
 	return simple_prepare_write(file, page, from, from+len);
 }
 
-int simple_commit_write(struct file *file, struct page *page,
-			unsigned from, unsigned to)
+static int simple_commit_write(struct file *file, struct page *page,
+			       unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
@@ -686,7 +686,6 @@ EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_write_begin);
 EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_commit_write);
 EXPORT_SYMBOL(simple_dir_inode_operations);
 EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
diff -puN include/linux/fs.h~make-fs-libfscsimple_commit_write-static include/linux/fs.h
--- a/include/linux/fs.h~make-fs-libfscsimple_commit_write-static
+++ a/include/linux/fs.h
@@ -1886,8 +1886,6 @@ extern int simple_empty(struct dentry *)
 extern int simple_readpage(struct file *file, struct page *page);
 extern int simple_prepare_write(struct file *file, struct page *page,
 			unsigned offset, unsigned to);
-extern int simple_commit_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to);
 extern int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
