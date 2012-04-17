From: akpm@linux-foundation.org
Subject: + ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch added to -mm tree
Date: Tue, 17 Apr 2012 15:17:51 -0700
Message-ID: <20120417221751.6E312A038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59083 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2DQWRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 18:17:54 -0400
Received: by lbol12 with SMTP id l12so138073lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 15:17:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: ipc/mqueue: switch back to using non-max values on create
has been added to the -mm tree.  Its filename is
     ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: switch back to using non-max values on create

Commit b231cca4381 ("message queues: increase range limits") changed how
we create a queue that does not include an attr struct passed to open so
that it creates the queue with whatever the maximum values are.  However,
if the admin has set the maximums to allow flexibility in creating a queue
(aka, both a large size and large queue are allowed, but combined they
create a queue too large for the RLIMIT_MSGQUEUE of the user), then
attempts to create a queue without an attr struct will fail.  Switch back
to using acceptable defaults regardless of what the maximums are.

Note: so far, we only know of a few applications that rely on this
behavior (specifically, set the maximums in /proc, then run the
application which calls mq_open() without passing in an attr struct, and
the application expects the newly created message queue to have the
maximum sizes that were set in /proc used on the mq_open() call, and all
of those applications that we know of are actually part of regression test
suites that were coded to do something like this:

for size in 4096 65536 $((1024 * 1024)) $((16 * 1024 * 1024)); do
	echo $size > /proc/sys/fs/mqueue/msgsize_max
	mq_open || echo "Error opening mq with size $size"
done

These test suites that depend on any behavior like this are broken.  The
concept that programs should rely upon the system wide maximum in order to
get their desired results instead of simply using a attr struct to specify
what they want is fundamentally unfriendly programming practice for any
multi-tasking OS.

Fixing this will break those few apps that we know of (and those app
authors recognize the brokenness of their code and the need to fix it). 
However, a future patch will allow a workaround in the form of new knobs
for the default msg queue creation parameters for any software out there
that we don't already know about that might rely on this behavior at the
moment.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 ++
 ipc/mqueue.c                  |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-switch-back-to-using-non-max-values-on-create include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-switch-back-to-using-non-max-values-on-create
+++ a/include/linux/ipc_namespace.h
@@ -95,9 +95,11 @@ extern int mq_init_ns(struct ipc_namespa
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define HARD_QUEUESMAX 1024
 #define MIN_MSGMAX     1
+#define DFLT_MSG       10U
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define MIN_MSGSIZEMAX  128
+#define DFLT_MSGSIZE    8192U
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #define HARD_MSGSIZEMAX (8192*128)
 #else
diff -puN ipc/mqueue.c~ipc-mqueue-switch-back-to-using-non-max-values-on-create ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-switch-back-to-using-non-max-values-on-create
+++ a/ipc/mqueue.c
@@ -142,8 +142,9 @@ static struct inode *mqueue_get_inode(st
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
+		info->attr.mq_msgsize =
+			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
_
Subject: Subject: ipc/mqueue: switch back to using non-max values on create

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch

