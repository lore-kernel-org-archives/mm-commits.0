From: akpm@linux-foundation.org
Subject: + ocfs2-implement-ocfs2_direct_io_write-fix.patch added to -mm
 tree
Date: Wed, 03 Dec 2014 14:02:16 -0800
Message-ID: <547f8868.2Y+p8HIEThyWhsst%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaLCWCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 17:02:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix brelse warning if ocfs2_direct_IO_get_blocks failed
has been added to the -mm tree.  Its filename is
     ocfs2-implement-ocfs2_direct_io_write-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-implement-ocfs2_direct_io_write-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-implement-ocfs2_direct_io_write-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix brelse warning if ocfs2_direct_IO_get_blocks failed

In ocfs2_direct_IO_write, if ocfs2_direct_IO_get_blocks failed, the
di_bh will be used again in unlikely branch, and this will hit a warning
"VFS: brelse: Trying to free free buffer" when jbd2 do checkpoint.
Fix this issue by setting di_bh to NULL after brelse.

Reported-by: alex chen <alex.chen@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write-fix fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write-fix
+++ a/fs/ocfs2/aops.c
@@ -692,6 +692,7 @@ static ssize_t ocfs2_direct_IO_write(str
 
 		ocfs2_inode_unlock(inode, 1);
 		brelse(di_bh);
+		di_bh = NULL;
 	}
 
 	written = __blockdev_direct_IO(WRITE, iocb, inode, inode->i_sb->s_bdev,
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch
o2dlm-fix-a-race-between-purge-and-master-query.patch
ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch

