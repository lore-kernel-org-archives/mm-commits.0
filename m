From: akpm@linux-foundation.org
Subject: + signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:20:11 -0700
Message-ID: <200910162220.n9GMKCw7032640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbZJPWUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, sukadev@us.ibm.com


The patch titled
     signals: SEND_SIG_NOINFO should be considered as SI_FROMUSER()
has been added to the -mm tree.  Its filename is
     signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch

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
Subject: signals: SEND_SIG_NOINFO should be considered as SI_FROMUSER()
From: Oleg Nesterov <oleg@redhat.com>

No changes in compiled code. The patch adds the new helper, si_fromuser()
and changes check_kill_permission() to use this helper.

The real effect of this patch is that from now we "officially" consider
SEND_SIG_NOINFO signal as "from user-space" signals. This is already true
if we look at the code which uses SEND_SIG_NOINFO, except __send_signal()
has another opinion - see the next patch.

The naming of these special SEND_SIG_XXX siginfo's is really bad
imho.  From __send_signal()'s pov they mean

	SEND_SIG_NOINFO		from user
	SEND_SIG_PRIV		from kernel
	SEND_SIG_FORCED		no info

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Reviewed-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/sched.h~signals-send_sig_noinfo-should-be-considered-as-si_fromuser include/linux/sched.h
--- a/include/linux/sched.h~signals-send_sig_noinfo-should-be-considered-as-si_fromuser
+++ a/include/linux/sched.h
@@ -2093,11 +2093,6 @@ static inline int kill_cad_pid(int sig, 
 #define SEND_SIG_PRIV	((struct siginfo *) 1)
 #define SEND_SIG_FORCED	((struct siginfo *) 2)
 
-static inline int is_si_special(const struct siginfo *info)
-{
-	return info <= SEND_SIG_FORCED;
-}
-
 /* True if we are on the alternate signal stack.  */
 
 static inline int on_sig_stack(unsigned long sp)
diff -puN kernel/signal.c~signals-send_sig_noinfo-should-be-considered-as-si_fromuser kernel/signal.c
--- a/kernel/signal.c~signals-send_sig_noinfo-should-be-considered-as-si_fromuser
+++ a/kernel/signal.c
@@ -584,6 +584,17 @@ static int rm_from_queue(unsigned long m
 	return 1;
 }
 
+static inline int is_si_special(const struct siginfo *info)
+{
+	return info <= SEND_SIG_FORCED;
+}
+
+static inline bool si_fromuser(const struct siginfo *info)
+{
+	return info == SEND_SIG_NOINFO ||
+		(!is_si_special(info) && SI_FROMUSER(info));
+}
+
 /*
  * Bad permissions for sending the signal
  * - the caller must hold at least the RCU read lock
@@ -598,7 +609,7 @@ static int check_kill_permission(int sig
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+	if (!si_fromuser(info))
 		return 0;
 
 	error = audit_signal_info(sig, t); /* Let audit system see the signal */
@@ -1156,8 +1167,7 @@ int kill_pid_info_as_uid(int sig, struct
 		goto out_unlock;
 	}
 	pcred = __task_cred(p);
-	if ((info == SEND_SIG_NOINFO ||
-	     (!is_si_special(info) && SI_FROMUSER(info))) &&
+	if (si_fromuser(info) &&
 	    euid != pcred->suid && euid != pcred->uid &&
 	    uid  != pcred->suid && uid  != pcred->uid) {
 		ret = -EPERM;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
connector-fix-regression-introduced-by-sid-connector.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
utrace-core.patch

