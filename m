From: akpm@linux-foundation.org
Subject: [patch 008/117] debugobjects: make fixup functions return bool
 instead of int
Date: Thu, 19 May 2016 17:09:20 -0700
Message-ID: <573e55b0.cltAzmdxSxCtMMTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbcETAJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org

From: "Du, Changbin" <changbin.du@intel.com>
Subject: debugobjects: make fixup functions return bool instead of int

I am going to introduce debugobjects infrastructure to USB subsystem.  But
before this, I found the code of debugobjects could be improved.  This
patchset will make fixup functions return bool type instead of int. 
Because fixup only need report success or no.  boolean is the 'real' type.



This patch (of 7):

The object debugging infrastructure core provides some fixup callbacks for
the subsystem who use it.  These callbacks are called from the debug code
whenever a problem in debug_object_init is detected.  And debugobjects
core suppose them returns 1 when the fixup was successful, otherwise 0. 
So the return type is boolean.

A bad thing is that debug_object_fixup use the return value for arithmetic
operation.  It confused me that what is the reall return type.

Reading over the whole code, I found some place do use the return value
incorrectly(see next patch).  So why use bool type instead?

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debugobjects.h |   15 ++++++-----
 lib/debugobjects.c           |   43 ++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff -puN include/linux/debugobjects.h~debugobjects-make-fixup-functions-return-bool-instead-of-int include/linux/debugobjects.h
--- a/include/linux/debugobjects.h~debugobjects-make-fixup-functions-return-bool-instead-of-int
+++ a/include/linux/debugobjects.h
@@ -39,7 +39,8 @@ struct debug_obj {
  * @debug_hint:		function returning address, which have associated
  *			kernel symbol, to allow identify the object
  * @fixup_init:		fixup function, which is called when the init check
- *			fails
+ *			fails. All fixup functions must return true if fixup
+ *			was successful, otherwise return false
  * @fixup_activate:	fixup function, which is called when the activate check
  *			fails
  * @fixup_destroy:	fixup function, which is called when the destroy check
@@ -51,12 +52,12 @@ struct debug_obj {
  */
 struct debug_obj_descr {
 	const char		*name;
-	void *(*debug_hint)	(void *addr);
-	int (*fixup_init)	(void *addr, enum debug_obj_state state);
-	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
-	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
-	int (*fixup_free)	(void *addr, enum debug_obj_state state);
-	int (*fixup_assert_init)(void *addr, enum debug_obj_state state);
+	void *(*debug_hint)(void *addr);
+	bool (*fixup_init)(void *addr, enum debug_obj_state state);
+	bool (*fixup_activate)(void *addr, enum debug_obj_state state);
+	bool (*fixup_destroy)(void *addr, enum debug_obj_state state);
+	bool (*fixup_free)(void *addr, enum debug_obj_state state);
+	bool (*fixup_assert_init)(void *addr, enum debug_obj_state state);
 };
 
 #ifdef CONFIG_DEBUG_OBJECTS
diff -puN lib/debugobjects.c~debugobjects-make-fixup-functions-return-bool-instead-of-int lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-make-fixup-functions-return-bool-instead-of-int
+++ a/lib/debugobjects.c
@@ -269,16 +269,15 @@ static void debug_print_object(struct de
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
  */
-static int
-debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
+static bool
+debug_object_fixup(bool (*fixup)(void *addr, enum debug_obj_state state),
 		   void * addr, enum debug_obj_state state)
 {
-	int fixed = 0;
-
-	if (fixup)
-		fixed = fixup(addr, state);
-	debug_objects_fixups += fixed;
-	return fixed;
+	if (fixup && fixup(addr, state)) {
+		debug_objects_fixups++;
+		return true;
+	}
+	return false;
 }
 
 static void debug_object_is_on_stack(void *addr, int onstack)
@@ -797,7 +796,7 @@ static __initdata struct debug_obj_descr
  * fixup_init is called when:
  * - an active object is initialized
  */
-static int __init fixup_init(void *addr, enum debug_obj_state state)
+static bool __init fixup_init(void *addr, enum debug_obj_state state)
 {
 	struct self_test *obj = addr;
 
@@ -805,9 +804,9 @@ static int __init fixup_init(void *addr,
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
 		debug_object_init(obj, &descr_type_test);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -816,7 +815,7 @@ static int __init fixup_init(void *addr,
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
  */
-static int __init fixup_activate(void *addr, enum debug_obj_state state)
+static bool __init fixup_activate(void *addr, enum debug_obj_state state)
 {
 	struct self_test *obj = addr;
 
@@ -825,17 +824,17 @@ static int __init fixup_activate(void *a
 		if (obj->static_init == 1) {
 			debug_object_init(obj, &descr_type_test);
 			debug_object_activate(obj, &descr_type_test);
-			return 0;
+			return false;
 		}
-		return 1;
+		return true;
 
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
 		debug_object_activate(obj, &descr_type_test);
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -843,7 +842,7 @@ static int __init fixup_activate(void *a
  * fixup_destroy is called when:
  * - an active object is destroyed
  */
-static int __init fixup_destroy(void *addr, enum debug_obj_state state)
+static bool __init fixup_destroy(void *addr, enum debug_obj_state state)
 {
 	struct self_test *obj = addr;
 
@@ -851,9 +850,9 @@ static int __init fixup_destroy(void *ad
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
 		debug_object_destroy(obj, &descr_type_test);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -861,7 +860,7 @@ static int __init fixup_destroy(void *ad
  * fixup_free is called when:
  * - an active object is freed
  */
-static int __init fixup_free(void *addr, enum debug_obj_state state)
+static bool __init fixup_free(void *addr, enum debug_obj_state state)
 {
 	struct self_test *obj = addr;
 
@@ -869,9 +868,9 @@ static int __init fixup_free(void *addr,
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
 		debug_object_free(obj, &descr_type_test);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
_
