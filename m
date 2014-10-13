From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:37 -0700
Message-ID: <543c1741.etr2p8mQVD8wkidz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: call dlm_lockres_put without resource spinlock
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2/dlm: call dlm_lockres_put without resource spinlock

dlm_lockres_put() should be called without &res->spinlock, otherwise a
deadlock case may happen.

spin_lock(&res->spinlock)
...
dlm_lockres_put
  ->dlm_lockres_release
    ->dlm_print_one_lock_resource
      ->spin_lock(&res->spinlock)

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1710,9 +1710,12 @@ int dlm_master_requery_handler(struct o2
 				BUG();
 			} else
 				__dlm_lockres_grab_inflight_worker(dlm, res);
-		} else /* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
+		} else {
+			/* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
 			dlm_lockres_put(res);
-		spin_unlock(&res->spinlock);
+		}
 	}
 	spin_unlock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

origin.patch

