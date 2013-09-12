From: akpm@linux-foundation.org
Subject: [merged] writeback-fix-occasional-slow-sync1.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:44:41 -0700
Message-ID: <523219a9.sWU4A6J7cxzlZhCk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ILTol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, taysom@chromium.org, fengguang.wu@intel.com, jack@suse.cz

Subject: [merged] writeback-fix-occasional-slow-sync1.patch removed from -mm tree
To: jack@suse.cz,fengguang.wu@intel.com,taysom@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:41 -0700


The patch titled
     Subject: writeback: fix occasional slow sync(1)
has been removed from the -mm tree.  Its filename was
     writeback-fix-occasional-slow-sync1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: fix occasional slow sync(1)

In case when system contains no dirty pages, wakeup_flusher_threads() will
submit WB_SYNC_NONE writeback for 0 pages so wb_writeback() exits
immediately without doing anything, even though there are dirty inodes in
the system.  Thus sync(1) will write all the dirty inodes from a
WB_SYNC_ALL writeback pass which is slow.

Fix the problem by using get_nr_dirty_pages() in wakeup_flusher_threads()
instead of calculating number of dirty pages manually.  That function also
takes number of dirty inodes into account.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Paul Taysom <taysom@chromium.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-occasional-slow-sync1 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-occasional-slow-sync1
+++ a/fs/fs-writeback.c
@@ -1049,10 +1049,8 @@ void wakeup_flusher_threads(long nr_page
 {
 	struct backing_dev_info *bdi;
 
-	if (!nr_pages) {
-		nr_pages = global_page_state(NR_FILE_DIRTY) +
-				global_page_state(NR_UNSTABLE_NFS);
-	}
+	if (!nr_pages)
+		nr_pages = get_nr_dirty_pages();
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

