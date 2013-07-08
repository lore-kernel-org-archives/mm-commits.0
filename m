From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:23:00 -0700
Message-ID: <51db1194.veRnA4vHRl9DRlbY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:00 -0700


The patch titled
     Subject: fs/ocfs2/dlm/dlmrecovery.c: remove duplicate declarations
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: fs/ocfs2/dlm/dlmrecovery.c: remove duplicate declarations

Below 3 functions have already been declared in dlmcommon.h, so we have
no need to declare them again in dlmrecovery.c.
dlm_complete_recovery_thread
dlm_launch_recovery_thread
dlm_kick_recovery_thread

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -55,9 +55,6 @@
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node);
 
 static int dlm_recovery_thread(void *data);
-void dlm_complete_recovery_thread(struct dlm_ctxt *dlm);
-int dlm_launch_recovery_thread(struct dlm_ctxt *dlm);
-void dlm_kick_recovery_thread(struct dlm_ctxt *dlm);
 static int dlm_do_recovery(struct dlm_ctxt *dlm);
 
 static int dlm_pick_recovery_master(struct dlm_ctxt *dlm);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch

