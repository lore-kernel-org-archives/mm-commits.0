From: akpm@osdl.org
Subject: + conditionally-check-expected_preempt_count-in-__resched_legal.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:18:32 -0800
Message-ID: <200612140018.kBE0IWCd025895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbWLNASq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.fasheh@oracle.com, mingo@elte.hu


The patch titled
     Conditionally check expected_preempt_count in __resched_legal()
has been added to the -mm tree.  Its filename is
     conditionally-check-expected_preempt_count-in-__resched_legal.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Conditionally check expected_preempt_count in __resched_legal()
From: Mark Fasheh <mark.fasheh@oracle.com>

Commit 2d7d253548cffdce80f4e03664686e9ccb1b0ed7 ("fix cond_resched() fix")
introduced an 'expected_preempt_count' parameter to __resched_legal() to
fix a bug where it was returning a false negative when called from
cond_resched_lock() and preemption was enabled.

Unfortunately this broke things for when preemption is disabled. 
preempt_count() will always return zero, thus failing the check against any
value of expected_preempt_count not equal to zero.  cond_resched_lock() for
example, passes an expected_preempt_count value of 1.

So fix the fix for the cond_resched() fix by skipping the check of
preempt_count() against expected_preempt_count when preemption is disabled.

Credit should go to Sunil Mushran for spotting the bug during testing.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/sched.c~conditionally-check-expected_preempt_count-in-__resched_legal kernel/sched.c
--- a/kernel/sched.c~conditionally-check-expected_preempt_count-in-__resched_legal
+++ a/kernel/sched.c
@@ -4627,8 +4627,10 @@ asmlinkage long sys_sched_yield(void)
 
 static inline int __resched_legal(int expected_preempt_count)
 {
+#ifdef CONFIG_PREEMPT
 	if (unlikely(preempt_count() != expected_preempt_count))
 		return 0;
+#endif
 	if (unlikely(system_state != SYSTEM_RUNNING))
 		return 0;
 	return 1;
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

origin.patch
touch_atime-cleanup.patch
relative-atime.patch
ocfs2-relative-atime-support.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
conditionally-check-expected_preempt_count-in-__resched_legal.patch
git-ocfs2.patch

