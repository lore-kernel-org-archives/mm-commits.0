From: akpm@osdl.org
Subject: + fix-various-kernel-doc-in-header-files.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:07:26 -0800
Message-ID: <200701250407.l0P47QSE005396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184AbXAYEHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:07:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, randy.dunlap@oracle.com


The patch titled
     fix various kernel-doc in header files
has been added to the -mm tree.  Its filename is
     fix-various-kernel-doc-in-header-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix various kernel-doc in header files
From: Robert P. J. Day <rpjday@mindspring.com>

Fix a number of kernel-doc entries for header files in include/linux by
making sure they begin with the appropriate '/**' notation and use @var
notation.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/bitops.h  |    6 ++----
 include/linux/list.h    |   10 +++++-----
 include/linux/mutex.h   |    2 +-
 include/linux/rtmutex.h |    4 ++--
 include/linux/timer.h   |    4 ++--
 5 files changed, 12 insertions(+), 14 deletions(-)

diff -puN include/linux/bitops.h~fix-various-kernel-doc-in-header-files include/linux/bitops.h
--- a/include/linux/bitops.h~fix-various-kernel-doc-in-header-files
+++ a/include/linux/bitops.h
@@ -31,9 +31,8 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
+/**
  * rol32 - rotate a 32-bit value left
- *
  * @word: value to rotate
  * @shift: bits to roll
  */
@@ -42,9 +41,8 @@ static inline __u32 rol32(__u32 word, un
 	return (word << shift) | (word >> (32 - shift));
 }
 
-/*
+/**
  * ror32 - rotate a 32-bit value right
- *
  * @word: value to rotate
  * @shift: bits to roll
  */
diff -puN include/linux/list.h~fix-various-kernel-doc-in-header-files include/linux/list.h
--- a/include/linux/list.h~fix-various-kernel-doc-in-header-files
+++ a/include/linux/list.h
@@ -227,13 +227,13 @@ static inline void list_replace_init(str
 	INIT_LIST_HEAD(old);
 }
 
-/*
+/**
  * list_replace_rcu - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
  *
- * The old entry will be replaced with the new entry atomically.
- * Note: 'old' should not be empty.
+ * The @old entry will be replaced with the @new entry atomically.
+ * Note: @old should not be empty.
  */
 static inline void list_replace_rcu(struct list_head *old,
 				struct list_head *new)
@@ -680,12 +680,12 @@ static inline void hlist_del_init(struct
 	}
 }
 
-/*
+/**
  * hlist_replace_rcu - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
  *
- * The old entry will be replaced with the new entry atomically.
+ * The @old entry will be replaced with the @new entry atomically.
  */
 static inline void hlist_replace_rcu(struct hlist_node *old,
 					struct hlist_node *new)
diff -puN include/linux/mutex.h~fix-various-kernel-doc-in-header-files include/linux/mutex.h
--- a/include/linux/mutex.h~fix-various-kernel-doc-in-header-files
+++ a/include/linux/mutex.h
@@ -105,7 +105,7 @@ do {							\
 extern void __mutex_init(struct mutex *lock, const char *name,
 			 struct lock_class_key *key);
 
-/***
+/**
  * mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
  *
diff -puN include/linux/rtmutex.h~fix-various-kernel-doc-in-header-files include/linux/rtmutex.h
--- a/include/linux/rtmutex.h~fix-various-kernel-doc-in-header-files
+++ a/include/linux/rtmutex.h
@@ -16,7 +16,7 @@
 #include <linux/plist.h>
 #include <linux/spinlock_types.h>
 
-/*
+/**
  * The rt_mutex structure
  *
  * @wait_lock:	spinlock to protect the structure
@@ -71,7 +71,7 @@ struct hrtimer_sleeper;
 #define DEFINE_RT_MUTEX(mutexname) \
 	struct rt_mutex mutexname = __RT_MUTEX_INITIALIZER(mutexname)
 
-/***
+/**
  * rt_mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
  *
diff -puN include/linux/timer.h~fix-various-kernel-doc-in-header-files include/linux/timer.h
--- a/include/linux/timer.h~fix-various-kernel-doc-in-header-files
+++ a/include/linux/timer.h
@@ -41,7 +41,7 @@ static inline void setup_timer(struct ti
 	init_timer(timer);
 }
 
-/***
+/**
  * timer_pending - is a timer pending?
  * @timer: the timer in question
  *
@@ -63,7 +63,7 @@ extern int mod_timer(struct timer_list *
 
 extern unsigned long next_timer_interrupt(void);
 
-/***
+/**
  * add_timer - start a timer
  * @timer: the timer to be added
  *
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
