From: akpm@linux-foundation.org
Subject: + lockdep-debugging-give-stacktrace-for-init_error.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:37:48 -0700
Message-ID: <200707061737.l66HbmTj010093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761622AbXGFRjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu


The patch titled
     lockdep debugging: give stacktrace for init_error
has been added to the -mm tree.  Its filename is
     lockdep-debugging-give-stacktrace-for-init_error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -291,6 +291,11 @@ unsigned int max_recursion_depth;
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
@@ -1170,6 +1175,7 @@ look_up_lock_class(struct lockdep_map *l
 	if (unlikely(!lockdep_initialized)) {
 		lockdep_init();
 		lockdep_init_error = 1;
+		save_stack_trace(&lockdep_init_trace);
 	}
 #endif
 
@@ -2636,8 +2642,11 @@ void __init lockdep_info(void)
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

git-powerpc.patch
git-netdev-all.patch
git-net.patch
git-ocfs2.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
