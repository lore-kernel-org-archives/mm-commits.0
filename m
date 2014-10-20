From: akpm@linux-foundation.org
Subject: + fault-inject-add-ratelimit-option-v2.patch added to -mm tree
Date: Mon, 20 Oct 2014 16:09:18 -0700
Message-ID: <5445961e.db6RTWt/lwQA3wVc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJTXJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 19:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: add ratelimit option
has been added to the -mm tree.  Its filename is
     fault-inject-add-ratelimit-option-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-add-ratelimit-option-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-add-ratelimit-option-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fault-inject: add ratelimit option

Current debug levels are not optimal.  Especially if one want to provoke
big numbers of faults(broken device simulator) then any verbose level will
produce giant numbers of identical logging messages.  Let's add ratelimit
parameter for that purpose.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |   17 +++++++++++------
 lib/fault-inject.c           |   21 +++++++++++++++++----
 2 files changed, 28 insertions(+), 10 deletions(-)

diff -puN include/linux/fault-inject.h~fault-inject-add-ratelimit-option-v2 include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-inject-add-ratelimit-option-v2
+++ a/include/linux/fault-inject.h
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/debugfs.h>
+#include <linux/ratelimit.h>
 #include <linux/atomic.h>
 
 /*
@@ -25,14 +26,18 @@ struct fault_attr {
 	unsigned long reject_end;
 
 	unsigned long count;
+	struct ratelimit_state ratelimit_state;
+	struct dentry *dname;
 };
 
-#define FAULT_ATTR_INITIALIZER {				\
-		.interval = 1,					\
-		.times = ATOMIC_INIT(1),			\
-		.require_end = ULONG_MAX,			\
-		.stacktrace_depth = 32,				\
-		.verbose = 2,					\
+#define FAULT_ATTR_INITIALIZER {					\
+		.interval = 1,						\
+		.times = ATOMIC_INIT(1),				\
+		.require_end = ULONG_MAX,				\
+		.stacktrace_depth = 32,					\
+		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
+		.verbose = 2,						\
+		.dname = NULL,						\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff -puN lib/fault-inject.c~fault-inject-add-ratelimit-option-v2 lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-add-ratelimit-option-v2
+++ a/lib/fault-inject.c
@@ -40,10 +40,16 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->verbose > 0)
-		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
-	if (attr->verbose > 1)
-		dump_stack();
+	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
+		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
+		       "name %pd, interval %lu, probability %lu, "
+		       "space %d, times %d\n", attr->dname,
+		       attr->probability, attr->interval,
+		       atomic_read(&attr->space),
+		       atomic_read(&attr->times));
+		if (attr->verbose > 1)
+			dump_stack();
+	}
 }
 
 #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
@@ -202,6 +208,12 @@ struct dentry *fault_create_debugfs_attr
 		goto fail;
 	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
 		goto fail;
+	if (!debugfs_create_u32("verbose_ratelimit_interval_ms", mode, dir,
+				&attr->ratelimit_state.interval))
+		goto fail;
+	if (!debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
+				&attr->ratelimit_state.burst))
+		goto fail;
 	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
 
@@ -222,6 +234,7 @@ struct dentry *fault_create_debugfs_attr
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
+	attr->dname = dget(dir);
 	return dir;
 fail:
 	debugfs_remove_recursive(dir);
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

ratelimit-add-initialization-macro.patch
fault-inject-add-ratelimit-option-v2.patch
linux-next.patch

