From: akpm@linux-foundation.org
Subject: - sys_prctl-fix-return-of-uninitialized-value.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:11 -0700
Message-ID: <200805270728.m4R7SBhi014898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474AbYE0Hg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shiwh@cn.fujitsu.com, morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sys_prctl(): fix return of uninitialized value
has been removed from the -mm tree.  Its filename was
     sys_prctl-fix-return-of-uninitialized-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_prctl(): fix return of uninitialized value
From: Shi Weihua <shiwh@cn.fujitsu.com>

If none of the switch cases match, the PR_SET_PDEATHSIG and
PR_SET_DUMPABLE cases of the switch statement will never write to local
variable `error'.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
Cc: Andrew G. Morgan <morgan@kernel.org>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value kernel/sys.c
--- a/kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value
+++ a/kernel/sys.c
@@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
-	long uninitialized_var(error);
+	long error = 0;
 
 	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
 		return error;
@@ -1701,9 +1701,7 @@ asmlinkage long sys_prctl(int option, un
 			error = PR_TIMING_STATISTICAL;
 			break;
 		case PR_SET_TIMING:
-			if (arg2 == PR_TIMING_STATISTICAL)
-				error = 0;
-			else
+			if (arg2 != PR_TIMING_STATISTICAL)
 				error = -EINVAL;
 			break;
 
_

Patches currently in -mm which might be from shiwh@cn.fujitsu.com are


