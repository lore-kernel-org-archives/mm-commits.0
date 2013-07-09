From: akpm@linux-foundation.org
Subject: [merged] fs-fs-writebackc-make-wb_do_writeback-as-static.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:03 -0700
Message-ID: <51dc9aa3.moPeJ24sys97RkBt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3GIXUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, jack@suse.cz, fengguang.wu@intel.com, haicheng.li@linux.intel.com

Subject: [merged] fs-fs-writebackc-make-wb_do_writeback-as-static.patch removed from -mm tree
To: haicheng.li@linux.intel.com,fengguang.wu@intel.com,jack@suse.cz,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:03 -0700


The patch titled
     Subject: fs/fs-writeback.c: : make wb_do_writeback() as static
has been removed from the -mm tree.  Its filename was
     fs-fs-writebackc-make-wb_do_writeback-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haicheng Li <haicheng.li@linux.intel.com>
Subject: fs/fs-writeback.c: : make wb_do_writeback() as static

It's not used globally and could be static.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~fs-fs-writebackc-make-wb_do_writeback-as-static fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fs-writebackc-make-wb_do_writeback-as-static
+++ a/fs/fs-writeback.c
@@ -963,7 +963,7 @@ static long wb_check_old_data_flush(stru
 /*
  * Retrieve work items and do the writeback they describe
  */
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct wb_writeback_work *work;
diff -puN include/linux/writeback.h~fs-fs-writebackc-make-wb_do_writeback-as-static include/linux/writeback.h
--- a/include/linux/writeback.h~fs-fs-writebackc-make-wb_do_writeback-as-static
+++ a/include/linux/writeback.h
@@ -95,7 +95,6 @@ int try_to_writeback_inodes_sb_nr(struct
 void sync_inodes_sb(struct super_block *);
 long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
_

Patches currently in -mm which might be from haicheng.li@linux.intel.com are

origin.patch
linux-next.patch

