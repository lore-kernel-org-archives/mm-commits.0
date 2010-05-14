From: akpm@linux-foundation.org
Subject: + timer-add-on-stack-deferrable-timer-interfaces.patch added to -mm tree
Date: Fri, 14 May 2010 16:11:35 -0700
Message-ID: <201005142311.o4ENBZ2D028128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab0ENXMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 19:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, arjan@infradead.org, hpa@zytor.com, mingo@elte.hu, mjg59@srcf.ucam.org, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     timer: add on-stack deferrable timer interfaces
has been added to the -mm tree.  Its filename is
     timer-add-on-stack-deferrable-timer-interfaces.patch

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
Subject: timer: add on-stack deferrable timer interfaces
From: Jesse Barnes <jbarnes@virtuousgeek.org>

In some cases (for instance with kernel threads) it may be desireable to
use on-stack deferrable timers to get their power saving benefits.  Add
interfaces to support this for the IPS driver.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |   15 +++++++++++++++
 kernel/timer.c        |   13 +++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/timer.h~timer-add-on-stack-deferrable-timer-interfaces include/linux/timer.h
--- a/include/linux/timer.h~timer-add-on-stack-deferrable-timer-interfaces
+++ a/include/linux/timer.h
@@ -100,6 +100,13 @@ void init_timer_deferrable_key(struct ti
 		setup_timer_on_stack_key((timer), #timer, &__key,	\
 					 (fn), (data));			\
 	} while (0)
+#define setup_deferrable_timer_on_stack(timer, fn, data)		\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_deferrable_timer_on_stack_key((timer), #timer,	\
+						    &__key, (fn),	\
+						    (data));		\
+	} while (0)
 #else
 #define init_timer(timer)\
 	init_timer_key((timer), NULL, NULL)
@@ -111,6 +118,8 @@ void init_timer_deferrable_key(struct ti
 	setup_timer_key((timer), NULL, NULL, (fn), (data))
 #define setup_timer_on_stack(timer, fn, data)\
 	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
+#define setup_deferrable_timer_on_stack(timer, fn, data)\
+	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
 #endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
@@ -150,6 +159,12 @@ static inline void setup_timer_on_stack_
 	init_timer_on_stack_key(timer, name, key);
 }
 
+extern void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
+						const char *name,
+						struct lock_class_key *key,
+						void (*function)(unsigned long),
+						unsigned long data);
+
 /**
  * timer_pending - is a timer pending?
  * @timer: the timer in question
diff -puN kernel/timer.c~timer-add-on-stack-deferrable-timer-interfaces kernel/timer.c
--- a/kernel/timer.c~timer-add-on-stack-deferrable-timer-interfaces
+++ a/kernel/timer.c
@@ -577,6 +577,19 @@ static void __init_timer(struct timer_li
 	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
+void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
+					 const char *name,
+					 struct lock_class_key *key,
+					 void (*function)(unsigned long),
+					 unsigned long data)
+{
+	timer->function = function;
+	timer->data = data;
+	init_timer_on_stack_key(timer, name, key);
+	timer_set_deferrable(timer);
+}
+EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
+
 /**
  * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

origin.patch
linux-next.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths-fix.patch
timer-add-on-stack-deferrable-timer-interfaces.patch
x86-platform-driver-intelligent-power-sharing-driver.patch
agp-amd64-fix-pci-reference-leaks.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

