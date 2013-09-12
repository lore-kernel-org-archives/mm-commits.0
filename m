From: akpm@linux-foundation.org
Subject: [merged] mm-writeback-make-writeback_inodes_wb-static.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:05 -0700
Message-ID: <523219c1.hFwSjjy85G2drgH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3ILTpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, jkosina@suse.cz, isimatu.yasuaki@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, fengguang.wu@intel.com, dave.hansen@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-writeback-make-writeback_inodes_wb-static.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,dave.hansen@linux.intel.com,fengguang.wu@intel.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,isimatu.yasuaki@jp.fujitsu.com,jkosina@suse.cz,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:05 -0700


The patch titled
     Subject: mm/writeback: make writeback_inodes_wb static
has been removed from the -mm tree.  Its filename was
     mm-writeback-make-writeback_inodes_wb-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/writeback: make writeback_inodes_wb static

It's not used globally and could be static.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~mm-writeback-make-writeback_inodes_wb-static fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-writeback-make-writeback_inodes_wb-static
+++ a/fs/fs-writeback.c
@@ -723,7 +723,7 @@ static long __writeback_inodes_wb(struct
 	return wrote;
 }
 
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
+static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason)
 {
 	struct wb_writeback_work work = {
diff -puN include/linux/writeback.h~mm-writeback-make-writeback_inodes_wb-static include/linux/writeback.h
--- a/include/linux/writeback.h~mm-writeback-make-writeback_inodes_wb-static
+++ a/include/linux/writeback.h
@@ -98,8 +98,6 @@ int try_to_writeback_inodes_sb(struct su
 int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
-				enum wb_reason reason);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

