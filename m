From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-possible-convertion-deadlock.patch added to -mm
 tree
Date: Wed, 21 May 2014 15:25:54 -0700
Message-ID: <537d27f2.xAVqJVErKI43bNzo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaEUWZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 May 2014 18:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-dlm-fix-possible-convertion-deadlock.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 21 May 2014 15:25:54 -0700


The patch titled
     Subject: ocfs2/dlm: fix possible convert=sion deadlock
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-possible-convertion-deadlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-possible-convertion-deadlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-possible-convertion-deadlock.patch

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
Subject: ocfs2/dlm: fix possible convert=sion deadlock

We found there is a conversion deadlock when the owner of lockres happened
to crash before send DLM_PROXY_AST_MSG for a downconverting lock.  The
situation is as follows:

Node1                            Node2                  Node3
                           the owner of lockresA
lock_1 granted at EX mode
and call ocfs2_cluster_unlock
to decrease ex_holders.
                                                 converting lock_3 from
                                                 NL to EX
                           send DLM_PROXY_AST_MSG
                           to Node1, asking Node 1
                           to downconvert.
receiving DLM_PROXY_AST_MSG,
thread ocfs2dc send
DLM_CONVERT_LOCK_MSG
to Node2 to downconvert
lock_1(EX->NL).
                           lock_1 can be granted and
                           put it into pending_asts
                           list, return DLM_NORMAL.
                           then something happened
                           and Node2 crashed.
received DLM_NORMAL, waiting
for DLM_PROXY_AST_MSG.
                                               selected as the recovery
                                               master, receving migrate
                                               lock from Node1, queue
                                               lock_1 to the tail of
                                               converting list.

After dlm recovery, converting list in the master of lockresA(Node3) will
be: converting list head <-> lock_3(NL->EX) <->lock_1(EX<->NL).  Requested
mode of lock_3 is not compatible with the granted mode of lock_1, so it
can not be granted.  and lock_1 can not downconvert because covnerting
queue is strictly FIFO.  So a deadlock is created.  We think function
dlm_process_recovery_data() should queue_ast for lock_1 or alter the order
of lock_1 and lock_3, so dlm_thread can process lock_1 first.  And if
there are multiple downconverting locks, they must convert form PR to NL,
so no need to sort them.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-possible-convertion-deadlock fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-possible-convertion-deadlock
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1986,7 +1986,15 @@ skip_lvb:
 		}
 		if (!bad) {
 			dlm_lock_get(newlock);
-			list_add_tail(&newlock->list, queue);
+			if (mres->flags & DLM_MRES_RECOVERY &&
+					ml->list == DLM_CONVERTING_LIST &&
+					newlock->ml.type >
+					newlock->ml.convert_type) {
+				/* newlock is doing downconvert, add it to the
+				 * head of converting list */
+				list_add(&newlock->list, queue);
+			} else
+				list_add_tail(&newlock->list, queue);
 			mlog(0, "%s:%.*s: added lock for node %u, "
 			     "setting refmap bit\n", dlm->name,
 			     res->lockname.len, res->lockname.name, ml->node);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-fix-possible-convertion-deadlock.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

