From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch added to -mm tree
Date: Mon, 05 Jan 2015 16:33:32 -0800
Message-ID: <54ab2d5c.C7JemIoSwS8mj2O/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbbAFAdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 19:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, vicky.yangwenfang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: add missing dlm_lock_put() when recovery master down
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-dlm-add-missing-dlm_lock_put-when-recovery-master-down.patch
ocfs2-fix-the-wrong-directory-passed-to-ocfs2_lookup_ino_from_name-when-link-file.patch

