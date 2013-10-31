From: akpm@linux-foundation.org
Subject: [merged]
 percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds.patch removed from -mm tree
Date: Thu, 31 Oct 2013 11:00:05 -0700
Message-ID: <52729aa5.Ejwq+yFvZ6CqLVsn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3JaSAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 14:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, gthelen@google.com

Subject: [merged] percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds.patch removed from -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 11:00:05 -0700


The patch titled
     Subject: percpu: fix this_cpu_sub() subtrahend casting for unsigneds
has been removed from the -mm tree.  Its filename was
     percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: percpu: fix this_cpu_sub() subtrahend casting for unsigneds

this_cpu_sub() is implemented as negation and addition.

This patch casts the adjustment to the counter type before negation to
sign extend the adjustment.  This helps in cases where the counter
type is wider than an unsigned adjustment.  An alternative to this
patch is to declare such operations unsupported, but it seemed useful
to avoid surprises.

This patch specifically helps the following example:
  unsigned int delta = 1
  preempt_disable()
  this_cpu_write(long_counter, 0)
  this_cpu_sub(long_counter, delta)
  preempt_enable()

Before this change long_counter on a 64 bit machine ends with value
0xffffffff, rather than 0xffffffffffffffff.  This is because
this_cpu_sub(pcp, delta) boils down to this_cpu_add(pcp, -delta),
which is basically:
  long_counter = 0 + 0xffffffff

Also apply the same cast to:
  __this_cpu_sub()
  __this_cpu_sub_return()
  this_cpu_sub_return()

All percpu_test.ko passes, especially the following cases which
previously failed:

  l -= ui_one;
  __this_cpu_sub(long_counter, ui_one);
  CHECK(l, long_counter, -1);

  l -= ui_one;
  this_cpu_sub(long_counter, ui_one);
  CHECK(l, long_counter, -1);
  CHECK(l, long_counter, 0xffffffffffffffff);

  ul -= ui_one;
  __this_cpu_sub(ulong_counter, ui_one);
  CHECK(ul, ulong_counter, -1);
  CHECK(ul, ulong_counter, 0xffffffffffffffff);

  ul = this_cpu_sub_return(ulong_counter, ui_one);
  CHECK(ul, ulong_counter, 2);

  ul = __this_cpu_sub_return(ulong_counter, ui_one);
  CHECK(ul, ulong_counter, 1);

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/percpu.h |    3 ++-
 include/linux/percpu.h        |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/percpu.h~percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h~percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds
+++ a/arch/x86/include/asm/percpu.h
@@ -128,7 +128,8 @@ do {							\
 do {									\
 	typedef typeof(var) pao_T__;					\
 	const int pao_ID__ = (__builtin_constant_p(val) &&		\
-			      ((val) == 1 || (val) == -1)) ? (val) : 0;	\
+			      ((val) == 1 || (val) == -1)) ?		\
+				(int)(val) : 0;				\
 	if (0) {							\
 		pao_T__ pao_tmp__;					\
 		pao_tmp__ = (val);					\
diff -puN include/linux/percpu.h~percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds
+++ a/include/linux/percpu.h
@@ -332,7 +332,7 @@ do {									\
 #endif
 
 #ifndef this_cpu_sub
-# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(val))
+# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
 #endif
 
 #ifndef this_cpu_inc
@@ -418,7 +418,7 @@ do {									\
 # define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
 #endif
 
-#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
@@ -586,7 +586,7 @@ do {									\
 #endif
 
 #ifndef __this_cpu_sub
-# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(val))
+# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
 #endif
 
 #ifndef __this_cpu_inc
@@ -668,7 +668,7 @@ do {									\
 	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
 #endif
 
-#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
+#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
 #define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
 
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
percpu-add-test-module-for-various-percpu-operations.patch

