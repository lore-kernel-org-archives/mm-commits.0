From: akpm@linux-foundation.org
Subject: [withdrawn]
 fault-inject-restore-support-for-task-independent-fault-injection.patch
 removed from -mm tree
Date: Wed, 23 Aug 2017 14:59:02 -0700
Message-ID: <599dfaa6.EOy4zXP1wJKDLG13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdHWV7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 17:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@wdc.com, akinobu.mita@gmail.com, axboe@kernel.dk, dvyukov@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: restore support for task-independent fault injection
has been removed from the -mm tree.  Its filename was
     fault-inject-restore-support-for-task-independent-fault-injection.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: fault-inject: restore support for task-independent fault injection

Certain faults should be injected independent of the context in which
these occur.  Commit e41d58185f14 made it impossible to inject faults
independent of their context.  Restore support for task-independent fault
injection by adding the attribute 'global'.

Fixes: e41d58185f14 ("fault-inject: support systematic fault injection")
Link: http://lkml.kernel.org/r/20170822230043.9968-2-bart.vanassche@wdc.com
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |   11 +++++++++--
 lib/fault-inject.c           |    4 +++-
 2 files changed, 12 insertions(+), 3 deletions(-)

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
@@ -30,17 +31,23 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
-#define FAULT_ATTR_INITIALIZER {					\
+#define __FAULT_ATTR_INITIALIZER(__global) {				\
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
+#define FAULT_ATTR_INITIALIZER __FAULT_ATTR_INITIALIZER(false)
+
+#define DECLARE_FAULT_ATTR(name)				\
+	struct fault_attr name = __FAULT_ATTR_INITIALIZER(false)
+#define DECLARE_GLOBAL_FAULT_ATTR(name)				\
+	struct fault_attr name = __FAULT_ATTR_INITIALIZER(true)
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

block-make-i-o-timeout-failure-injection-again-task-independent.patch

