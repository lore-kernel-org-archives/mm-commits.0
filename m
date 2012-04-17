From: akpm@linux-foundation.org
Subject: + mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch added to -mm tree
Date: Tue, 17 Apr 2012 15:18:05 -0700
Message-ID: <20120417221806.0F28FA038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53082 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab2DQWSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2012 18:18:07 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so323968laa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 15:18:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: mqueue: separate mqueue default value from maximum value
has been added to the -mm tree.  Its filename is
     mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Serge E. Hallyn <serue@us.ibm.com>
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
@@ -267,6 +267,13 @@ a queue must be less or equal then msg_m
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
@@ -142,9 +142,10 @@ static struct inode *mqueue_get_inode(st
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
@@ -1254,6 +1255,8 @@ int mq_init_ns(struct ipc_namespace *ns)
 	ns->mq_queues_max    = DFLT_QUEUESMAX;
 	ns->mq_msg_max       = DFLT_MSGMAX;
 	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
+	ns->mq_msg_default   = DFLT_MSG;
+	ns->mq_msgsize_default  = DFLT_MSGSIZE;
 
 	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
 	if (IS_ERR(ns->mq_mnt)) {
_
Subject: Subject: mqueue: separate mqueue default value from maximum value

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

