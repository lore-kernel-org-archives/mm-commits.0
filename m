From: akpm@linux-foundation.org
Subject: [patch 13/13] kmod: throttle kmod thread limit
Date: Fri, 14 Jul 2017 14:50:11 -0700
Message-ID: <59693c93.yu6mtXa2iDZjv7s9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdGNVuM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, gregkh@linuxfoundation.org, jeyu@redhat.com, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: throttle kmod thread limit

If we reach the limit of modprobe_limit threads running the next
request_module() call will fail.  The original reason for adding a kill
was to do away with possible issues with in old circumstances which would
create a recursive series of request_module() calls.

We can do better than just be super aggressive and reject calls once we've
reached the limit by simply making pending callers wait until the
threshold has been reduced, and then throttling them in, one by one.

This throttling enables requests over the kmod concurrent limit to be
processed once a pending request completes.  Only the first item queued up
to wait is woken up.  The assumption here is once a task is woken it will
have no other option to also kick the queue to check if there are more
pending tasks -- regardless of whether or not it was successful.

By throttling and processing only max kmod concurrent tasks we ensure we
avoid unexpected fatal request_module() calls, and we keep memory
consumption on module loading to a minimum.

With x86_64 qemu, with 4 cores, 4 GiB of RAM it takes the following run
time to run both tests:

time ./kmod.sh -t 0008
real    0m16.366s
user    0m0.883s
sys     0m8.916s

time ./kmod.sh -t 0009
real    0m50.803s
user    0m0.791s
sys     0m9.852s

Link: http://lkml.kernel.org/r/20170628223155.26472-4-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c                        |   16 +++++++---------
 tools/testing/selftests/kmod/kmod.sh |   24 ++----------------------
 2 files changed, 9 insertions(+), 31 deletions(-)

diff -puN kernel/kmod.c~kmod-throttle-kmod-thread-limit kernel/kmod.c
--- a/kernel/kmod.c~kmod-throttle-kmod-thread-limit
+++ a/kernel/kmod.c
@@ -68,6 +68,7 @@ static DECLARE_RWSEM(umhelper_sem);
  */
 #define MAX_KMOD_CONCURRENT 50
 static atomic_t kmod_concurrent_max = ATOMIC_INIT(MAX_KMOD_CONCURRENT);
+static DECLARE_WAIT_QUEUE_HEAD(kmod_wq);
 
 /*
 	modprobe_path is set via /proc/sys.
@@ -140,7 +141,6 @@ int __request_module(bool wait, const ch
 	va_list args;
 	char module_name[MODULE_NAME_LEN];
 	int ret;
-	static int kmod_loop_msg;
 
 	/*
 	 * We don't allow synchronous module loading from async.  Module
@@ -164,14 +164,11 @@ int __request_module(bool wait, const ch
 		return ret;
 
 	if (atomic_dec_if_positive(&kmod_concurrent_max) < 0) {
-		/* We may be blaming an innocent here, but unlikely */
-		if (kmod_loop_msg < 5) {
-			printk(KERN_ERR
-			       "request_module: runaway loop modprobe %s\n",
-			       module_name);
-			kmod_loop_msg++;
-		}
-		return -ENOMEM;
+		pr_warn_ratelimited("request_module: kmod_concurrent_max (%u) close to 0 (max_modprobes: %u), for module %s, throttling...",
+				    atomic_read(&kmod_concurrent_max),
+				    MAX_KMOD_CONCURRENT, module_name);
+		wait_event_interruptible(kmod_wq,
+					 atomic_dec_if_positive(&kmod_concurrent_max) >= 0);
 	}
 
 	trace_module_request(module_name, wait, _RET_IP_);
@@ -179,6 +176,7 @@ int __request_module(bool wait, const ch
 	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 
 	atomic_inc(&kmod_concurrent_max);
+	wake_up(&kmod_wq);
 
 	return ret;
 }
diff -puN tools/testing/selftests/kmod/kmod.sh~kmod-throttle-kmod-thread-limit tools/testing/selftests/kmod/kmod.sh
--- a/tools/testing/selftests/kmod/kmod.sh~kmod-throttle-kmod-thread-limit
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -59,28 +59,8 @@ ALL_TESTS="$ALL_TESTS 0004:1:1"
 ALL_TESTS="$ALL_TESTS 0005:10:1"
 ALL_TESTS="$ALL_TESTS 0006:10:1"
 ALL_TESTS="$ALL_TESTS 0007:5:1"
-
-# Disabled tests:
-#
-# 0008 x 150 -  multithreaded - push kmod_concurrent over max_modprobes for request_module()"
-# Current best-effort failure interpretation:
-# Enough module requests get loaded in place fast enough to reach over the
-# max_modprobes limit and trigger a failure -- before we're even able to
-# start processing pending requests.
-ALL_TESTS="$ALL_TESTS 0008:150:0"
