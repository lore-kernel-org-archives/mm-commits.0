From: akpm@osdl.org
Subject: - let-warn_on-output-the-condition.patch removed from -mm tree
Date: Mon, 18 Dec 2006 16:36:18 -0800
Message-ID: <200612190036.kBJ0aJDg018002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbWLSAgY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:36:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     let WARN_ON() output the condition
has been removed from the -mm tree.  Its filename was
     let-warn_on-output-the-condition.patch

This patch was dropped because it got a reject, and I'm not sure it's worth the bloat anyway

------------------------------------------------------
Subject: let WARN_ON() output the condition
From: Jiri Kosina <jkosina@suse.cz>

It is possible, in some cases, that the output of WARN_ON() is ambiguous
and can't be properly used to identify the exact condition which caused the
warning to trigger.  This happens whenever there is a macro that contains
multiple WARN_ONs inside.  Notable example is spin_lock_mutex().  If any of
the two WARN_ONs trigger, we are not able to say which one was the cause
(as we get only line number, which however belongs to the place where the
macro was expanded).

This patch lets WARN_ON() to output also the condition and fixes the
DEBUG_LOCKS_WARN_ON() macro to pass the condition properly to WARN_ON.  The
possible drawback could be when someone passes a condition which has
sideeffects.  Then it would be evaluated twice, instead of current one
evaluation.  On the other hand, when anyone passes expression with
sideeffects to WARN_ON(), he is asking for problems anyway.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/bug.h   |    4 ++--
 include/linux/debug_locks.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/bug.h~let-warn_on-output-the-condition include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~let-warn_on-output-the-condition
+++ a/include/asm-generic/bug.h
@@ -35,8 +35,8 @@ struct bug_entry {
 #define WARN_ON(condition) ({						\
 	typeof(condition) __ret_warn_on = (condition);			\
 	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING at %s:%d %s()\n", __FILE__,	\
-			__LINE__, __FUNCTION__);			\
+		printk("WARNING (%s) at %s:%d %s()\n", #condition,	\
+			__FILE__,__LINE__, __FUNCTION__);		\
 		dump_stack();						\
 	}								\
 	unlikely(__ret_warn_on);					\
diff -puN include/linux/debug_locks.h~let-warn_on-output-the-condition include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~let-warn_on-output-the-condition
+++ a/include/linux/debug_locks.h
@@ -25,7 +25,7 @@ extern int debug_locks_off(void);
 									\
 	if (unlikely(c)) {						\
 		if (debug_locks_silent || debug_locks_off())		\
-			WARN_ON(1);					\
+			WARN_ON(c);					\
 		__ret = 1;						\
 	}								\
 	__ret;								\
_

Patches currently in -mm which might be from jkosina@suse.cz are

let-warn_on-output-the-condition.patch

