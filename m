From: akpm@linux-foundation.org
Subject: + ocfs2-fix-race-between-dio-and-recover-orphan.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 15:39:51 -0700
Message-ID: <559ef837.A2asiaDGX5tQr1Yz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbGIWjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix race between dio and recover orphan
has been added to the -mm tree.  Its filename is
     ocfs2-fix-race-between-dio-and-recover-orphan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-race-between-dio-and-recover-orphan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-race-between-dio-and-recover-orphan.patch

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
Subject: ocfs2: fix race between dio and recover orphan

During direct io the inode will be added to orphan first and then deleted
from orphan.  There is a race window that the orphan entry will be deleted
twice and thus trigger the BUG when validating OCFS2_DIO_ORPHANED_FL in
ocfs2_del_inode_from_orphan.

ocfs2_direct_IO_write
    ...
    ocfs2_add_inode_to_orphan
    >>>>>>>> race window, another node may rm the file and then down,
             this node take care of orphan recovery and clear flag
             OCFS2_DIO_ORPHANED_FL
    ocfs2_del_inode_from_orphan

Take inode mutex lock to fix this race case.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/journal.c~ocfs2-fix-race-between-dio-and-recover-orphan fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-race-between-dio-and-recover-orphan
+++ a/fs/ocfs2/journal.c
@@ -2170,6 +2170,7 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;
 
+		mutex_lock(&inode->i_mutex);
 		ret = ocfs2_rw_lock(inode, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2214,6 +2215,7 @@ unlock_inode:
 unlock_rw:
 		ocfs2_rw_unlock(inode, 1);
 next:
+		mutex_unlock(&inode->i_mutex);
 		iput(inode);
 		brelse(di_bh);
 		di_bh = NULL;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

