From: akpm@linux-foundation.org
Subject: + writeback-fix-race-that-cause-writeback-hung.patch added to -mm tree
Date: Thu, 29 Aug 2013 12:14:50 -0700
Message-ID: <521f9daa.v963iAw+bS9szf8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3H2TOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, fengguang.wu@intel.com, junxiao.bi@oracle.com

Subject: + writeback-fix-race-that-cause-writeback-hung.patch added to -mm tree
To: junxiao.bi@oracle.com,fengguang.wu@intel.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:14:50 -0700


The patch titled
     Subject: writeback: fix race that cause writeback hung
has been added to the -mm tree.  Its filename is
     writeback-fix-race-that-cause-writeback-hung.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-race-that-cause-writeback-hung.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-race-that-cause-writeback-hung.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: writeback: fix race that cause writeback hung

There is a race between mark inode dirty and writeback thread, see the
following scenario.  In this case, writeback thread will not run though
there is dirty_io.

__mark_inode_dirty()                                          bdi_writeback_workfn()
	...                                                       	...
	spin_lock(&inode->i_lock);
	...
	if (bdi_cap_writeback_dirty(bdi)) {
	    <<< assume wb has dirty_io, so wakeup_bdi is false.
	    <<< the following inode_dirty also have wakeup_bdi false.
	    if (!wb_has_dirty_io(&bdi->wb))
		    wakeup_bdi = true;
	}
	spin_unlock(&inode->i_lock);
	                                                            <<< assume last dirty_io is removed here.
	                                                            pages_written = wb_do_writeback(wb);
	                                                            ...
	                                                            <<< work_list empty and wb has no dirty_io,
	                                                            <<< delayed_work will not be queued.
	                                                            if (!list_empty(&bdi->work_list) ||
	                                                                (wb_has_dirty_io(wb) && dirty_writeback_interval))
	                                                                queue_delayed_work(bdi_wq, &wb->dwork,
	                                                                    msecs_to_jiffies(dirty_writeback_interval * 10));
	spin_lock(&bdi->wb.list_lock);
	inode->dirtied_when = jiffies;
	<<< new dirty_io is added.
	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
	spin_unlock(&bdi->wb.list_lock);

	<<< though there is dirty_io, but wakeup_bdi is false,
	<<< so writeback thread will not be waked up and
	<<< the new dirty_io will not be flushed.
	if (wakeup_bdi)
	    bdi_wakeup_thread_delayed(bdi);

Writeback will run until there is a new flush work queued.  This may cause
a lot of dirty pages stay in memory for a long time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-race-that-cause-writeback-hung fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-race-that-cause-writeback-hung
+++ a/fs/fs-writeback.c
@@ -1171,6 +1171,8 @@ void __mark_inode_dirty(struct inode *in
 			bool wakeup_bdi = false;
 			bdi = inode_to_bdi(inode);
 
+			spin_unlock(&inode->i_lock);
+			spin_lock(&bdi->wb.list_lock);
 			if (bdi_cap_writeback_dirty(bdi)) {
 				WARN(!test_bit(BDI_registered, &bdi->state),
 				     "bdi-%s not registered\n", bdi->name);
@@ -1185,8 +1187,6 @@ void __mark_inode_dirty(struct inode *in
 					wakeup_bdi = true;
 			}
 
-			spin_unlock(&inode->i_lock);
-			spin_lock(&bdi->wb.list_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
 			spin_unlock(&bdi->wb.list_lock);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-using-i_size_read-to-access-i_size.patch
writeback-fix-race-that-cause-writeback-hung.patch
linux-next.patch

