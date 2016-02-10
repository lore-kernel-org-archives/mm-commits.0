From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-clear-refmap-bit-of-recovery-lock-while-doing-local-recovery-cleanup.patch removed from -mm tree
Date: Wed, 10 Feb 2016 11:35:56 -0800
Message-ID: <56bb911c.2PTei04PCeaB/sOT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbcBJTf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clear refmap bit of recovery lock while doing local recovery cleanup
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-clear-refmap-bit-of-recovery-lock-while-doing-local-recovery-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: clear refmap bit of recovery lock while doing local recovery cleanup

When recovery master down, dlm_do_local_recovery_cleanup() only remove the
$RECOVERY lock owned by dead node, but do not clear the refmap bit.  Which
will make umount thread falling in dead loop migrating $RECOVERY to the
dead node.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-refmap-bit-of-recovery-lock-while-doing-local-recovery-cleanup fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-refmap-bit-of-recovery-lock-while-doing-local-recovery-cleanup
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2367,6 +2367,8 @@ static void dlm_do_local_recovery_cleanu
 						break;
 					}
 				}
+				dlm_lockres_clear_refmap_bit(dlm, res,
+						dead_node);
 				spin_unlock(&res->spinlock);
 				continue;
 			}
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-add-deref_done-message.patch
ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

