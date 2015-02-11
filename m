From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:20:55 -0800
Message-ID: <54dbb9a7.x2WjJ7ML3banXd0+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, vicky.yangwenfang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: add missing dlm_lock_put() when recovery master down
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: add missing dlm_lock_put() when recovery master down

When the recovery master is down, the owner of $RECOVERY calls
dlm_do_local_recovery_cleanup() to prune any $RECOVERY entries for dead
nodes.  The lock is in the granted list and the refcount must be 2.  We
should put twice to remove this lock.  Otherwise, it will lead to a memory
leak.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Reported-by: yangwenfang <vicky.yangwenfang@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1070,6 +1070,9 @@ static void dlm_move_reco_locks_to_list(
 					     dead_node, dlm->name);
 					list_del_init(&lock->list);
 					dlm_lock_put(lock);
+					/* Can't schedule DLM_UNLOCK_FREE_LOCK
+					 * - do manually */
+					dlm_lock_put(lock);
 					break;
 				}
 			}
@@ -2346,6 +2349,10 @@ static void dlm_do_local_recovery_cleanu
 						     dead_node, dlm->name);
 						list_del_init(&lock->list);
 						dlm_lock_put(lock);
+						/* Can't schedule
+						 * DLM_UNLOCK_FREE_LOCK
+						 * - do manually */
+						dlm_lock_put(lock);
 						break;
 					}
 				}
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

