From: akpm@linux-foundation.org
Subject: + timer-update-debugobjects-fixup-callbacks-return-type.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 13:02:06 -0700
Message-ID: <571a833e.WgNDWdAqht0fa6iv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcDVUCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, borntraeger@de.ibm.com, corbet@lwn.net, josh@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: timer: update debugobjects fixup callbacks return type
has been added to the -mm tree.  Its filename is
     timer-update-debugobjects-fixup-callbacks-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/timer-update-debugobjects-fixup-callbacks-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/timer-update-debugobjects-fixup-callbacks-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

debugobjects-make-fixup-functions-return-bool-instead-of-int.patch
debugobjects-correct-the-usage-of-fixup-call-results.patch
workqueue-update-debugobjects-fixup-callbacks-return-type.patch
timer-update-debugobjects-fixup-callbacks-return-type.patch
rcu-update-debugobjects-fixup-callbacks-return-type.patch
percpu_counter-update-debugobjects-fixup-callbacks-return-type.patch
documentation-update-debugobjects-doc.patch

