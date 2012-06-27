From: akpm@linux-foundation.org
Subject: + prctl-remove-redunant-assignment-of-error-to-zero.patch added to -mm tree
Date: Tue, 26 Jun 2012 17:04:31 -0700
Message-ID: <20120627000432.502D8A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62747 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2F0AEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 20:04:42 -0400
Received: by yenl3 with SMTP id l3so55085yen.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 17:04:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasikanth.v19@gmail.com, gorcunov@openvz.org, keescook@chromium.org, serge@hallyn.com


The patch titled
     Subject: prctl: remove redunant assignment of "error" to zero
has been added to the -mm tree.  Its filename is
     prctl-remove-redunant-assignment-of-error-to-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasikantha babu <sasikanth.v19@gmail.com>
Subject: prctl: remove redunant assignment of "error" to zero

Just setting the "error" to error number is enough on failure and It
doesn't require to set "error" variable to zero in each switch case, since
it was already initialized with zero.  And also removed return 0 in switch
case with break statement

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN kernel/sys.c~prctl-remove-redunant-assignment-of-error-to-zero kernel/sys.c
--- a/kernel/sys.c~prctl-remove-redunant-assignment-of-error-to-zero
+++ a/kernel/sys.c
@@ -2015,7 +2015,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				break;
 			}
 			me->pdeath_signal = arg2;
-			error = 0;
 			break;
 		case PR_GET_PDEATHSIG:
 			error = put_user(me->pdeath_signal, (int __user *)arg2);
@@ -2029,7 +2028,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				break;
 			}
 			set_dumpable(me->mm, arg2);
-			error = 0;
 			break;
 
 		case PR_SET_UNALIGN:
@@ -2056,10 +2054,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_SET_TIMING:
 			if (arg2 != PR_TIMING_STATISTICAL)
 				error = -EINVAL;
-			else
-				error = 0;
 			break;
-
 		case PR_SET_NAME:
 			comm[sizeof(me->comm)-1] = 0;
 			if (strncpy_from_user(comm, (char __user *)arg2,
@@ -2067,20 +2062,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				return -EFAULT;
 			set_task_comm(me, comm);
 			proc_comm_connector(me);
-			return 0;
+			break;
 		case PR_GET_NAME:
 			get_task_comm(comm, me);
 			if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
 				return -EFAULT;
-			return 0;
+			break;
 		case PR_GET_ENDIAN:
 			error = GET_ENDIAN(me, arg2);
 			break;
 		case PR_SET_ENDIAN:
 			error = SET_ENDIAN(me, arg2);
 			break;
-
 		case PR_GET_SECCOMP:
 			error = prctl_get_seccomp();
 			break;
@@ -2108,7 +2102,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 					current->default_timer_slack_ns;
 			else
 				current->timer_slack_ns = arg2;
-			error = 0;
 			break;
 		case PR_MCE_KILL:
 			if (arg4 | arg5)
@@ -2134,7 +2127,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			default:
 				return -EINVAL;
 			}
-			error = 0;
 			break;
 		case PR_MCE_KILL_GET:
 			if (arg2 | arg3 | arg4 | arg5)
@@ -2153,7 +2145,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			break;
 		case PR_SET_CHILD_SUBREAPER:
 			me->signal->is_child_subreaper = !!arg2;
-			error = 0;
 			break;
 		case PR_GET_CHILD_SUBREAPER:
 			error = put_user(me->signal->is_child_subreaper,
_
Subject: Subject: prctl: remove redunant assignment of "error" to zero

Patches currently in -mm which might be from sasikanth.v19@gmail.com are

prctl-remove-redunant-assignment-of-error-to-zero.patch

