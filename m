From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-cleanup-definition-names-and-locations.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:34 -0700
Message-ID: <20120601193434.C093EA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53839 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932804Ab2FATeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:36 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so139280lag.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: cleanup definition names and locations
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-cleanup-definition-names-and-locations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: cleanup definition names and locations

Since commit b231cca4381 ("message queues: increase range limits") on Oct
18, 2008, calls to mq_open() that did not pass in an attribute struct and
expected to get default values for the size of the queue and the max
message size now get the system wide maximums instead of hardwired
defaults like they used to get.

This was uncovered when one of the earlier patches in this patch set
increased the default system wide maximums at the same time it increased
the hard ceiling on the system wide maximums (a customer specifically
needed the hard ceiling brought back up, the new ceiling that commit
b231cca4381 introduced was too low for their production systems).  By
increasing the default maximums and not realising they were tied to any
attempt to create a message queue without an attribute struct, I had
inadvertently made it such that all message queue creation attempts
without an attribute struct were failing because the new default maximums
would create a queue that exceeded the default rlimit for message queue
bytes.

As a result, the system wide defaults were brought back down to their
previous levels, and the system wide ceilings on the maximums were raised
to meet the customer's needs.  However, the fact that the no attribute
struct behavior of mq_open() could be broken by changing the system wide
maximums for message queues was seen as fundamentally broken itself.  So
we hardwired the no attribute case back like it used to be.  But, then we
realized that on the very off chance that some piece of software in the
wild depended on that behavior, we could work around that issue by adding
two new knobs to /proc that allowed setting the defaults for message
queues created without an attr struct separately from the system wide
maximums.

What is not an option IMO is to leave the current behavior in place.  No
piece of software should ever rely on setting the system wide maximums in
order to get a desired message queue.  Such a reliance would be so
fundamentally multitasking OS unfriendly as to not really be tolerable. 
Fortunately, we don't know of any software in the wild that uses this
except for a regression test program that caught the issue in the first
place.  If there is though, we have made accommodations with the two new
/proc knobs (and that's all the accommodations such fundamentally broken
software can be allowed)..



This patch:

The various defines for minimums and maximums of the sysctl controllable
mqueue values are scattered amongst different files and named
inconsistently.  Move them all into ipc_namespace.h and make them have
consistent names.  Additionally, make the number of queues per namespace
also have a minimum and maximum and use the same sysctl function as the
other two settable variables.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    5 +++++
 ipc/mq_sysctl.c               |   31 ++++++++-----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-cleanup-definition-names-and-locations include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-cleanup-definition-names-and-locations
+++ a/include/linux/ipc_namespace.h
@@ -91,10 +91,15 @@ static inline void shm_destroy_orphaned(
 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
 /* default values */
+#define MIN_QUEUESMAX  1
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
+#define HARD_QUEUESMAX 1024
+#define MIN_MSGMAX     1
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
+#define MIN_MSGSIZEMAX  128
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
+#define HARD_MSGSIZEMAX (8192*128)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff -puN ipc/mq_sysctl.c~ipc-mqueue-cleanup-definition-names-and-locations ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~ipc-mqueue-cleanup-definition-names-and-locations
+++ a/ipc/mq_sysctl.c
@@ -13,15 +13,6 @@
 #include <linux/ipc_namespace.h>
 #include <linux/sysctl.h>
 
-/*
- * Define the ranges various user-specified maximum values can
- * be set to.
- */
-#define MIN_MSGMAX	1		/* min value for msg_max */
-#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
-#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
-#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
-
 #ifdef CONFIG_PROC_SYSCTL
 static void *get_mq(ctl_table *table)
 {
@@ -31,16 +22,6 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec(ctl_table *table, int write,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table mq_table;
-	memcpy(&mq_table, table, sizeof(mq_table));
-	mq_table.data = get_mq(table);
-
-	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
-}
-
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -52,15 +33,17 @@ static int proc_mq_dointvec_minmax(ctl_t
 					lenp, ppos);
 }
 #else
-#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
+static int msg_queues_limit_min = MIN_QUEUESMAX;
+static int msg_queues_limit_max = HARD_QUEUESMAX;
+
 static int msg_max_limit_min = MIN_MSGMAX;
-static int msg_max_limit_max = MAX_MSGMAX;
+static int msg_max_limit_max = HARD_MSGMAX;
 
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
-static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
+static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
 static ctl_table mq_sysctls[] = {
 	{
@@ -68,7 +51,9 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_queues_limit_min,
+		.extra2		= &msg_queues_limit_max,
 	},
 	{
 		.procname	= "msg_max",
_

Patches currently in -mm which might be from dledford@redhat.com are

origin.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch

