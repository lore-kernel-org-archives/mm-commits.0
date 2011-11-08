From: akpm@linux-foundation.org
Subject: + debugobjects-extend-to-assert-that-an-object-is-initialized.patch added to -mm tree
Date: Tue, 08 Nov 2011 14:17:06 -0800
Message-ID: <201111082217.pA8MH60p022599@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1KHWRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cschan@codeaurora.org, akpm@linux-foundation.org, john.stultz@linaro.org, sboyd@codeaurora.org, tglx@linutronix.de


The patch titled
     Subject: debugobjects: extend to assert that an object is initialized
has been added to the -mm tree.  Its filename is
     debugobjects-extend-to-assert-that-an-object-is-initialized.patch

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
From: Christine Chan <cschan@codeaurora.org>
Subject: debugobjects: extend to assert that an object is initialized

Calling del_timer_sync() on an uninitialized timer leads to a never ending
loop in lock_timer_base() that spins checking for a non-NULL timer base. 
Add an assertion to debugobjects to catch usage of uninitialized objects
so that we can initialize timers in the del_timer_sync() path before it
calls lock_timer_base().

[sboyd@codeaurora.org: clarify commit message]
Signed-off-by: Christine Chan <cschan@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/debugobjects.tmpl |   50 ++++++++++++++++++++++
 include/linux/debugobjects.h            |    6 ++
 lib/debugobjects.c                      |   38 ++++++++++++++++
 3 files changed, 94 insertions(+)

diff -puN Documentation/DocBook/debugobjects.tmpl~debugobjects-extend-to-assert-that-an-object-is-initialized Documentation/DocBook/debugobjects.tmpl
--- a/Documentation/DocBook/debugobjects.tmpl~debugobjects-extend-to-assert-that-an-object-is-initialized
+++ a/Documentation/DocBook/debugobjects.tmpl
@@ -96,6 +96,7 @@
 	<listitem><para>debug_object_deactivate</para></listitem>
 	<listitem><para>debug_object_destroy</para></listitem>
 	<listitem><para>debug_object_free</para></listitem>
+	<listitem><para>debug_object_assert_init</para></listitem>
       </itemizedlist>
       Each of these functions takes the address of the real object and
       a pointer to the object type specific debug description
@@ -273,6 +274,26 @@
 	debug checks.
       </para>
     </sect1>
+
+    <sect1 id="debug_object_assert_init">
+      <title>debug_object_assert_init</title>
+      <para>
+	This function is called to assert that an object has been
+	initialized.
+      </para>
+      <para>
+	When the real object is not tracked by debugobjects, it calls
+	fixup_assert_init of the object type description structure
+	provided by the caller, with the hardcoded object state
+	ODEBUG_NOT_AVAILABLE. The fixup function can correct the problem
+	by calling debug_object_init and other specific initializing
+	functions.
+      </para>
+      <para>
+	When the real object is already tracked by debugobjects it is
+	ignored.
+      </para>
+    </sect1>
   </chapter>
   <chapter id="fixupfunctions">
     <title>Fixup functions</title>
@@ -381,6 +402,35 @@
 	statistics.
       </para>
     </sect1>
+    <sect1 id="fixup_assert_init">
+      <title>fixup_assert_init</title>
+      <para>
+	This function is called from the debug code whenever a problem
+	in debug_object_assert_init is detected.
+      </para>
+      <para>
+	Called from debug_object_assert_init() with a hardcoded state
+	ODEBUG_STATE_NOTAVAILABLE when the object is not found in the
+	debug bucket.
+      </para>
+      <para>
+	The function returns 1 when the fixup was successful,
+	otherwise 0. The return value is used to update the
+	statistics.
+      </para>
+      <para>
+	Note, this function should make sure debug_object_init() is
+	called before returning.
+      </para>
+      <para>
+	The handling of statically initialized objects is a special
+	case. The fixup function should check if this is a legitimate
+	case of a statically initialized object or not. In this case only
+	debug_object_init() should be called to make the object known to
+	the tracker. Then the function should return 0 because this is not
+	a real fixup.
+      </para>
+    </sect1>
   </chapter>
   <chapter id="bugs">
     <title>Known Bugs And Assumptions</title>
diff -puN include/linux/debugobjects.h~debugobjects-extend-to-assert-that-an-object-is-initialized include/linux/debugobjects.h
--- a/include/linux/debugobjects.h~debugobjects-extend-to-assert-that-an-object-is-initialized
+++ a/include/linux/debugobjects.h
@@ -46,6 +46,8 @@ struct debug_obj {
  *			fails
  * @fixup_free:		fixup function, which is called when the free check
  *			fails
+ * @fixup_assert_init:  fixup function, which is called when the assert_init
+ *			check fails
  */
 struct debug_obj_descr {
 	const char		*name;
@@ -54,6 +56,7 @@ struct debug_obj_descr {
 	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
 	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
 	int (*fixup_free)	(void *addr, enum debug_obj_state state);
+	int (*fixup_assert_init)(void *addr, enum debug_obj_state state);
 };
 
 #ifdef CONFIG_DEBUG_OBJECTS
@@ -64,6 +67,7 @@ extern void debug_object_activate  (void
 extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
+extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
 
 /*
  * Active state:
@@ -89,6 +93,8 @@ static inline void
 debug_object_destroy   (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_free      (void *addr, struct debug_obj_descr *descr) { }
+static inline void
+debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }
 
 static inline void debug_objects_early_init(void) { }
 static inline void debug_objects_mem_init(void) { }
diff -puN lib/debugobjects.c~debugobjects-extend-to-assert-that-an-object-is-initialized lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-extend-to-assert-that-an-object-is-initialized
+++ a/lib/debugobjects.c
@@ -570,6 +570,44 @@ out_unlock:
 }
 
 /**
+ * debug_object_assert_init - debug checks when object should be init-ed
+ * @addr:	address of the object
+ * @descr:	pointer to an object specific debug description structure
+ */
+void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (!obj) {
+		struct debug_obj o = { .object = addr,
+				       .state = ODEBUG_STATE_NOTAVAILABLE,
+				       .descr = descr };
+
+		raw_spin_unlock_irqrestore(&db->lock, flags);
+		/*
+		 * Maybe the object is static.  Let the type specific
+		 * code decide what to do.
+		 */
+		if (debug_object_fixup(descr->fixup_assert_init, addr,
+				ODEBUG_STATE_NOTAVAILABLE))
+			debug_print_object(&o, "assert_init");
+		return;
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+}
+
+/**
  * debug_object_active_state - debug checks object usage state machine
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
_
Subject: Subject: debugobjects: extend to assert that an object is initialized

Patches currently in -mm which might be from cschan@codeaurora.org are

debugobjects-be-smarter-about-static-objects.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch

