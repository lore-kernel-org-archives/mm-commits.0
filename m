From: akpm@linux-foundation.org
Subject: - pid-implement-ns_of_pid.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:25 -0800
Message-ID: <200901082250.n08MoPWA029624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760435AbZAHWwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, Nadia.Derbey@bull.net, bastian@waldi.eu.org, oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger


The patch titled
     pid: implement ns_of_pid
has been removed from the -mm tree.  Its filename was
     pid-implement-ns_of_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: implement ns_of_pid
From: Eric W. Biederman <ebiederm@xmission.com>

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
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN include/linux/pid.h~pid-implement-ns_of_pid include/linux/pid.h
--- a/include/linux/pid.h~pid-implement-ns_of_pid
+++ a/include/linux/pid.h
@@ -123,6 +123,24 @@ extern struct pid *alloc_pid(struct pid_
 extern void free_pid(struct pid *pid);
 
 /*
+ * ns_of_pid() returns the pid namespace in which the specified pid was
+ * allocated.
+ *
+ * NOTE:
+ * 	ns_of_pid() is expected to be called for a process (task) that has
+ * 	an attached 'struct pid' (see attach_pid(), detach_pid()) i.e @pid
+ * 	is expected to be non-NULL. If @pid is NULL, caller should handle
+ * 	the resulting NULL pid-ns.
+ */
+static inline struct pid_namespace *ns_of_pid(struct pid *pid)
+{
+	struct pid_namespace *ns = NULL;
+	if (pid)
+		ns = pid->numbers[pid->level].ns;
+	return ns;
+}
+
+/*
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch

