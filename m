From: akpm@linux-foundation.org
Subject: + preemptible-rcu-sparse-annotations.patch added to -mm tree
Date: Tue, 05 Feb 2008 01:42:36 -0800
Message-ID: <200802050942.m159gH6e014472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbYBEJmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 04:42:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net, dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com


The patch titled
     preemptible RCU: sparse annotations
has been added to the -mm tree.  Its filename is
     preemptible-rcu-sparse-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preemptible RCU: sparse annotations
From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rcupreempt.h~preemptible-rcu-sparse-annotations include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~preemptible-rcu-sparse-annotations
+++ a/include/linux/rcupreempt.h
@@ -46,8 +46,8 @@
 #define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
+extern void __rcu_read_lock(void)	__acquires(RCU);
+extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
preemptible-rcu-sparse-annotations.patch
