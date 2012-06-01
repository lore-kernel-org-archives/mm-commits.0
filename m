From: akpm@linux-foundation.org
Subject: [merged] mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:48 -0700
Message-ID: <20120601193448.7E4ACA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36926 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:50 -0400
Received: by eaao13 with SMTP id o13so111956eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mqueue: separate mqueue default value from maximum value
has been removed from the -mm tree.  Its filename was
     mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mqueue: separate mqueue default value from maximum value

commit b231cca438 ("message queues: increase range limits") changed mqueue
default value when attr parameter is specified NULL from hard coded value
to fs.mqueue.{msg,msgsize}_max sysctl value.

This made large side effect.  When user need to use two mqueue
applications 1) using !NULL attr parameter and it require big message size
and 2) using NULL attr parameter and only need small size message, app (1)
require to raise fs.mqueue.msgsize_max and app (2) consume large memory
size even though it doesn't need.

Doug Ledford propsed to switch back it to static hard coded value. 
However it also has a compatibility problem.  Some applications might
started depend on the default value is tunable.

The solution is to separate default value from maximum value.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt   |    7 +++++++
 include/linux/ipc_namespace.h |    2 ++
 ipc/mq_sysctl.c               |   18 ++++++++++++++++++
 ipc/mqueue.c                  |    9 ++++++---
 4 files changed, 33 insertions(+), 3 deletions(-)

diff -puN Documentation/sysctl/fs.txt~mqueue-separate-mqueue-default-value-from-maximum-value-v2 Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~mqueue-separate-mqueue-default-value-from-maximum-value-v2
+++ a/Documentation/sysctl/fs.txt
@@ -225,6 +225,13 @@ a queue must be less or equal then msg_m
 maximum  message size value (it is every  message queue's attribute set during
 its creation).
 
+/proc/sys/fs/mqueue/msg_default is  a read/write  file for setting/getting the
+default number of messages in a queue value if attr parameter of mq_open(2) is
+NULL. If it exceed msg_max, the default value is initialized msg_max.
+
+/proc/sys/fs/mqueue/msgsize_default is a read/write file for setting/getting
+the default message size value if attr parameter of mq_open(2) is NULL. If it
+exceed msgsize_max, the default value is initialized msgsize_max.
 
 4. /proc/sys/fs/epoll - Configuration options for the epoll interface
 --------------------------------------------------------
diff -puN include/linux/ipc_namespace.h~mqueue-separate-mqueue-default-value-from-maximum-value-v2 include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~mqueue-separate-mqueue-default-value-from-maximum-value-v2
+++ a/include/linux/ipc_namespace.h
@@ -62,6 +62,8 @@ struct ipc_namespace {
 	unsigned int    mq_queues_max;   /* initialized to DFLT_QUEUESMAX */
 	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
 	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
+	unsigned int    mq_msg_default;
+	unsigned int    mq_msgsize_default;
 
 	/* user_ns which owns the ipc ns */
 	struct user_namespace *user_ns;
diff -puN ipc/mq_sysctl.c~mqueue-separate-mqueue-default-value-from-maximum-value-v2 ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~mqueue-separate-mqueue-default-value-from-maximum-value-v2
+++ a/ipc/mq_sysctl.c
@@ -73,6 +73,24 @@ static ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
+	{
+		.procname	= "msg_default",
+		.data		= &init_ipc_ns.mq_msg_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_max_limit_min,
+		.extra2		= &msg_max_limit_max,
+	},
+	{
+		.procname	= "msgsize_default",
+		.data		= &init_ipc_ns.mq_msgsize_default,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_maxsize_limit_min,
+		.extra2		= &msg_maxsize_limit_max,
+	},
 	{}
 };
 
diff -puN ipc/mqueue.c~mqueue-separate-mqueue-default-value-from-maximum-value-v2 ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-separate-mqueue-default-value-from-maximum-value-v2
+++ a/ipc/mqueue.c
@@ -145,9 +145,10 @@ static struct inode *mqueue_get_inode(st
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
-		info->attr.mq_msgsize =
-			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
+					   ipc_ns->mq_msg_default);
+		info->attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
+					    ipc_ns->mq_msgsize_default);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
@@ -1261,6 +1262,8 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
 	ns->mq_msg_max       = DFLT_MSGMAX;
 	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+	ns->mq_msg_default   = DFLT_MSG;
+	ns->mq_msgsize_default  = DFLT_MSGSIZE;
 
 	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
 	if (IS_ERR(ns->mq_mnt)) {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

