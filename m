From: akpm@linux-foundation.org
Subject: + sys_prctl-fix-return-of-uninitialized-value.patch added to -mm tree
Date: Wed, 21 May 2008 22:25:57 -0700
Message-ID: <200805220525.m4M5Pviv018935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657AbYEVF0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 01:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shiwh@cn.fujitsu.com, morgan@kernel.org, serue@us.ibm.com


The patch titled
     sys_prctl(): fix return of uninitialized value
has been added to the -mm tree.  Its filename is
     sys_prctl-fix-return-of-uninitialized-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_prctl(): fix return of uninitialized value
From: Shi Weihua <shiwh@cn.fujitsu.com>

If none of the switch cases match, the PR_SET_PDEATHSIG and
PR_SET_DUMPABLE cases of the switch statement will never write to local
variable `error'.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
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

sys_prctl-fix-return-of-uninitialized-value.patch

