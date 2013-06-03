From: akpm@linux-foundation.org
Subject: + fs-fs-writebackc-make-wb_do_writeback-as-static.patch added to
 -mm tree
Date: Mon, 03 Jun 2013 16:45:05 -0700
Message-ID: <51ad2a81.9iB2FBURi2k29TeN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3FCXpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 19:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, fengguang.wu@intel.com, haicheng.li@linux.intel.com

Subject: + fs-fs-writebackc-make-wb_do_writeback-as-static.patch added to -mm tree
To: haicheng.li@linux.intel.com,fengguang.wu@intel.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 16:45:05 -0700


The patch titled
     Subject: fs/fs-writeback.c: : make wb_do_writeback() as static
has been added to the -mm tree.  Its filename is
     fs-fs-writebackc-make-wb_do_writeback-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haicheng Li <haicheng.li@linux.intel.com>
Subject: fs/fs-writeback.c: : make wb_do_writeback() as static

It's not used globally and could be static.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~fs-fs-writebackc-make-wb_do_writeback-as-static fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fs-writebackc-make-wb_do_writeback-as-static
+++ a/fs/fs-writeback.c
@@ -959,7 +959,7 @@ static long wb_check_old_data_flush(stru
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
@@ -94,7 +94,6 @@ int try_to_writeback_inodes_sb_nr(struct
 void sync_inodes_sb(struct super_block *);
 long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
_

Patches currently in -mm which might be from haicheng.li@linux.intel.com are

linux-next.patch
fs-fs-writebackc-make-wb_do_writeback-as-static.patch

