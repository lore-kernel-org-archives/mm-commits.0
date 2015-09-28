From: akpm@linux-foundation.org
Subject: +
 pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode.patch added
 to -mm tree
Date: Mon, 28 Sep 2015 16:00:15 -0700
Message-ID: <5609c67f.ySk6HMD7/MUT7KJm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbbI1XAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 19:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsegall@google.com, ambrose@google.com, ebiederm@xmission.com, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: fix set/getpriority and ioprio_set/get in PRIO_USER mode
has been added to the -mm tree.  Its filename is
     pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Segall <bsegall@google.com>
Subject: pidns: fix set/getpriority and ioprio_set/get in PRIO_USER mode

setpriority(PRIO_USER, 0, x) will change the priority of tasks outside of
the current pid namespace.  This is in contrast to both the other modes of
setpriority and the example of kill(-1).  Fix this.  getpriority and
ioprio have the same failure mode, fix them too.

Eric said:

: After some more thinking about it this patch sounds justifiable.
: 
: My goal with namespaces is not to build perfect isolation mechanisms
: as that can get into ill defined territory, but to build well defined
: mechanisms.  And to handle the corner cases so you can use only
: a single namespace with well defined results.
: 
: In this case you have found the two interfaces I am aware of that
: identify processes by uid instead of by pid.  Which quite frankly is
: weird.  Unfortunately the weird unexpected cases are hard to handle
: in the usual way.
: 
: I was hoping for a little more information.  Changes like this one we
: have to be careful of because someone might be depending on the current
: behavior.  I don't think they are and I do think this make sense as part
: of the pid namespace.

Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ambrose Feinstein <ambrose@google.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioprio.c |    6 ++++--
 kernel/sys.c   |    4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN block/ioprio.c~pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode block/ioprio.c
--- a/block/ioprio.c~pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode
+++ a/block/ioprio.c
@@ -123,7 +123,8 @@ SYSCALL_DEFINE3(ioprio_set, int, which,
 				break;
 
 			do_each_thread(g, p) {
-				if (!uid_eq(task_uid(p), uid))
+				if (!uid_eq(task_uid(p), uid) ||
+				    !task_pid_vnr(p))
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -220,7 +221,8 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 				break;
 
 			do_each_thread(g, p) {
-				if (!uid_eq(task_uid(p), user->uid))
+				if (!uid_eq(task_uid(p), user->uid) ||
+				    !task_pid_vnr(p))
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff -puN kernel/sys.c~pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode kernel/sys.c
--- a/kernel/sys.c~pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode
+++ a/kernel/sys.c
@@ -222,7 +222,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 				goto out_unlock;	/* No processes for this user */
 		}
 		do_each_thread(g, p) {
-			if (uid_eq(task_uid(p), uid))
+			if (uid_eq(task_uid(p), uid) && task_pid_vnr(p))
 				error = set_one_prio(p, niceval, error);
 		} while_each_thread(g, p);
 		if (!uid_eq(uid, cred->uid))
@@ -290,7 +290,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 				goto out_unlock;	/* No processes for this user */
 		}
 		do_each_thread(g, p) {
-			if (uid_eq(task_uid(p), uid)) {
+			if (uid_eq(task_uid(p), uid) && task_pid_vnr(p)) {
 				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
_

Patches currently in -mm which might be from bsegall@google.com are

pidns-fix-set-getpriority-and-ioprio_set-get-in-prio_user-mode.patch

