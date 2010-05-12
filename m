From: akpm@linux-foundation.org
Subject: [merged] bsdacct-use-del_timer_sync-in-acct_exit_ns.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:34 -0400
Message-ID: <201005121800.o4CI02El011555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab0ELSAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgusev@openvz.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     bsdacct: use del_timer_sync() in acct_exit_ns()
has been removed from the -mm tree.  Its filename was
     bsdacct-use-del_timer_sync-in-acct_exit_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: use del_timer_sync() in acct_exit_ns()
From: Vitaliy Gusev <vgusev@openvz.org>

acct_exit_ns --> acct_file_reopen deletes timer without check timer
execution on other CPUs.  So acct_timeout() can change an unmapped memory.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/acct.c~bsdacct-use-del_timer_sync-in-acct_exit_ns kernel/acct.c
--- a/kernel/acct.c~bsdacct-use-del_timer_sync-in-acct_exit_ns
+++ a/kernel/acct.c
@@ -353,17 +353,18 @@ restart:
 
 void acct_exit_ns(struct pid_namespace *ns)
 {
-	struct bsd_acct_struct *acct;
+	struct bsd_acct_struct *acct = ns->bacct;
 
-	spin_lock(&acct_lock);
-	acct = ns->bacct;
-	if (acct != NULL) {
-		if (acct->file != NULL)
-			acct_file_reopen(acct, NULL, NULL);
+	if (acct == NULL)
+		return;
 
-		kfree(acct);
-	}
+	del_timer_sync(&acct->timer);
+	spin_lock(&acct_lock);
+	if (acct->file != NULL)
+		acct_file_reopen(acct, NULL, NULL);
 	spin_unlock(&acct_lock);
+
+	kfree(acct);
 }
 
 /*
_

Patches currently in -mm which might be from vgusev@openvz.org are

origin.patch

