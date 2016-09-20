From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock.patch added
 to -mm tree
Date: Tue, 20 Sep 2016 14:48:09 -0700
Message-ID: <57e1ae99.qYayIxIjxRLVJkk/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51367 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753319AbcITVsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 17:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlock on mmapped page in ocfs2_write_begin_nolock()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2: fix deadlock on mmapped page in ocfs2_write_begin_nolock()

The testcase "mmaptruncate" of ocfs2-test deadlocks occasionally.

In this testcase, we create a 2*CLUSTER_SIZE file and mmap() on it; there
are 2 process repeatedly performing the following operations respectively:
one is doing memset(mmaped_addr + 2*CLUSTER_SIZE - 1, 'a', 1), while the
another is playing ftruncate(fd, 2*CLUSTER_SIZE) and then ftruncate(fd,
CLUSTER_SIZE) again and again.

This is the backtrace when the deadlock happens:
[<ffffffff817054f0>] __wait_on_bit_lock+0x50/0xa0
[<ffffffff81199bd7>] __lock_page+0xb7/0xc0
[<ffffffff810c4de0>] ? autoremove_wake_function+0x40/0x40
[<ffffffffa0440f4f>] ocfs2_write_begin_nolock+0x163f/0x1790 [ocfs2]
[<ffffffffa0462a50>] ? ocfs2_allocate_extend_trans+0x180/0x180 [ocfs2]
[<ffffffffa0467b47>] ocfs2_page_mkwrite+0x1c7/0x2a0 [ocfs2]
[<ffffffff811cf286>] do_page_mkwrite+0x66/0xc0
[<ffffffff811d3635>] handle_mm_fault+0x685/0x1350
[<ffffffff81039dc0>] ? __fpu__restore_sig+0x70/0x530
[<ffffffff810694c8>] __do_page_fault+0x1d8/0x4d0
[<ffffffff81069827>] trace_do_page_fault+0x37/0xf0
[<ffffffff81061e69>] do_async_page_fault+0x19/0x70
[<ffffffff8170ac98>] async_page_fault+0x28/0x30

In ocfs2_write_begin_nolock(), we first grab the pages and then allocate
disk space for this write; ocfs2_try_to_free_truncate_log() will be called
if -ENOSPC is returned; if we're lucky to get enough clusters, which is
usually the case, we start over again.  But in ocfs2_free_write_ctxt() the
target page isn't unlocked, so we will deadlock when trying to grab the
target page again.

Also, -ENOMEM might be returned in ocfs2_grab_pages_for_write().  Another
deadlock will happen in __do_page_mkwrite() if ocfs2_page_mkwrite()
returns non-VM_FAULT_LOCKED, and along with a locked target page.

These two errors fail on the same path, so fix them by unlocking the
target page manually before ocfs2_free_write_ctxt().

Jan Kara helps me clear out the JBD2 part, and suggest the hint for root cause.

Changes since v1:
1. Also put ENOMEM error case into consideration.

Link: http://lkml.kernel.org/r/1474173902-32075-1-git-send-email-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Reviewed-by: He Gang <ghe@suse.com>
Acked-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock
+++ a/fs/ocfs2/aops.c
@@ -1842,6 +1842,16 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 
 out:
+	/*
+	 * The mmapped page won't be unlocked in ocfs2_free_write_ctxt(),
+	 * even in case of error here like ENOSPC and ENOMEM. So, we need
+	 * to unlock the target page manually to prevent deadlocks when
+	 * retrying again on ENOSPC, or when returning non-VM_FAULT_LOCKED
+	 * to VM code.
+	 */
+	if (wc->w_target_locked)
+		unlock_page(mmap_page);
+
 	ocfs2_free_write_ctxt(inode, wc);
 
 	if (data_ac) {
_

Patches currently in -mm which might be from zren@suse.com are

ocfs2-fix-deadlock-on-mmapped-page-in-ocfs2_write_begin_nolock.patch

