From: akpm@linux-foundation.org
Subject: + rcu_batches_completed-prototype-cleanup.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:06:53 -0800
Message-ID: <200802152206.m1FM6rhZ026303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759149AbYBOWIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, paulmck@us.ibm.com, srostedt@redhat.com


The patch titled
     rcu_batches_completed() prototype cleanup
has been added to the -mm tree.  Its filename is
     rcu_batches_completed-prototype-cleanup.patch

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
Subject: rcu_batches_completed() prototype cleanup
From: Steven Rostedt <rostedt@goodmis.org>

rcu_batches_completed and rcu_patches_completed_bh are both declared in
rcuclassic.h and rcupreempt.h.  This patch removes the extra prototypes for
them from rcupdate.h.

rcu_batches_completed_bh is defined as a static inline in the rcupreempt.h
header file.  Trying to export this as EXPORT_SYMBOL_GPL causes section
problems with the powerpc compiler.  There's no need to export a static
inlined function.

Modules must be compiled with the same type of RCU implementation as the
kernel they are for.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    2 --
 kernel/rcupreempt.c      |    2 --
 2 files changed, 4 deletions(-)

diff -puN include/linux/rcupdate.h~rcu_batches_completed-prototype-cleanup include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu_batches_completed-prototype-cleanup
+++ a/include/linux/rcupdate.h
@@ -261,8 +261,6 @@ extern void call_rcu_bh(struct rcu_head 
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
diff -puN kernel/rcupreempt.c~rcu_batches_completed-prototype-cleanup kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu_batches_completed-prototype-cleanup
+++ a/kernel/rcupreempt.c
@@ -217,8 +217,6 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
 void __rcu_read_lock(void)
 {
 	int idx;
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
git-sched.patch
git-x86.patch
rcu_batches_completed-prototype-cleanup.patch
