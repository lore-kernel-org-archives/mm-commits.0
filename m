From: akpm@linux-foundation.org
Subject: - kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:40 -0800
Message-ID: <200802250045.m1P0je0A006276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbYBYAsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivasa@in.ibm.com, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: refuse kprobe insertion on add/sub_preempt_counter()
has been removed from the -mm tree.  Its filename was
     kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: refuse kprobe insertion on add/sub_preempt_counter()
From: Srinivasa Ds <srinivasa@in.ibm.com>

Kprobes makes use of preempt_disable(),preempt_enable_noresched() and these
functions inturn call add/sub_preempt_count().  So we need to refuse user from
inserting probe in to these functions.

This patch disallows user from probing add/sub_preempt_count().

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter kernel/sched.c
--- a/kernel/sched.c~kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter
+++ a/kernel/sched.c
@@ -3766,7 +3766,7 @@ void scheduler_tick(void)
 
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
-void add_preempt_count(int val)
+void __kprobes add_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3782,7 +3782,7 @@ void add_preempt_count(int val)
 }
 EXPORT_SYMBOL(add_preempt_count);
 
-void sub_preempt_count(int val)
+void __kprobes sub_preempt_count(int val)
 {
 	/*
 	 * Underflow?
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are
