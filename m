From: akpm@linux-foundation.org
Subject: + make-fs-libfscsimple_commit_write-static.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:56:39 -0700
Message-ID: <200708162056.l7GKud1d006296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763793AbXHPU5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     make fs/libfs.c:simple_commit_write() static
has been added to the -mm tree.  Its filename is
     make-fs-libfscsimple_commit_write-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1869,8 +1869,6 @@ extern int simple_empty(struct dentry *)
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

alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
