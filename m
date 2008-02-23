From: akpm@linux-foundation.org
Subject: + kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:03 -0800
Message-ID: <200802230732.m1N7Wq7A018103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYBWHyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivasa@in.ibm.com, ananth@in.ibm.com


The patch titled
     kprobes: refuse kprobe insertion on add/sub_preempt_counter()
has been added to the -mm tree.  Its filename is
     kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch

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
@@ -3875,7 +3875,7 @@ static inline unsigned long get_parent_i
 	return addr;
 }
 
-void add_preempt_count(int val)
+void __kprobes add_preempt_count(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -3897,7 +3897,7 @@ void add_preempt_count(int val)
 }
 EXPORT_SYMBOL(add_preempt_count);
 
-void sub_preempt_count(int val)
+void __kprobes sub_preempt_count(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

kprobes-refuse-kprobe-insertion-on-add-sub_preempt_counter.patch
