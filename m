From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:41:41 -0700
Message-ID: <523218f5.S7xC/DTYa5WgB5VH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:41 -0700


The patch titled
     Subject: ocfs2/dlm: force clean refmap when doing local cleanup
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: force clean refmap when doing local cleanup

dlm_do_local_recovery_cleanup() should force clean refmap if the owner of
lockres is UNKNOWN.  Otherwise node may hang when umounting filesystems. 
Here's the situation:

	Node1                                    Node2
dlmlock()
  -> dlm_get_lock_resource()
send DLM_MASTER_REQUEST_MSG to
other nodes.

                                       trying to master this lockres,
                                       return MAYBE.

selected as the master of lockresA,
set mle->master to Node1,
and do assert_master,
send DLM_ASSERT_MASTER_MSG to Node2.
                                       Node 2 has interest on lockresA
                                       and return
                                       DLM_ASSERT_RESPONSE_MASTERY_REF
                                       then something happened and
                                       Node2 crashed.

Receiving DLM_ASSERT_RESPONSE_MASTERY_REF, set Node2 into refmap, and keep
sending DLM_ASSERT_MASTER_MSG to other nodes

o2hb found node2 down, calling dlm_hb_node_down() -->
dlm_do_local_recovery_cleanup() the master of lockresA is still UNKNOWN,
no need to call dlm_free_dead_locks().

Set the master of lockresA to Node1, but Node2 stills remains in refmap.

When Node1 umount, it found that the refmap of lockresA is not empty and
attempted to migrate it to Node2, But Node2 is already down, so umount
hang, trying to migrate lockresA again and again.

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2331,6 +2331,14 @@ static void dlm_do_local_recovery_cleanu
 			} else if (res->owner == dlm->node_num) {
 				dlm_free_dead_locks(dlm, res, dead_node);
 				__dlm_lockres_calc_usage(dlm, res);
+			} else if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+				if (test_bit(dead_node, res->refmap)) {
+					mlog(0, "%s:%.*s: dead node %u had a ref, but had "
+						"no locks and had not purged before dying\n",
+						dlm->name, res->lockname.len,
+						res->lockname.name, dead_node);
+					dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
+				}
 			}
 			spin_unlock(&res->spinlock);
 		}
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch

