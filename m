From: akpm@linux-foundation.org
Subject: +
 fault-inject-restore-support-for-task-independent-fault-injection.patch
 added to -mm tree
Date: Tue, 22 Aug 2017 15:16:15 -0700
Message-ID: <599cad2f.+QKlVK8YanSY68ZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdHVWQQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@wdc.com, akinobu.mita@gmail.com, axboe@kernel.dk, dvyukov@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: restore support for task-independent fault injection
has been added to the -mm tree.  Its filename is
     fault-inject-restore-support-for-task-independent-fault-injection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-restore-support-for-task-independent-fault-injection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-restore-support-for-task-independent-fault-injection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: fault-inject: restore support for task-independent fault injection

Certain faults should be injected independent of the context in which
these occur.  Commit e41d58185f14 made it impossible to inject faults
independent of their context.  Restore support for task-independent fault
injection by adding the attribute 'global'.

Fixes: e41d58185f14 ("fault-inject: support systematic fault injection")
Link: http://lkml.kernel.org/r/20170822165236.12275-2-bart.vanassche@wdc.com
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    9 +++++++--
 lib/fault-inject.c           |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/fault-inject.h~fault-inject-restore-support-for-task-independent-fault-injection include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-inject-restore-support-for-task-independent-fault-injection
+++ a/include/linux/fault-inject.h
@@ -18,6 +18,7 @@ struct fault_attr {
 	atomic_t times;
 	atomic_t space;
 	unsigned long verbose;
+	bool global;
 	bool task_filter;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
@@ -30,17 +31,21 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
-#define FAULT_ATTR_INITIALIZER {					\
+#define FAULT_ATTR_INITIALIZER(__global) {				\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
 		.require_end = ULONG_MAX,				\
+		.global = (__global),					\
 		.stacktrace_depth = 32,					\
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
 		.dname = NULL,						\
 	}
 
-#define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
+#define DECLARE_FAULT_ATTR(name)				\
+	struct fault_attr name = FAULT_ATTR_INITIALIZER(false)
+#define DECLARE_GLOBAL_FAULT_ATTR(name)				\
+	struct fault_attr name = FAULT_ATTR_INITIALIZER(true)
 int setup_fault_attr(struct fault_attr *attr, char *str);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
diff -puN lib/fault-inject.c~fault-inject-restore-support-for-task-independent-fault-injection lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-restore-support-for-task-independent-fault-injection
+++ a/lib/fault-inject.c
@@ -107,7 +107,7 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
-	if (in_task()) {
+	if (!attr->global && in_task()) {
 		unsigned int fail_nth = READ_ONCE(current->fail_nth);
 
 		if (fail_nth) {
@@ -226,6 +226,8 @@ struct dentry *fault_create_debugfs_attr
 	if (!debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
 				&attr->ratelimit_state.burst))
 		goto fail;
+	if (!debugfs_create_bool("global", mode, dir, &attr->global))
+		goto fail;
 	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
 
_

Patches currently in -mm which might be from bart.vanassche@wdc.com are

fault-inject-restore-support-for-task-independent-fault-injection.patch
block-make-i-o-timeout-failure-injection-support-again-task-independent.patch

