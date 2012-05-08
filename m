From: akpm@linux-foundation.org
Subject: + locking-add-kern_cont-when-needed-to-self-test.patch added to -mm tree
Date: Tue, 08 May 2012 14:56:48 -0700
Message-ID: <20120508215648.65246A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64526 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2EHV4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 17:56:50 -0400
Received: by faaa25 with SMTP id a25so344388faa.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 14:56:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, fweisbec@gmail.com, paul.gortmaker@windriver.com, paulmck@linux.vnet.ibm.com


The patch titled
     Subject: locking: add KERN_CONT when needed to self test
has been added to the -mm tree.  Its filename is
     locking-add-kern_cont-when-needed-to-self-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: locking: add KERN_CONT when needed to self test

Fix this behaviour:

                    A-A deadlock:
  ok  |
  ok  |
  ok  |
  ok  |
  ok  |
  ok  |

 Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/locking-selftest.c |   44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN lib/locking-selftest.c~locking-add-kern_cont-when-needed-to-self-test lib/locking-selftest.c
--- a/lib/locking-selftest.c~locking-add-kern_cont-when-needed-to-self-test
+++ a/lib/locking-selftest.c
@@ -959,16 +959,16 @@ static void dotest(void (*testcase_fn)(v
 	if (debug_locks != expected) {
 		if (expected_failure) {
 			expected_testcase_failures++;
-			printk("failed|");
+			printk(KERN_CONT "failed|");
 		} else {
 			unexpected_testcase_failures++;
 
-			printk("FAILED|");
+			printk(KERN_CONT "FAILED|");
 			dump_stack();
 		}
 	} else {
 		testcase_successes++;
-		printk("  ok  |");
+		printk(KERN_CONT "  ok  |");
 	}
 	testcase_total++;
 
@@ -998,26 +998,26 @@ static inline void print_testname(const 
 #define DO_TESTCASE_1(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_##nr, SUCCESS, LOCKTYPE_RWLOCK);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_1B(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_##nr, FAILURE, LOCKTYPE_RWLOCK);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_3(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_spin_##nr, FAILURE, LOCKTYPE_SPIN);	\
 	dotest(name##_wlock_##nr, FAILURE, LOCKTYPE_RWLOCK);	\
 	dotest(name##_rlock_##nr, SUCCESS, LOCKTYPE_RWLOCK);	\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_3RW(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_spin_##nr, FAILURE, LOCKTYPE_SPIN|LOCKTYPE_RWLOCK);\
 	dotest(name##_wlock_##nr, FAILURE, LOCKTYPE_RWLOCK);	\
 	dotest(name##_rlock_##nr, SUCCESS, LOCKTYPE_RWLOCK);	\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_6(desc, name)				\
 	print_testname(desc);					\
@@ -1027,7 +1027,7 @@ static inline void print_testname(const 
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_6_SUCCESS(desc, name)			\
 	print_testname(desc);					\
@@ -1037,7 +1037,7 @@ static inline void print_testname(const 
 	dotest(name##_mutex, SUCCESS, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, SUCCESS, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, SUCCESS, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 /*
  * 'read' variant: rlocks must not trigger.
@@ -1050,7 +1050,7 @@ static inline void print_testname(const 
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_2I(desc, name, nr)				\
 	DO_TESTCASE_1("hard-"desc, name##_hard, nr);		\
@@ -1146,32 +1146,32 @@ void locking_selftest(void)
 
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("recursive read-lock #2");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("mixed read-write-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA2, FAILURE, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA2, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("mixed write-read-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA3, FAILURE, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	printk("  --------------------------------------------------------------------------\n");
 
_
Subject: Subject: locking: add KERN_CONT when needed to self test

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-division-by-0-in-percpu_pagelist_fraction.patch
brlocks-lglocks-cleanups.patch
mm-add-missing-kern_cont-to-free_area_init_nodes.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch

