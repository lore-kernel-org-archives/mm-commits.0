From: akpm@linux-foundation.org
Subject: + nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch added to -mm tree
Date: Wed, 17 Apr 2013 12:56:41 -0700
Message-ID: <20130417195641.EF9463262B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37176 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab3DQT4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 15:56:43 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so202787qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 12:56:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, Anthony2486@interfaces.org.uk, freeboy6716@gmail.com, hermes@ceres.dti.ne.jp, konishi.ryusuke@lab.ntt.co.jp, szarpaj@grubelek.pl, zahid.chowdhury@starsolutions.com


The patch titled
     Subject: nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption
has been added to the -mm tree.  Its filename is
     nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption

DESCRIPTION:

NILFS2 driver remounts itself in RO mode in the case of metadata
corruption discovering (for example, in the case of broken bmap
discovering).  But, usually, it takes place file system operations before
remounting in RO mode.  Thereby, NILFS2 driver can be in RO mode with
presence of dirty pages in modified inodes' address spaces.  It results in
flush kernel thread's infinite trying to flush dirty pages in RO mode.  As
a result, it is possible to see such side effects as: (1) flush kernel
thread occupies 50% - 99% of CPU time; (2) system can't be shutdowned
without manual power switch off.

SYMPTOMS:
(1) System log contains error message: "Remounting filesystem read-only".
(2) The flush kernel thread occupies 50% - 99% of CPU time.
(3) The system can't be shutdowned without manual power switch off.

REPRODUCTION PATH:
(1) Create volume group with name "unencrypted" by means of vgcreate utility.
(2) Run script (prepared by Anthony Doggett <Anthony2486@interfaces.org.uk>):

----------------[BEGIN SCRIPT]--------------------
#!/bin/bash

VG=unencrypted
#apt-get install nilfs-tools darcs
lvcreate --size 2G --name ntest $VG
mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
mkdir /var/tmp/n
mkdir /var/tmp/n/ntest
mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
mkdir /var/tmp/n/ntest/thedir
cd /var/tmp/n/ntest/thedir
sleep 2
date
darcs init
sleep 2
dmesg|tail -n 5
date
darcs whatsnew || true
date
sleep 2
dmesg|tail -n 5
----------------[END SCRIPT]--------------------

(3) Try to shutdown the system.

REPRODUCIBILITY: 100%

FIX:

The patch implements checking mount state of NILFS2 driver in
nilfs_writepage(), nilfs_writepages() and nilfs_mdt_write_page() methods. 
If it is detected the RO mount state then all dirty pages are simply
discarded with warning messages is written in system log.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Anthony Doggett <Anthony2486@interfaces.org.uk>
Cc: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
Cc: Piotr Szymaniak <szarpaj@grubelek.pl>
Cc: Zahid Chowdhury <zahid.chowdhury@starsolutions.com>
Cc: Elmer Zhang <freeboy6716@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   17 ++++++++++
 fs/nilfs2/mdt.c   |   19 +++++++++--
 fs/nilfs2/page.c  |   70 ++++++++++++++++++++++++++++++++------------
 fs/nilfs2/page.h  |    3 +
 4 files changed, 86 insertions(+), 23 deletions(-)

diff -puN fs/nilfs2/inode.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption
+++ a/fs/nilfs2/inode.c
@@ -175,6 +175,11 @@ static int nilfs_writepages(struct addre
 	struct inode *inode = mapping->host;
 	int err = 0;
 
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		nilfs_clear_dirty_pages(mapping, false);
+		return -EROFS;
+	}
+
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
 						    wbc->range_start,
@@ -187,6 +192,18 @@ static int nilfs_writepage(struct page *
 	struct inode *inode = page->mapping->host;
 	int err;
 
+	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+		/*
+		 * It means that filesystem was remounted in read-only
+		 * mode because of error or metadata corruption. But we
+		 * have dirty pages that try to be flushed in background.
+		 * So, here we simply discard this dirty page.
+		 */
+		nilfs_clear_dirty_page(page, false);
+		unlock_page(page);
+		return -EROFS;
+	}
+
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 
diff -puN fs/nilfs2/mdt.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption
+++ a/fs/nilfs2/mdt.c
@@ -375,14 +375,25 @@ int nilfs_mdt_fetch_dirty(struct inode *
 static int
 nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode;
+	struct inode *inode = page->mapping->host;
 	struct super_block *sb;
 	int err = 0;
 
+	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+		/*
+		 * It means that filesystem was remounted in read-only
+		 * mode because of error or metadata corruption. But we
+		 * have dirty pages that try to be flushed in background.
+		 * So, here we simply discard this dirty page.
+		 */
+		nilfs_clear_dirty_page(page, false);
+		unlock_page(page);
+		return -EROFS;
+	}
+
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 
-	inode = page->mapping->host;
 	if (!inode)
 		return 0;
 
@@ -561,10 +572,10 @@ void nilfs_mdt_restore_from_shadow_map(s
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping);
+	nilfs_clear_dirty_pages(inode->i_mapping, true);
 	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
 
-	nilfs_clear_dirty_pages(&ii->i_btnode_cache);
+	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
 	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
diff -puN fs/nilfs2/page.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption
+++ a/fs/nilfs2/page.c
@@ -370,7 +370,12 @@ repeat:
 	goto repeat;
 }
 
-void nilfs_clear_dirty_pages(struct address_space *mapping)
+/**
+ * nilfs_clear_dirty_pages - discard dirty pages in address space
+ * @mapping: address space with dirty pages for discarding
+ * @silent: suppress [true] or print [false] warning messages
+ */
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 {
 	struct pagevec pvec;
 	unsigned int i;
@@ -382,25 +387,9 @@ void nilfs_clear_dirty_pages(struct addr
 				  PAGEVEC_SIZE)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			struct buffer_head *bh, *head;
 
 			lock_page(page);
-			ClearPageUptodate(page);
-			ClearPageMappedToDisk(page);
-			bh = head = page_buffers(page);
-			do {
-				lock_buffer(bh);
-				clear_buffer_dirty(bh);
-				clear_buffer_nilfs_volatile(bh);
-				clear_buffer_nilfs_checked(bh);
-				clear_buffer_nilfs_redirected(bh);
-				clear_buffer_uptodate(bh);
-				clear_buffer_mapped(bh);
-				unlock_buffer(bh);
-				bh = bh->b_this_page;
-			} while (bh != head);
-
-			__nilfs_clear_page_dirty(page);
+			nilfs_clear_dirty_page(page, silent);
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
@@ -408,6 +397,51 @@ void nilfs_clear_dirty_pages(struct addr
 	}
 }
 
+/**
+ * nilfs_clear_dirty_page - discard dirty page
+ * @page: dirty page that will be discarded
+ * @silent: suppress [true] or print [false] warning messages
+ */
+void nilfs_clear_dirty_page(struct page *page, bool silent)
+{
+	struct inode *inode = page->mapping->host;
+	struct super_block *sb = inode->i_sb;
+
+	BUG_ON(!test_bit(PG_locked, &page->flags));
+
+	if (!silent) {
+		nilfs_warning(sb, __func__,
+				"discard page: offset %lld, ino %lu",
+				page_offset(page), inode->i_ino);
+	}
+
+	ClearPageUptodate(page);
+	ClearPageMappedToDisk(page);
+
+	if (page_has_buffers(page)) {
+		struct buffer_head *bh, *head;
+
+		bh = head = page_buffers(page);
+		do {
+			lock_buffer(bh);
+			if (!silent) {
+				nilfs_warning(sb, __func__,
+					"discard block %llu, size %lu",
+					(u64)bh->b_blocknr, bh->b_size);
+			}
+			clear_buffer_dirty(bh);
+			clear_buffer_nilfs_volatile(bh);
+			clear_buffer_nilfs_checked(bh);
+			clear_buffer_nilfs_redirected(bh);
+			clear_buffer_uptodate(bh);
+			clear_buffer_mapped(bh);
+			unlock_buffer(bh);
+		} while (bh = bh->b_this_page, bh != head);
+	}
+
+	__nilfs_clear_page_dirty(page);
+}
+
 unsigned nilfs_page_count_clean_buffers(struct page *page,
 					unsigned from, unsigned to)
 {
diff -puN fs/nilfs2/page.h~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption fs/nilfs2/page.h
--- a/fs/nilfs2/page.h~nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption
+++ a/fs/nilfs2/page.h
@@ -55,7 +55,8 @@ void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_pages(struct address_space *);
+void nilfs_clear_dirty_page(struct page *, bool);
+void nilfs_clear_dirty_pages(struct address_space *, bool);
 void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
 			struct backing_dev_info *bdi);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-fix-potential-overflow-in-hfsplus_file_truncate.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfs-add-error-checking-for-hfs_find_init.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch

