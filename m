From: akpm@linux-foundation.org
Subject: + lockdep-add-novalidate-class-for-dev-mutex-conversion.patch added to -mm tree
Date: Thu, 18 Mar 2010 22:51:26 -0400
Message-ID: <201003190552.o2J5q8kU005078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab0CSFw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 01:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, Valdis.Kletnieks@vt.edu, greg@kroah.com, tglx@linutronix.de


The patch titled
     lockdep: add novalidate class for dev->mutex conversion
has been added to the -mm tree.  Its filename is
     lockdep-add-novalidate-class-for-dev-mutex-conversion.patch

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
Subject: lockdep: add novalidate class for dev->mutex conversion
From: Peter Zijlstra <peterz@infradead.org>

The conversion of device->sem to device->mutex resulted in lockdep
warnings.  Create a novalidate class for now until the driver folks come
up with separate classes.  That way we have at least the basic mutex
debugging coverage.

Add a checkpatch error so the usage is reserved for device->mutex.

[tglx@linutronix.de: checkpatch and compile fix for LOCKDEP=n]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c     |    1 +
 include/linux/lockdep.h |    8 ++++++++
 kernel/lockdep.c        |    5 +++++
 scripts/checkpatch.pl   |   11 +++++++++++
 4 files changed, 25 insertions(+)

diff -puN drivers/base/core.c~lockdep-add-novalidate-class-for-dev-mutex-conversion drivers/base/core.c
--- a/drivers/base/core.c~lockdep-add-novalidate-class-for-dev-mutex-conversion
+++ a/drivers/base/core.c
@@ -559,6 +559,7 @@ void device_initialize(struct device *de
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
+	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
diff -puN include/linux/lockdep.h~lockdep-add-novalidate-class-for-dev-mutex-conversion include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-add-novalidate-class-for-dev-mutex-conversion
+++ a/include/linux/lockdep.h
@@ -44,6 +44,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+extern struct lock_class_key __lockdep_no_validate__;
+
 #define LOCKSTAT_POINTS		4
 
 /*
@@ -270,6 +272,9 @@ extern void lockdep_init_map(struct lock
 #define lockdep_set_subclass(lock, sub)	\
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
+
+#define lockdep_set_novalidate_class(lock) \
+	lockdep_set_class(lock, &__lockdep_no_validate__)
 /*
  * Compare locking classes
  */
@@ -354,6 +359,9 @@ static inline void lockdep_on(void)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
+
+#define lockdep_set_novalidate_class(lock) do { } while (0)
+
 /*
  * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
  * case since the result is not well defined and the caller should rather
diff -puN kernel/lockdep.c~lockdep-add-novalidate-class-for-dev-mutex-conversion kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-add-novalidate-class-for-dev-mutex-conversion
+++ a/kernel/lockdep.c
@@ -2716,6 +2716,8 @@ void lockdep_init_map(struct lockdep_map
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
+struct lock_class_key __lockdep_no_validate__;
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -2750,6 +2752,9 @@ static int __lock_acquire(struct lockdep
 		return 0;
 	}
 
+	if (lock->key == &__lockdep_no_validate__)
+		check = 1;
+
 	if (!subclass)
 		class = lock->class_cache;
 	/*
diff -puN scripts/checkpatch.pl~lockdep-add-novalidate-class-for-dev-mutex-conversion scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~lockdep-add-novalidate-class-for-dev-mutex-conversion
+++ a/scripts/checkpatch.pl
@@ -2656,6 +2656,7 @@ sub process {
 # check for semaphores used as mutexes
 		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
 			WARN("consider using a completion\n" . $herecurr);
+
 		}
 # recommend strict_strto* over simple_strto*
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
@@ -2740,6 +2741,16 @@ sub process {
 				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
+
+# check for lockdep_set_novalidate_class
+		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
+		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
+			if ($realfile !~ m@^kernel/lockdep@ &&
+			    $realfile !~ m@^include/linux/lockdep@ &&
+			    $realfile !~ m@^drivers/base/core@) {
+				ERROR("lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
lockdep-add-novalidate-class-for-dev-mutex-conversion.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

