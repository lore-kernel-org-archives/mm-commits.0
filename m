From: akpm@linux-foundation.org
Subject: + percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch added to -mm tree
Date: Fri, 29 Jan 2010 16:35:29 -0800
Message-ID: <201001300035.o0U0ZT3N019112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543Ab0A3AgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 19:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, peterz@infradead.org, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     percpu_counter: make __percpu_counter_add an inline function on UP
has been added to the -mm tree.  Its filename is
     percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch

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
Subject: percpu_counter: make __percpu_counter_add an inline function on UP
From: Anton Blanchard <anton@samba.org>

Even though batch isn't used on UP, we may want to pass one in to keep the
SMP and UP code paths similar. Convert __percpu_counter_add to an inline
function so we wont get variable unused warnings if we do.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counter-make-__percpu_counter_add-an-inline-function-on-up include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counter-make-__percpu_counter_add-an-inline-function-on-up
+++ a/include/linux/percpu_counter.h
@@ -98,9 +98,6 @@ static inline void percpu_counter_set(st
 	fbc->count = amount;
 }
 
-#define __percpu_counter_add(fbc, amount, batch) \
-	percpu_counter_add(fbc, amount)
-
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -109,6 +106,12 @@ percpu_counter_add(struct percpu_counter
 	preempt_enable();
 }
 
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	percpu_counter_add(fbc, amount);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
zlib-make-new-optimized-inflate-endian-independent.patch

