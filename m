From: akpm@linux-foundation.org
Subject: + debugobjects-be-smarter-about-static-objects.patch added to -mm tree
Date: Tue, 08 Nov 2011 14:17:01 -0800
Message-ID: <201111082217.pA8MH2MV009948@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54007 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1KHWRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, cschan@codeaurora.org, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: debugobjects: be smarter about static objects
has been added to the -mm tree.  Its filename is
     debugobjects-be-smarter-about-static-objects.patch

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
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: debugobjects: be smarter about static objects

Remove the WARN_ON() in timer_fixup_activate() and actually use the return
code from fixup to tell the debugobjects code to print a warning.  This
provides better diagnostic information via a nice debugobjects warning
instead of a simple WARN_ON(1) in the timer code with no information as to
what is wrong.  We also assign a dummy timer callback so that if the timer
is actually set to fire we don't oops.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Christine Chan <cschan@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c     |    9 ++++++++-
 lib/debugobjects.c |   15 +++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~debugobjects-be-smarter-about-static-objects kernel/timer.c
--- a/kernel/timer.c~debugobjects-be-smarter-about-static-objects
+++ a/kernel/timer.c
@@ -427,6 +427,12 @@ static int timer_fixup_init(void *addr, 
 	}
 }
 
+/* Stub timer callback for improperly used timers. */
+static void stub_timer(unsigned long data)
+{
+	WARN_ON(1);
+}
+
 /*
  * fixup_activate is called when:
  * - an active object is activated
@@ -450,7 +456,8 @@ static int timer_fixup_activate(void *ad
 			debug_object_activate(timer, &timer_debug_descr);
 			return 0;
 		} else {
-			WARN_ON_ONCE(1);
+			setup_timer(timer, stub_timer, 0);
+			return 1;
 		}
 		return 0;
 
diff -puN lib/debugobjects.c~debugobjects-be-smarter-about-static-objects lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-be-smarter-about-static-objects
+++ a/lib/debugobjects.c
@@ -268,12 +268,15 @@ static void debug_print_object(struct de
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
  */
-static void
+static int
 debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
 		   void * addr, enum debug_obj_state state)
 {
+	int fixed = 0;
 	if (fixup)
-		debug_objects_fixups += fixup(addr, state);
+		fixed = fixup(addr, state);
+	debug_objects_fixups += fixed;
+	return fixed;
 }
 
 static void debug_object_is_on_stack(void *addr, int onstack)
@@ -386,6 +389,9 @@ void debug_object_activate(void *addr, s
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	struct debug_obj o = { .object = addr,
+			       .state = ODEBUG_STATE_NOTAVAILABLE,
+			       .descr = descr };
 
 	if (!debug_objects_enabled)
 		return;
@@ -425,8 +431,9 @@ void debug_object_activate(void *addr, s
 	 * let the type specific code decide whether this is
 	 * true or not.
 	 */
-	debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE);
+	if (debug_object_fixup(descr->fixup_activate, addr,
+			   ODEBUG_STATE_NOTAVAILABLE))
+		debug_print_object(&o, "activate");
 }
 
 /**
_
Subject: Subject: debugobjects: be smarter about static objects

Patches currently in -mm which might be from sboyd@codeaurora.org are

debugobjects-be-smarter-about-static-objects.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch

