From: akpm@linux-foundation.org
Subject: [withdrawn] mle-releases-issue.patch removed from -mm tree
Date: Tue, 22 Nov 2016 16:38:39 -0800
Message-ID: <5834e50f.U71+dOTcEdG2Sflu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39862 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755847AbcKWAsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs: fix MLE release issue
has been removed from the -mm tree.  Its filename was
     mle-releases-issue.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Gechangwei <ge.changwei@h3c.com>
Subject: ocfs: fix MLE release issue

During my test on OCFS2 suffering a storage failure, a crash issue was
found.  Below was the call trace when crashed.

In the call trace, we can see a MLE's reference count is going to be
negative, which aroused a BUG_ON()

[143355.593258] Call Trace:
[143355.593268]  [<ffffffffc0328447>] dlm_put_mle_inuse+0x47/0x70 [ocfs2_dlm]
[143355.593276]  [<ffffffffc032bee5>] dlm_get_lock_resource+0xac5/0x10d0 [ocfs2_dlm]
[143355.593286]  [<ffffffff81724a7a>] ? ip_queue_xmit+0x14a/0x3d0
[143355.593292]  [<ffffffff811e50b4>] ? kmem_cache_alloc+0x1e4/0x220
[143355.593300]  [<ffffffffc03215cc>] ? dlm_wait_for_recovery+0x6c/0x190 [ocfs2_dlm]
[143355.593311]  [<ffffffffc0335c4d>] dlmlock+0x62d/0x16e0 [ocfs2_dlm]
[143355.593316]  [<ffffffff816cfbab>] ? __alloc_skb+0x9b/0x2b0
[143355.593323]  [<ffffffffc01f6000>] ? 0xffffffffc01f6000

I think I probably have found the root cause of this issue. Please

**Node 1**                                          **Node 2**
                                                                Storage failure
                                                        An assert master message is sent to Node 1
Treat Node2 as down
Assert master handler
Decrease MLE reference count
Clean blocked MLE
Decrease MLE reference count

In the above scenario, both dlm_assert_master_handler and
dlm_clean_block_mle will decease MLE reference count, thus, in the
following get_resouce procedure, the reference count is going to be
negative.

[akpm@linux-foundation.org: cleanups]
Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373220C9A5B@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: gechangwei <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~mle-releases-issue fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~mle-releases-issue
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1935,7 +1935,7 @@ ok:
 
 		spin_lock(&mle->spinlock);
 		if (mle->type == DLM_MLE_BLOCK || mle->type == DLM_MLE_MIGRATION)
-			extra_ref = 1;
+			extra_ref = test_bit(assert->node_idx, mle->maybe_map);
 		else {
 			/* MASTER mle: if any bits set in the response map
 			 * then the calling node needs to re-assert to clear
@@ -3338,12 +3338,17 @@ static void dlm_clean_block_mle(struct d
 		mlog(0, "mle found, but dead node %u would not have been "
 		     "master\n", dead_node);
 		spin_unlock(&mle->spinlock);
+	} else if (mle->master != O2NM_MAX_NODES) {
+		mlog(ML_NOTICE, "mle found, master assert received, master has "
+			"already set to %d.\n ", mle->master);
+		spin_unlock(&mle->spinlock);
 	} else {
 		/* Must drop the refcount by one since the assert_master will
 		 * never arrive. This may result in the mle being unlinked and
 		 * freed, but there may still be a process waiting in the
 		 * dlmlock path which is fine. */
 		mlog(0, "node %u was expected master\n", dead_node);
+		clear_bit(bit, mle->maybe_map);
 		atomic_set(&mle->woken, 1);
 		spin_unlock(&mle->spinlock);
 		wake_up(&mle->wq);
_

Patches currently in -mm which might be from ge.changwei@h3c.com are


