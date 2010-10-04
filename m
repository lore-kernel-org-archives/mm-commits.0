From: akpm@linux-foundation.org
Subject: + timer-permit-statically-declared-work-with-deferrable-timers.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:02:56 -0700
Message-ID: <201010042302.o94N2uxR020954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab0JDXDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, Artem.Bityutskiy@nokia.com, arjan@infradead.org, tglx@linutronix.de


The patch titled
     timer: permit statically-declared work with deferrable timers
has been added to the -mm tree.  Its filename is
     timer-permit-statically-declared-work-with-deferrable-timers.patch

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
Subject: timer: permit statically-declared work with deferrable timers
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Currently, you have to just define a delayed_work uninitialised, and then
initialise it before first use.  That's a tad clumsy.  At risk of playing
mind-games with the compiler, fooling it into doing pointer arithmetic
with compile-time-constants, this lets clients properly initialise delayed
work with deferrable timers statically.

This patch was inspired by the issues which lead Artem Bityutskiy to
commit 8eab945c5616fc984 ("sunrpc: make the cache cleaner workqueue
deferrable").

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h     |   25 +++++++++++++++++++++++++
 include/linux/workqueue.h |    8 ++++++++
 kernel/timer.c            |   15 +--------------
 3 files changed, 34 insertions(+), 14 deletions(-)

diff -puN include/linux/timer.h~timer-permit-statically-declared-work-with-deferrable-timers include/linux/timer.h
--- a/include/linux/timer.h~timer-permit-statically-declared-work-with-deferrable-timers
+++ a/include/linux/timer.h
@@ -48,6 +48,18 @@ extern struct tvec_base boot_tvec_bases;
 #define __TIMER_LOCKDEP_MAP_INITIALIZER(_kn)
 #endif
 
+/*
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB to
+ * indicate whether the timer is deferrable.
+ *
+ * A deferrable timer will work normally when the system is busy, but
+ * will not cause a CPU to come out of idle just to service it; instead,
+ * the timer will be serviced when the CPU eventually wakes up with a
+ * subsequent non-deferrable timer.
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
@@ -59,6 +71,19 @@ extern struct tvec_base boot_tvec_bases;
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
 
+#define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
+		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
+
+#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
+		.entry = { .prev = TIMER_ENTRY_STATIC },	\
+		.function = (_function),			\
+		.expires = (_expires),				\
+		.data = (_data),				\
+		.base = TBASE_MAKE_DEFERRED(&boot_tvec_bases),	\
+		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
+			__FILE__ ":" __stringify(__LINE__))	\
+	}
+
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
diff -puN include/linux/workqueue.h~timer-permit-statically-declared-work-with-deferrable-timers include/linux/workqueue.h
--- a/include/linux/workqueue.h~timer-permit-statically-declared-work-with-deferrable-timers
+++ a/include/linux/workqueue.h
@@ -127,12 +127,20 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
+#define __DEFERRED_WORK_INITIALIZER(n, f) {			\
+	.work = __WORK_INITIALIZER((n).work, (f)),		\
+	.timer = TIMER_DEFERRED_INITIALIZER(NULL, 0, 0),	\
+	}
+
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
+#define DECLARE_DEFERRED_WORK(n, f)				\
+	struct delayed_work n = __DEFERRED_WORK_INITIALIZER(n, f)
+
 /*
  * initialize a work item's function pointer
  */
diff -puN kernel/timer.c~timer-permit-statically-declared-work-with-deferrable-timers kernel/timer.c
--- a/kernel/timer.c~timer-permit-statically-declared-work-with-deferrable-timers
+++ a/kernel/timer.c
@@ -88,18 +88,6 @@ struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
-/*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB to
- * indicate whether the timer is deferrable.
- *
- * A deferrable timer will work normally when the system is busy, but
- * will not cause a CPU to come out of idle just to service it; instead,
- * the timer will be serviced when the CPU eventually wakes up with a
- * subsequent non-deferrable timer.
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
