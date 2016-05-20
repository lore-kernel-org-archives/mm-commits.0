From: akpm@linux-foundation.org
Subject: [patch 015/117] debugobjects: insulate non-fixup logic related to static obj from fixup callbacks
Date: Thu, 19 May 2016 17:09:41 -0700
Message-ID: <573e55c5.LT/KEaUO20U2J53q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcETAJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org

From: "Du, Changbin" <changbin.du@intel.com>
Subject: debugobjects: insulate non-fixup logic related to static obj from fixup callbacks

When activating a static object we need make sure that the object is
tracked in the object tracker.  If it is a non-static object then the
activation is illegal.

In previous implementation, each subsystem need take care of this in their
fixup callbacks.  Actually we can put it into debugobjects core.  Thus we
can save duplicated code, and have *pure* fixup callbacks.

To achieve this, a new callback "is_static_object" is introduced to let
the type specific code decide whether a object is static or not.  If yes,
we take it into object tracker, otherwise give warning and invoke fixup
callback.

This change has paassed debugobjects selftest, and I also do some test
with all debugobjects supports enabled.

At last, I have a concern about the fixups that can it change the
object which is in incorrect state on fixup? Because the 'addr' may
not point to any valid object if a non-static object is not tracked.
Then Change such object can overwrite someone's memory and cause
unexpected behaviour. For example, the timer_fixup_activate bind
timer to function stub_timer.

Link: http://lkml.kernel.org/r/1462576157-14539-1-git-send-email-changbin.du@intel.com
[changbin.du@intel.com: improve code comments where invoke the new is_static_object callback]
  Link: http://lkml.kernel.org/r/1462777431-8171-1-git-send-email-changbin.du@intel.com
Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debugobjects.h |    2 +
 kernel/rcu/update.c          |   26 ++---------------
 kernel/time/hrtimer.c        |    7 ----
 kernel/time/timer.c          |   43 +++++++++-------------------
 kernel/workqueue.c           |   42 +++++-----------------------
 lib/debugobjects.c           |   49 +++++++++++++++++++++------------
 6 files changed, 60 insertions(+), 109 deletions(-)

diff -puN include/linux/debugobjects.h~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks include/linux/debugobjects.h
--- a/include/linux/debugobjects.h~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/include/linux/debugobjects.h
@@ -38,6 +38,7 @@ struct debug_obj {
  * @name:		name of the object typee
  * @debug_hint:		function returning address, which have associated
  *			kernel symbol, to allow identify the object
+ * @is_static_object	return true if the obj is static, otherwise return false
  * @fixup_init:		fixup function, which is called when the init check
  *			fails. All fixup functions must return true if fixup
  *			was successful, otherwise return false
@@ -53,6 +54,7 @@ struct debug_obj {
 struct debug_obj_descr {
 	const char		*name;
 	void *(*debug_hint)(void *addr);
+	bool (*is_static_object)(void *addr);
 	bool (*fixup_init)(void *addr, enum debug_obj_state state);
 	bool (*fixup_activate)(void *addr, enum debug_obj_state state);
 	bool (*fixup_destroy)(void *addr, enum debug_obj_state state);
diff -puN kernel/rcu/update.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks kernel/rcu/update.c
--- a/kernel/rcu/update.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/kernel/rcu/update.c
@@ -380,29 +380,9 @@ void destroy_rcu_head(struct rcu_head *h
 	debug_object_free(head, &rcuhead_debug_descr);
 }
 
-/*
- * fixup_activate is called when:
- * - an active object is activated
- * - an unknown object is activated (might be a statically initialized object)
- * Activation is performed internally by call_rcu().
- */
-static bool rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+static bool rcuhead_is_static_object(void *addr)
 {
-	struct rcu_head *head = addr;
-
-	switch (state) {
-
-	case ODEBUG_STATE_NOTAVAILABLE:
-		/*
-		 * This is not really a fixup. We just make sure that it is
-		 * tracked in the object tracker.
-		 */
-		debug_object_init(head, &rcuhead_debug_descr);
-		debug_object_activate(head, &rcuhead_debug_descr);
-		return false;
-	default:
-		return true;
-	}
+	return true;
 }
 
 /**
@@ -440,7 +420,7 @@ EXPORT_SYMBOL_GPL(destroy_rcu_head_on_st
 
 struct debug_obj_descr rcuhead_debug_descr = {
 	.name = "rcu_head",
-	.fixup_activate = rcuhead_fixup_activate,
+	.is_static_object = rcuhead_is_static_object,
 };
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
diff -puN kernel/time/hrtimer.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/kernel/time/hrtimer.c
@@ -351,16 +351,11 @@ static bool hrtimer_fixup_init(void *add
 /*
  * fixup_activate is called when:
  * - an active object is activated
- * - an unknown object is activated (might be a statically initialized object)
+ * - an unknown non-static object is activated
  */
 static bool hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	switch (state) {
-
-	case ODEBUG_STATE_NOTAVAILABLE:
-		WARN_ON_ONCE(1);
-		return false;
-
 	case ODEBUG_STATE_ACTIVE:
 		WARN_ON(1);
 
diff -puN kernel/time/timer.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks kernel/time/timer.c
--- a/kernel/time/timer.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/kernel/time/timer.c
@@ -489,6 +489,14 @@ static void *timer_debug_hint(void *addr
 	return ((struct timer_list *) addr)->function;
 }
 
+static bool timer_is_static_object(void *addr)
+{
+	struct timer_list *timer = addr;
+
+	return (timer->entry.pprev == NULL &&
+		timer->entry.next == TIMER_ENTRY_STATIC);
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -516,30 +524,16 @@ static void stub_timer(unsigned long dat
 /*
  * fixup_activate is called when:
  * - an active object is activated
- * - an unknown object is activated (might be a statically initialized object)
+ * - an unknown non-static object is activated
  */
 static bool timer_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	struct timer_list *timer = addr;
 
 	switch (state) {
-
 	case ODEBUG_STATE_NOTAVAILABLE:
-		/*
-		 * This is not really a fixup. The timer was
-		 * statically initialized. We just make sure that it
-		 * is tracked in the object tracker.
-		 */
-		if (timer->entry.pprev == NULL &&
-		    timer->entry.next == TIMER_ENTRY_STATIC) {
-			debug_object_init(timer, &timer_debug_descr);
-			debug_object_activate(timer, &timer_debug_descr);
-			return false;
-		} else {
-			setup_timer(timer, stub_timer, 0);
-			return true;
-		}
-		return false;
+		setup_timer(timer, stub_timer, 0);
+		return true;
 
 	case ODEBUG_STATE_ACTIVE:
 		WARN_ON(1);
@@ -577,18 +571,8 @@ static bool timer_fixup_assert_init(void
 
 	switch (state) {
 	case ODEBUG_STATE_NOTAVAILABLE:
-		if (timer->entry.next == TIMER_ENTRY_STATIC) {
-			/*
-			 * This is not really a fixup. The timer was
-			 * statically initialized. We just make sure that it
-			 * is tracked in the object tracker.
-			 */
-			debug_object_init(timer, &timer_debug_descr);
-			return false;
-		} else {
-			setup_timer(timer, stub_timer, 0);
-			return true;
-		}
+		setup_timer(timer, stub_timer, 0);
+		return true;
 	default:
 		return false;
 	}
@@ -597,6 +581,7 @@ static bool timer_fixup_assert_init(void
 static struct debug_obj_descr timer_debug_descr = {
 	.name			= "timer_list",
 	.debug_hint		= timer_debug_hint,
+	.is_static_object	= timer_is_static_object,
 	.fixup_init		= timer_fixup_init,
 	.fixup_activate		= timer_fixup_activate,
 	.fixup_free		= timer_fixup_free,
diff -puN kernel/workqueue.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks kernel/workqueue.c
--- a/kernel/workqueue.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/kernel/workqueue.c
@@ -433,6 +433,13 @@ static void *work_debug_hint(void *addr)
 	return ((struct work_struct *) addr)->func;
 }
 
+static bool work_is_static_object(void *addr)
+{
+	struct work_struct *work = addr;
+
+	return test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work));
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -452,39 +459,6 @@ static bool work_fixup_init(void *addr,
 }
 
 /*
- * fixup_activate is called when:
- * - an active object is activated
- * - an unknown object is activated (might be a statically initialized object)
- */
-static bool work_fixup_activate(void *addr, enum debug_obj_state state)
-{
-	struct work_struct *work = addr;
-
-	switch (state) {
-
-	case ODEBUG_STATE_NOTAVAILABLE:
-		/*
-		 * This is not really a fixup. The work struct was
-		 * statically initialized. We just make sure that it
-		 * is tracked in the object tracker.
-		 */
-		if (test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work))) {
-			debug_object_init(work, &work_debug_descr);
-			debug_object_activate(work, &work_debug_descr);
-			return false;
-		}
-		WARN_ON_ONCE(1);
-		return false;
-
-	case ODEBUG_STATE_ACTIVE:
-		WARN_ON(1);
-
-	default:
-		return false;
-	}
-}
-
-/*
  * fixup_free is called when:
  * - an active object is freed
  */
@@ -505,8 +479,8 @@ static bool work_fixup_free(void *addr,
 static struct debug_obj_descr work_debug_descr = {
 	.name		= "work_struct",
 	.debug_hint	= work_debug_hint,
+	.is_static_object = work_is_static_object,
 	.fixup_init	= work_fixup_init,
-	.fixup_activate	= work_fixup_activate,
 	.fixup_free	= work_fixup_free,
 };
 
diff -puN lib/debugobjects.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-insulate-non-fixup-logic-related-to-static-obj-from-fixup-callbacks
+++ a/lib/debugobjects.c
@@ -431,14 +431,21 @@ int debug_object_activate(void *addr, st
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 	/*
-	 * This happens when a static object is activated. We
-	 * let the type specific code decide whether this is
-	 * true or not.
+	 * We are here when a static object is activated. We
+	 * let the type specific code confirm whether this is
+	 * true or not. if true, we just make sure that the
+	 * static object is tracked in the object tracker. If
+	 * not, this must be a bug, so we try to fix it up.
 	 */
-	if (debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE)) {
+	if (descr->is_static_object && descr->is_static_object(addr)) {
+		/* track this static object */
+		debug_object_init(addr, descr);
+		debug_object_activate(addr, descr);
+	} else {
 		debug_print_object(&o, "activate");
-		return -EINVAL;
+		ret = debug_object_fixup(descr->fixup_activate, addr,
+					ODEBUG_STATE_NOTAVAILABLE);
+		return ret ? 0 : -EINVAL;
 	}
 	return 0;
 }
@@ -602,12 +609,18 @@ void debug_object_assert_init(void *addr
 
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		/*
-		 * Maybe the object is static.  Let the type specific
-		 * code decide what to do.
+		 * Maybe the object is static, and we let the type specific
+		 * code confirm. Track this static object if true, else invoke
+		 * fixup.
 		 */
-		if (debug_object_fixup(descr->fixup_assert_init, addr,
-				       ODEBUG_STATE_NOTAVAILABLE))
+		if (descr->is_static_object && descr->is_static_object(addr)) {
+			/* Track this static object */
+			debug_object_init(addr, descr);
+		} else {
 			debug_print_object(&o, "assert_init");
+			debug_object_fixup(descr->fixup_assert_init, addr,
+					   ODEBUG_STATE_NOTAVAILABLE);
+		}
 		return;
 	}
 
@@ -792,6 +805,13 @@ struct self_test {
 
 static __initdata struct debug_obj_descr descr_type_test;
 
+static bool __init is_static_object(void *addr)
+{
+	struct self_test *obj = addr;
+
+	return obj->static_init;
+}
+
 /*
  * fixup_init is called when:
  * - an active object is initialized
@@ -813,7 +833,7 @@ static bool __init fixup_init(void *addr
 /*
  * fixup_activate is called when:
  * - an active object is activated
- * - an unknown object is activated (might be a statically initialized object)
+ * - an unknown non-static object is activated
  */
 static bool __init fixup_activate(void *addr, enum debug_obj_state state)
 {
@@ -821,13 +841,7 @@ static bool __init fixup_activate(void *
 
 	switch (state) {
 	case ODEBUG_STATE_NOTAVAILABLE:
-		if (obj->static_init == 1) {
-			debug_object_init(obj, &descr_type_test);
-			debug_object_activate(obj, &descr_type_test);
-			return false;
-		}
 		return true;
