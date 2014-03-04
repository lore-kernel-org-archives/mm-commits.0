From: akpm@linux-foundation.org
Subject: +
 ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch added to -mm tree
Date: Tue, 04 Mar 2014 12:31:08 -0800
Message-ID: <5316380c.Wno+pDsq9P3TGJhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaCDUbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:31:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: + ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch added to -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,xuejiufei@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:31:08 -0800


The patch titled
     Subject: ocfs2: do not return DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,loop during umount
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: do not return DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,loop during umount

The following case may lead to endless loop during umount.

node A         node B               node C       node D
umount volume,
migrate lockres1
to B
                                                 want to lock lockres1,
                                                 send
                                                 MASTER_REQUEST_MSG
                                                 to C
                                    init block mle
               send
               MIGRATE_REQUEST_MSG
               to C
                                    find a block
                                    mle, and then
                                    return
                                    DLM_MIGRATE_RESPONSE_MASTERY_REF
                                    to B
               set C in refmap
                                    umount successfully
               try to umount, endless
               loop occurs when migrate
               lockres1 since C is in
               refmap

So we can fix this endless loop case by only returning
DLM_MIGRATE_RESPONSE_MASTERY_REF if it has a mastery mle when receiving
MIGRATE_REQUEST_MSG.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Xue jiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3084,11 +3084,15 @@ static int dlm_add_migration_mle(struct
 			/* remove it so that only one mle will be found */
 			__dlm_unlink_mle(dlm, tmp);
 			__dlm_mle_detach_hb_events(dlm, tmp);
-			ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
-			mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
-			    "telling master to get ref for cleared out mle "
-			    "during migration\n", dlm->name, namelen, name,
-			    master, new_master);
+                       if (tmp->type == DLM_MLE_MASTER) {
+                               ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
+                               mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
+                                               "telling master to get ref "
+                                               "for cleared out mle during "
+                                               "migration\n", dlm->name,
+                                               namelen, name, master,
+                                               new_master);
+                       }
 		}
 		spin_unlock(&tmp->spinlock);
 	}
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

