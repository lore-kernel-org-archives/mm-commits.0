From: akpm@linux-foundation.org
Subject: + bsdacct-use-del_timer_sync-in-acct_exit_ns.patch added to -mm tree
Date: Wed, 31 Mar 2010 12:57:30 -0700
Message-ID: <201003311957.o2VJvUa8005088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0CaT6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 15:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgusev@openvz.org, xemul@openvz.org


The patch titled
     bsdacct: use del_timer_sync() in acct_exit_ns()
has been added to the -mm tree.  Its filename is
     bsdacct-use-del_timer_sync-in-acct_exit_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

bsdacct-use-del_timer_sync-in-acct_exit_ns.patch

