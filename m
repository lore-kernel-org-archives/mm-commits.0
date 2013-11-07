From: akpm@linux-foundation.org
Subject: + percpu-add-test-module-for-various-percpu-operations-fix.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 12:34:33 -0800
Message-ID: <527bf959.O3q8JbzTp7tbUsg4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3KGUee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 15:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, gthelen@google.com

Subject: + percpu-add-test-module-for-various-percpu-operations-fix.patch added to -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 12:34:33 -0800


The patch titled
     Subject: percpu-add-test-module-for-various-percpu-operations-fix
has been added to the -mm tree.  Its filename is
     percpu-add-test-module-for-various-percpu-operations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-add-test-module-for-various-percpu-operations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-test-module-for-various-percpu-operations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: percpu-add-test-module-for-various-percpu-operations-fix

- use %lld/x which allows for less casting
- fix 32 bit build by casting large constants

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_test.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/percpu_test.c~percpu-add-test-module-for-various-percpu-operations-fix lib/percpu_test.c
--- a/lib/percpu_test.c~percpu-add-test-module-for-various-percpu-operations-fix
+++ a/lib/percpu_test.c
@@ -4,13 +4,13 @@
 #define CHECK(native, pcp, expected)                                    \
 	do {                                                            \
 		WARN((native) != (expected),                            \
-		     "raw %ld (0x%lx) != expected %ld (0x%lx)",         \
-		     (long)(native), (long)(native),                    \
-		     (long)(expected), (long)(expected));               \
+		     "raw %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     (native), (native),				\
+		     (long long)(expected), (long long)(expected));	\
 		WARN(__this_cpu_read(pcp) != (expected),                \
-		     "pcp %ld (0x%lx) != expected %ld (0x%lx)",         \
-		     (long)__this_cpu_read(pcp), (long)__this_cpu_read(pcp), \
-		     (long)(expected), (long)(expected));               \
+		     "pcp %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     __this_cpu_read(pcp), __this_cpu_read(pcp),	\
+		     (long long)(expected), (long long)(expected));	\
 	} while (0)
 
 static DEFINE_PER_CPU(long, long_counter);
@@ -20,7 +20,7 @@ static int __init percpu_test_init(void)
 {
 	/*
 	 * volatile prevents compiler from optimizing it uses, otherwise the
-	 * +ul_one and -ul_one below would replace with inc/dec instructions.
+	 * +ul_one/-ul_one below would replace with inc/dec instructions.
 	 */
 	volatile unsigned int ui_one = 1;
 	long l = 0;
@@ -58,8 +58,8 @@ static int __init percpu_test_init(void)
 
 	ul -= 1;
 	__this_cpu_dec(ulong_counter);
-	CHECK(ul, ulong_counter, 0xffffffffffffffff);
 	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, ULONG_MAX);
 
 	l += -ui_one;
 	__this_cpu_add(long_counter, -ui_one);
@@ -67,7 +67,7 @@ static int __init percpu_test_init(void)
 
 	l += ui_one;
 	__this_cpu_add(long_counter, ui_one);
-	CHECK(l, long_counter, 0x100000000);
+	CHECK(l, long_counter, (long)0x100000000LL);
 
 
 	l = 0;
@@ -86,7 +86,7 @@ static int __init percpu_test_init(void)
 
 	l += -ui_one;
 	__this_cpu_add(long_counter, -ui_one);
-	CHECK(l, long_counter, 0x100000000);
+	CHECK(l, long_counter, (long)0x100000000LL);
 
 	l = 0;
 	__this_cpu_write(long_counter, 0);
@@ -94,7 +94,7 @@ static int __init percpu_test_init(void)
 	l -= ui_one;
 	this_cpu_sub(long_counter, ui_one);
 	CHECK(l, long_counter, -1);
-	CHECK(l, long_counter, 0xffffffffffffffff);
+	CHECK(l, long_counter, ULONG_MAX);
 
 	ul = 0;
 	__this_cpu_write(ulong_counter, 0);
@@ -109,7 +109,7 @@ static int __init percpu_test_init(void)
 	ul -= ui_one;
 	__this_cpu_sub(ulong_counter, ui_one);
 	CHECK(ul, ulong_counter, -1);
-	CHECK(ul, ulong_counter, 0xffffffffffffffff);
+	CHECK(ul, ulong_counter, ULONG_MAX);
 
 	ul = 3;
 	__this_cpu_write(ulong_counter, 3);
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
percpu-add-test-module-for-various-percpu-operations.patch
percpu-add-test-module-for-various-percpu-operations-fix.patch

