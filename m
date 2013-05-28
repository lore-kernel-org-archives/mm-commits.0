From: akpm@linux-foundation.org
Subject: + fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch
 added to -mm tree
Date: Tue, 28 May 2013 14:11:32 -0700
Message-ID: <51a51d84.lI9Sw4dvQkE+zvzb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3E1VLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 17:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 14:11:32 -0700


The patch titled
     Subject: fs/ocfs2/dlm/dlmrecovery.c: remove duplicate declarations
has been added to the -mm tree.  Its filename is
     fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch

