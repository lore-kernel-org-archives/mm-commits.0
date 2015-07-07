From: akpm@linux-foundation.org
Subject: +
 kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch added to -mm tree
Date: Tue, 07 Jul 2015 16:09:41 -0700
Message-ID: <559c5c35.8mNehr+PiFrPBQfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbbGGXJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 19:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: add up-to-date explanations on the purpose of each asynchronous level
has been added to the -mm tree.  Its filename is
     kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: add up-to-date explanations on the purpose of each asynchronous level

There seems to be quite some confusions on the comments, likely due to
changes that came after them.

Now since it's very non obvious why we have 3 levels of asynchronous code
to implement usermodehelpers, it's important to comment in detail the
reason of this layout.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff -puN kernel/kmod.c~kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels kernel/kmod.c
--- a/kernel/kmod.c~kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels
+++ a/kernel/kmod.c
@@ -269,7 +269,11 @@ out:
 	do_exit(0);
 }
 
-/* Keventd can't block, but this (a child) can. */
+/*
+ * We couldn't wait for usermodehelper completion from khelper without
+ * blocking other pending concurrent usermodehelper targets. This is why
+ * the UMH_WAIT_PROC flavour runs in its own thread.
+ */
 static int call_usermodehelper_exec_sync(void *data)
 {
 	struct subprocess_info *sub_info = data;
@@ -285,8 +289,8 @@ static int call_usermodehelper_exec_sync
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
-		 * But call_usermodehelper_exec_sync() always runs as keventd,
-		 * and put_user() to a kernel address works OK for kernel
+		 * But call_usermodehelper_exec_sync() always runs as kernel
+		 * thread and put_user() to a kernel address works OK for kernel
 		 * threads, due to their having an mm_segment_t which spans the
 		 * entire address space.
 		 *
@@ -307,7 +311,15 @@ static int call_usermodehelper_exec_sync
 	do_exit(0);
 }
 
-/* This is run by khelper thread  */
+/*
+ * This function doesn't need to be called asynchronously. But we need to create
+ * the usermodehelper kernel threads from a task that is affine to all CPUs
+ * (or nohz housekeeping ones) such that they inherit a global affinity. Khelper
+ * workqueue simply provides that.
+ * call_usermodehelper() can be called from tasks with a reduced CPU
+ * affinity (eg: per-cpu workqueues) and we don't want usermodehelper targets to
+ * contend any busy CPU.
+ */
 static void call_usermodehelper_exec_work(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
@@ -693,6 +705,18 @@ struct ctl_table usermodehelper_table[]
 
 void __init usermodehelper_init(void)
 {
+	/*
+	 * The singlethread property here stands for the need of a workqueue
+	 * with wide CPUs affinity, in order to create usermodehelper kernel
+	 * threads inheriting this attribute irrespective of
+	 * call_usermodehelper() callers. Non-singlethread workqueues are
+	 * otherwise per-cpu and wouldn't produce the desired effect.
+	 *
+	 * The ordering guarantee as a side-effect isn't necessary but shouldn't
+	 * introduce performance issue. All we do is creating two kernel threads.
+	 * This should be fast enough not to block concurrent usermodehelper
+	 * callers.
+	 */
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
 }
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch

