From: akpm@linux-foundation.org
Subject: + init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch added to -mm tree
Date: Wed, 07 Jul 2010 17:18:49 -0700
Message-ID: <201007080018.o680InLh002940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab0GHATC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 20:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kjwinchester@gmail.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     init/main.c: fix warning: 'calltime.tv64' may be used uninitialized
has been added to the -mm tree.  Its filename is
     init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: fix warning: 'calltime.tv64' may be used uninitialized
From: Kevin Winchester <kjwinchester@gmail.com>

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

The following warning appears:

	init/main.c: In function `do_one_initcall':
	init/main.c:730:10: warning: `calltime.tv64' may be used uninitialized in this function

This warning is actually correct, as the global initcall_debug could
arguably be changed by the initcall.

Correct this warning by extracting a new function, do_one_initcall_debug,
that performs the initcall for the debug case.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN init/main.c~init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized init/main.c
--- a/init/main.c~init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized
+++ a/init/main.c
@@ -724,27 +724,33 @@ core_param(initcall_debug, initcall_debu
 
 static char msgbuf[64];
 
-int do_one_initcall(initcall_t fn)
+static int do_one_initcall_debug(initcall_t fn)
 {
-	int count = preempt_count();
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 	int ret;
 
-	if (initcall_debug) {
-		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
-		calltime = ktime_get();
-	}
-
+	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
+	calltime = ktime_get();
 	ret = fn();
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
+	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n", fn,
+		ret, duration);
 
-	if (initcall_debug) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-		printk("initcall %pF returned %d after %lld usecs\n", fn,
-			ret, duration);
-	}
+	return ret;
+}
+
+int do_one_initcall(initcall_t fn)
+{
+	int count = preempt_count();
+	int ret;
+
+	if (initcall_debug)
+		ret = do_one_initcall_debug(fn);
+	else
+		ret = fn();
 
 	msgbuf[0] = 0;
 
_

Patches currently in -mm which might be from kjwinchester@gmail.com are

linux-next.patch
init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch
init-mainc-mark-do_one_initcall-as-__init_or_module.patch

