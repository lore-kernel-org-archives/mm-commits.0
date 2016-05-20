From: akpm@linux-foundation.org
Subject: [merged]
 timer-update-debugobjects-fixup-callbacks-return-type.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:02:43 -0700
Message-ID: <573f7b73.KQbu9BYtLjbbU2YG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: timer: update debugobjects fixup callbacks return type
has been removed from the -mm tree.  Its filename was
     timer-update-debugobjects-fixup-callbacks-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Du, Changbin" <changbin.du@intel.com>
Subject: timer: update debugobjects fixup callbacks return type

Update the return type to use bool instead of int, corresponding to
cheange (debugobjects: make fixup functions return bool instead of int).

Signed-off-by: Du, Changbin <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/hrtimer.c |   18 +++++++++---------
 kernel/time/timer.c   |   30 +++++++++++++++---------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN kernel/time/hrtimer.c~timer-update-debugobjects-fixup-callbacks-return-type kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~timer-update-debugobjects-fixup-callbacks-return-type
+++ a/kernel/time/hrtimer.c
@@ -334,7 +334,7 @@ static void *hrtimer_debug_hint(void *ad
  * fixup_init is called when:
  * - an active object is initialized
  */
-static int hrtimer_fixup_init(void *addr, enum debug_obj_state state)
+static bool hrtimer_fixup_init(void *addr, enum debug_obj_state state)
 {
 	struct hrtimer *timer = addr;
 
@@ -342,9 +342,9 @@ static int hrtimer_fixup_init(void *addr
 	case ODEBUG_STATE_ACTIVE:
 		hrtimer_cancel(timer);
 		debug_object_init(timer, &hrtimer_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -353,19 +353,19 @@ static int hrtimer_fixup_init(void *addr
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
  */
-static int hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
+static bool hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	switch (state) {
 
 	case ODEBUG_STATE_NOTAVAILABLE:
 		WARN_ON_ONCE(1);
-		return 0;
+		return false;
 
 	case ODEBUG_STATE_ACTIVE:
 		WARN_ON(1);
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -373,7 +373,7 @@ static int hrtimer_fixup_activate(void *
  * fixup_free is called when:
  * - an active object is freed
  */
-static int hrtimer_fixup_free(void *addr, enum debug_obj_state state)
+static bool hrtimer_fixup_free(void *addr, enum debug_obj_state state)
 {
 	struct hrtimer *timer = addr;
 
@@ -381,9 +381,9 @@ static int hrtimer_fixup_free(void *addr
 	case ODEBUG_STATE_ACTIVE:
 		hrtimer_cancel(timer);
 		debug_object_free(timer, &hrtimer_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
diff -puN kernel/time/timer.c~timer-update-debugobjects-fixup-callbacks-return-type kernel/time/timer.c
--- a/kernel/time/timer.c~timer-update-debugobjects-fixup-callbacks-return-type
+++ a/kernel/time/timer.c
@@ -493,7 +493,7 @@ static void *timer_debug_hint(void *addr
  * fixup_init is called when:
  * - an active object is initialized
  */
-static int timer_fixup_init(void *addr, enum debug_obj_state state)
+static bool timer_fixup_init(void *addr, enum debug_obj_state state)
 {
 	struct timer_list *timer = addr;
 
@@ -501,9 +501,9 @@ static int timer_fixup_init(void *addr,
 	case ODEBUG_STATE_ACTIVE:
 		del_timer_sync(timer);
 		debug_object_init(timer, &timer_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -518,7 +518,7 @@ static void stub_timer(unsigned long dat
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
  */
-static int timer_fixup_activate(void *addr, enum debug_obj_state state)
+static bool timer_fixup_activate(void *addr, enum debug_obj_state state)
 {
 	struct timer_list *timer = addr;
 
@@ -534,18 +534,18 @@ static int timer_fixup_activate(void *ad
 		    timer->entry.next == TIMER_ENTRY_STATIC) {
 			debug_object_init(timer, &timer_debug_descr);
 			debug_object_activate(timer, &timer_debug_descr);
-			return 0;
+			return false;
 		} else {
 			setup_timer(timer, stub_timer, 0);
-			return 1;
+			return true;
 		}
-		return 0;
+		return false;
 
 	case ODEBUG_STATE_ACTIVE:
 		WARN_ON(1);
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -553,7 +553,7 @@ static int timer_fixup_activate(void *ad
  * fixup_free is called when:
  * - an active object is freed
  */
-static int timer_fixup_free(void *addr, enum debug_obj_state state)
+static bool timer_fixup_free(void *addr, enum debug_obj_state state)
 {
 	struct timer_list *timer = addr;
 
@@ -561,9 +561,9 @@ static int timer_fixup_free(void *addr,
 	case ODEBUG_STATE_ACTIVE:
 		del_timer_sync(timer);
 		debug_object_free(timer, &timer_debug_descr);
-		return 1;
+		return true;
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -571,7 +571,7 @@ static int timer_fixup_free(void *addr,
  * fixup_assert_init is called when:
  * - an untracked/uninit-ed object is found
  */
-static int timer_fixup_assert_init(void *addr, enum debug_obj_state state)
+static bool timer_fixup_assert_init(void *addr, enum debug_obj_state state)
 {
 	struct timer_list *timer = addr;
 
@@ -584,13 +584,13 @@ static int timer_fixup_assert_init(void
 			 * is tracked in the object tracker.
 			 */
 			debug_object_init(timer, &timer_debug_descr);
-			return 0;
+			return false;
 		} else {
 			setup_timer(timer, stub_timer, 0);
-			return 1;
+			return true;
 		}
 	default:
-		return 0;
+		return false;
 	}
 }
 
_

Patches currently in -mm which might be from changbin.du@intel.com are

checkpatch-add-support-to-check-already-applied-git-commits.patch

