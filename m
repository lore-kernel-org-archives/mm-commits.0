From: akpm@linux-foundation.org
Subject: + pid-implement-ns_of_pid.patch added to -mm tree
Date: Mon, 15 Dec 2008 21:33:13 -0800
Message-ID: <200812160533.mBG5XDMk020604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbYLPFeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 00:34:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, Nadia.Derbey@bull.net, bastian@waldi.eu.org, ebiederm@xmission.com, oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     pid: implement ns_of_pid
has been added to the -mm tree.  Its filename is
     pid-implement-ns_of_pid.patch

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
Subject: pid: implement ns_of_pid
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

A current problem with the pid namespace is that it is easy to do pid
related work after exit_task_namespaces which drops the nsproxy pointer.

However if we are doing pid namespace related work we are always operating
on some struct pid which retains the pid_namespace pointer of the pid
namespace it was allocated in.

So provide ns_of_pid which allows us to find the pid namespace a pid was
allocated in.

Using this we have the needed infrastructure to do pid namespace related
work at anytime we have a struct pid, removing the chance of accidentally
having a NULL pointer dereference when accessing current->nsproxy.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/pid.h~pid-implement-ns_of_pid include/linux/pid.h
--- a/include/linux/pid.h~pid-implement-ns_of_pid
+++ a/include/linux/pid.h
@@ -122,6 +122,17 @@ int next_pidmap(struct pid_namespace *pi
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
 
+/* ns_of_pid returns the pid namespace in which the specified
+ * pid was allocated.
+ */
+static inline struct pid_namespace *ns_of_pid(struct pid *pid)
+{
+	struct pid_namespace *ns = NULL;
+	if (pid)
+		ns = pid->numbers[pid->level].ns;
+	return ns;
+}
+
 /*
  * the helpers to get the pid's id seen from different namespaces
  *
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

linux-next.patch
pid-implement-ns_of_pid.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

