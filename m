From: akpm@linux-foundation.org
Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
 added to -mm tree
Date: Wed, 09 Oct 2013 14:21:29 -0700
Message-ID: <5255c8d9.4ZhbYq/hV7obXtgm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3JIVVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Oct 2013 17:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, dchinner@redhat.com, jack@suse.cz

Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch added to -mm tree
To: jack@suse.cz,dchinner@redhat.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Wed, 09 Oct 2013 14:21:29 -0700


The patch titled
     Subject: writeback: use older_than_this_is_set instead of magic older_than_this == 0
has been added to the -mm tree.  Its filename is
     writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: use older_than_this_is_set instead of magic older_than_this == 0

Currently we use 0 as a special value of work->older_than_this to
indicate that wb_writeback() should set work->older_that_this to current
time. This works but it is a bit magic. So use a special flag in
work_struct for that.

Also fixup writeback from workqueue rescuer to include all inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix
+++ a/fs/fs-writeback.c
@@ -39,6 +39,10 @@
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
+	/*
+	 * Write only inodes dirtied before this time. Don't forget to set
+	 * older_than_this_is_set when you set this.
+	 */
 	unsigned long older_than_this;
 	enum writeback_sync_modes sync_mode;
 	unsigned int tagged_writepages:1;
@@ -46,6 +50,7 @@ struct wb_writeback_work {
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
+	unsigned int older_than_this_is_set:1;
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -732,6 +737,8 @@ static long writeback_inodes_wb(struct b
 		.sync_mode	= WB_SYNC_NONE,
 		.range_cyclic	= 1,
 		.reason		= reason,
+		.older_than_this = jiffies,
+		.older_than_this_is_set = 1,
 	};
 
 	spin_lock(&wb->list_lock);
@@ -793,7 +800,7 @@ static long wb_writeback(struct bdi_writ
 	struct inode *inode;
 	long progress;
 
-	if (!work->older_than_this)
+	if (!work->older_than_this_is_set)
 		work->older_than_this = jiffies;
 
 	spin_lock(&wb->list_lock);
@@ -1356,6 +1363,7 @@ void sync_inodes_sb(struct super_block *
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_pages	= LONG_MAX,
 		.older_than_this = older_than_this,
+		.older_than_this_is_set = 1,
 		.range_cyclic	= 0,
 		.done		= &done,
 		.reason		= WB_REASON_SYNC,
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-dont-spam-on-edquot.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
linux-next.patch

