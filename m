From: akpm@linux-foundation.org
Subject: - capabilities-implement-per-process-securebits-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:56:14 -0700
Message-ID: <200804280656.m3S6uEPZ012829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765394AbYD1G5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, jirislaby@gmail.com, morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     capabilities: use cap_task_prctl when !CONFIG_SECURITY
has been removed from the -mm tree.  Its filename was
     capabilities-implement-per-process-securebits-fix.patch

This patch was dropped because it was folded into capabilities-implement-per-process-securebits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: use cap_task_prctl when !CONFIG_SECURITY
From: Serge E. Hallyn <serue@us.ibm.com>

capabilities-implement-per-process-securebits.patch introduced
cap_task_prctl() and moved the handling of capability-related prctl into it. 
So when !CONFIG_SECURITY, the default security_task_prctl() needs to call
cap_task_prctl() the way other default hooks call capability helpers when they
exist.

This fixes a slew of userspace breakages when CONFIG_SECURITY=n.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/security.h~capabilities-implement-per-process-securebits-fix include/linux/security.h
--- a/include/linux/security.h~capabilities-implement-per-process-securebits-fix
+++ a/include/linux/security.h
@@ -2275,7 +2275,7 @@ static inline int security_task_prctl (i
 				       unsigned long arg4,
 				       unsigned long arg5, long *rc_p)
 {
-	return 0;
+	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
 }
 
 static inline void security_task_reparent_to_init (struct task_struct *p)
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
capabilities-implement-per-process-securebits.patch
capabilities-implement-per-process-securebits-fix.patch
root_plug-use-cap_task_prctl.patch
smack-use-cap_task_prctl.patch

