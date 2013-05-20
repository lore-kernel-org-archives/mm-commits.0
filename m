From: akpm@linux-foundation.org
Subject: + softirq-use-_ret_ip_.patch added to -mm tree
Date: Mon, 20 May 2013 16:51:12 -0700
Message-ID: <519ab6f0.E6iXIruM0gWWlp/w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3ETXvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, fweisbec@gmail.com, davidlohr.bueso@hp.com

Subject: + softirq-use-_ret_ip_.patch added to -mm tree
To: davidlohr.bueso@hp.com,fweisbec@gmail.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:51:12 -0700


The patch titled
     Subject: softirq: use _RET_IP_
has been added to the -mm tree.  Its filename is
     softirq-use-_ret_ip_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: softirq: use _RET_IP_

Use the already defined macro to pass the function return address.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/softirq.c~softirq-use-_ret_ip_ kernel/softirq.c
--- a/kernel/softirq.c~softirq-use-_ret_ip_
+++ a/kernel/softirq.c
@@ -127,8 +127,7 @@ static inline void __local_bh_disable(un
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_DISABLE_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
@@ -139,7 +138,7 @@ static void __local_bh_enable(unsigned i
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(_RET_IP_);
 	sub_preempt_count(cnt);
 }
 
@@ -184,7 +183,7 @@ static inline void _local_bh_enable_ip(u
 
 void local_bh_enable(void)
 {
-	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	_local_bh_enable_ip(_RET_IP_);
 }
 EXPORT_SYMBOL(local_bh_enable);
 
@@ -223,8 +222,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch

