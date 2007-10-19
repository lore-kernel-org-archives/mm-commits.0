From: akpm@linux-foundation.org
Subject: - pid-namespaces-introduce-struct-upid.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:28 -0700
Message-ID: <200710192251.l9JMpSow024185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966600AbXJSXGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: introduce struct upid
has been removed from the -mm tree.  Its filename was
     pid-namespaces-introduce-struct-upid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: introduce struct upid
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Since task will be visible from different pid namespaces each of them have to
be addressed by multiple pids.  struct upid is to store the information about
which id refers to which namespace.

The constuciton looks like this.  Each struct pid carried the reference
counter and the list of tasks attached to this pid.  At its end it has a
variable length array of struct upid-s.  Each struct upid has a numerical id
(pid itself), pointer to the namespace, this ID is valid in and is hashed into
a pid_hash for searching the pids.

The nr and pid_chain fields are kept in struct pid for a while to make kernel
still work (no patch initialize the upids yet), but it will be removed at the
end of this series when we switch to upids completely.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    6 ++++++
 include/linux/pid.h       |   16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/init_task.h~pid-namespaces-introduce-struct-upid include/linux/init_task.h
--- a/include/linux/init_task.h~pid-namespaces-introduce-struct-upid
+++ a/include/linux/init_task.h
@@ -103,6 +103,12 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
+	.level		= 0,						\
+	.numbers	= { {						\
+		.nr		= 0,					\
+		.ns		= &init_pid_ns,				\
+		.pid_chain	= { .next = NULL, .pprev = NULL },	\
+	}, }								\
 }
 
 #define INIT_PID_LINK(type) 					\
diff -puN include/linux/pid.h~pid-namespaces-introduce-struct-upid include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-introduce-struct-upid
+++ a/include/linux/pid.h
@@ -40,6 +40,20 @@ enum pid_type
  * processes.
  */
 
+
+/*
+ * struct upid is used to get the id of the struct pid, as it is
+ * seen in particular namespace. Later the struct pid is found with
+ * find_pid_ns() using the int nr and struct pid_namespace *ns.
+ */
+
+struct upid {
+	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	int nr;
+	struct pid_namespace *ns;
+	struct hlist_node pid_chain;
+};
+
 struct pid
 {
 	atomic_t count;
@@ -49,6 +63,8 @@ struct pid
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
+	int level;
+	struct upid numbers[1];
 };
 
 extern struct pid init_struct_pid;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch
