From: akpm@linux-foundation.org
Subject: - lockdep-debugging-give-stacktrace-for-init_error.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:56 -0700
Message-ID: <200707192003.l6JK3u6a019903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126AbXGSU2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep debugging: give stacktrace for init_error
has been removed from the -mm tree.  Its filename was
     lockdep-debugging-give-stacktrace-for-init_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep debugging: give stacktrace for init_error
From: Johannes Berg <johannes@sipsolutions.net>

When I started adding support for lockdep to 64-bit powerpc, I got a
lockdep_init_error and with this patch was able to pinpoint why and where
to put lockdep_init().  Let's support this generally for others adding
lockdep support to their architecture.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-debugging-give-stacktrace-for-init_error kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-debugging-give-stacktrace-for-init_error
+++ a/kernel/lockdep.c
@@ -375,6 +375,11 @@ unsigned int max_recursion_depth;
  * about it later on, in lockdep_info().
  */
 static int lockdep_init_error;
+static unsigned long lockdep_init_trace_data[20];
+static struct stack_trace lockdep_init_trace = {
+	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
+	.entries = lockdep_init_trace_data,
+};
 
 /*
  * Various lockdep statistics:
@@ -662,6 +667,7 @@ look_up_lock_class(struct lockdep_map *l
 	if (unlikely(!lockdep_initialized)) {
 		lockdep_init();
 		lockdep_init_error = 1;
+		save_stack_trace(&lockdep_init_trace);
 	}
 #endif
 
@@ -3040,8 +3046,11 @@ void __init lockdep_info(void)
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
 
 #ifdef CONFIG_DEBUG_LOCKDEP
-	if (lockdep_init_error)
-		printk("WARNING: lockdep init error! Arch code didnt call lockdep_init() early enough?\n");
+	if (lockdep_init_error) {
+		printk("WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?\n");
+		printk("Call stack leading to lockdep invocation was:\n");
+		print_stack_trace(&lockdep_init_trace, 0);
+	}
 #endif
 }
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
appletouch-powersaving.patch
git-net.patch
