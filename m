Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4CEC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 22:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995C361546
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 22:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbhKOWQN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352652AbhKOWLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 17:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0FE161A09;
        Mon, 15 Nov 2021 22:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637014109;
        bh=Ne/q8oxEiNDVZvFUcIQ/6UjMfRyVQsayas4V/9oKJbc=;
        h=Date:From:To:Subject:From;
        b=q9q4c54A1kdhVcCPVnO0DF+MpYLUaPgT+h7VXEz8Umx9XGzp2Q/cr4glrMnpmLhr6
         hdlwtYCkjZBPo52XSi7a7TtyZsL99mklDY/Agpo68rUKn9HnV7z3B8j6aI0tyzRtSL
         nzXf5HZn2g6jMv4Zq+F7L0piTRYadVaqPCmLvWKE=
Date:   Mon, 15 Nov 2021 14:08:28 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  +
 delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch
 added to -mm tree
Message-ID: <20211115220828.ivP27dTTS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: support swapin delay accounting for swapping without blkio
has been added to the -mm tree.  Its filename is
     delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: delayacct: support swapin delay accounting for swapping without blkio

Currently delayacct accounts swapin delay only for swapping that cause
blkio.  If we use zram for swapping, tools/accounting/getdelays can't get
any SWAP delay.

It's useful to get zram swapin delay information, for example to adjust
compress algorithm or /proc/sys/vm/swappiness.

Reference to PSI, it accounts any kind of swapping by doing its work in
swap_readpage(), no matter whether swapping causes blkio.  Let delayacct
do the similar work.

Link: https://lkml.kernel.org/r/20211112083813.8559-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   44 ++++++++++++++++++------------------
 kernel/delayacct.c        |   34 +++++++++++++++------------
 mm/memory.c               |    4 ---
 mm/page_io.c              |    3 ++
 4 files changed, 44 insertions(+), 41 deletions(-)

--- a/include/linux/delayacct.h~delayacct-support-swapin-delay-accounting-for-swapping-without-blkio
+++ a/include/linux/delayacct.h
@@ -9,14 +9,6 @@
 
 #include <uapi/linux/taskstats.h>
 
-/*
- * Per-task flags relevant to delay accounting
- * maintained privately to avoid exhausting similar flags in sched.h:PF_*
- * Used to set current->delays->flags
- */
-#define DELAYACCT_PF_SWAPIN	0x00000001	/* I am doing a swapin */
-#define DELAYACCT_PF_BLKIO	0x00000002	/* I am waiting on IO */
-
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
 	raw_spinlock_t	lock;
@@ -37,13 +29,13 @@ struct task_delay_info {
 	 * associated with the operation is added to XXX_delay.
 	 * XXX_delay contains the accumulated delay time in nanoseconds.
 	 */
-	u64 blkio_start;	/* Shared by blkio, swapin */
+	u64 blkio_start;
 	u64 blkio_delay;	/* wait for sync block io completion */
-	u64 swapin_delay;	/* wait for swapin block io completion */
+	u64 swapin_start;
+	u64 swapin_delay;	/* wait for swapin */
 	u32 blkio_count;	/* total count of the number of sync block */
 				/* io operations performed */
-	u32 swapin_count;	/* total count of the number of swapin block */
-				/* io operations performed */
+	u32 swapin_count;	/* total count of swapin */
 
 	u64 freepages_start;
 	u64 freepages_delay;	/* wait for memory reclaim */
@@ -79,14 +71,8 @@ extern void __delayacct_freepages_start(
 extern void __delayacct_freepages_end(void);
 extern void __delayacct_thrashing_start(void);
 extern void __delayacct_thrashing_end(void);
-
-static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
-{
-	if (p->delays)
-		return (p->delays->flags & DELAYACCT_PF_BLKIO);
-	else
-		return 0;
-}
+extern void __delayacct_swapin_start(void);
+extern void __delayacct_swapin_end(void);
 
 static inline void delayacct_set_flag(struct task_struct *p, int flag)
 {
@@ -123,7 +109,6 @@ static inline void delayacct_blkio_start
 	if (!static_branch_unlikely(&delayacct_key))
 		return;
 
-	delayacct_set_flag(current, DELAYACCT_PF_BLKIO);
 	if (current->delays)
 		__delayacct_blkio_start();
 }
@@ -135,7 +120,6 @@ static inline void delayacct_blkio_end(s
 
 	if (p->delays)
 		__delayacct_blkio_end(p);
-	delayacct_clear_flag(p, DELAYACCT_PF_BLKIO);
 }
 
 static inline __u64 delayacct_blkio_ticks(struct task_struct *tsk)
@@ -169,6 +153,18 @@ static inline void delayacct_thrashing_e
 		__delayacct_thrashing_end();
 }
 
+static inline void delayacct_swapin_start(void)
+{
+	if (current->delays)
+		__delayacct_swapin_start();
+}
+
+static inline void delayacct_swapin_end(void)
+{
+	if (current->delays)
+		__delayacct_swapin_end();
+}
+
 #else
 static inline void delayacct_set_flag(struct task_struct *p, int flag)
 {}
@@ -199,6 +195,10 @@ static inline void delayacct_thrashing_s
 {}
 static inline void delayacct_thrashing_end(void)
 {}
+static inline void delayacct_swapin_start(void)
+{}
+static inline void delayacct_swapin_end(void)
+{}
 
 #endif /* CONFIG_TASK_DELAY_ACCT */
 
--- a/kernel/delayacct.c~delayacct-support-swapin-delay-accounting-for-swapping-without-blkio
+++ a/kernel/delayacct.c
@@ -100,19 +100,10 @@ void __delayacct_blkio_start(void)
  */
 void __delayacct_blkio_end(struct task_struct *p)
 {
-	struct task_delay_info *delays = p->delays;
-	u64 *total;
-	u32 *count;
-
-	if (p->delays->flags & DELAYACCT_PF_SWAPIN) {
-		total = &delays->swapin_delay;
-		count = &delays->swapin_count;
-	} else {
-		total = &delays->blkio_delay;
-		count = &delays->blkio_count;
-	}
-
-	delayacct_end(&delays->lock, &delays->blkio_start, total, count);
+	delayacct_end(&p->delays->lock,
+		      &p->delays->blkio_start,
+		      &p->delays->blkio_delay,
+		      &p->delays->blkio_count);
 }
 
 int delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
@@ -179,8 +170,7 @@ __u64 __delayacct_blkio_ticks(struct tas
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tsk->delays->lock, flags);
-	ret = nsec_to_clock_t(tsk->delays->blkio_delay +
-				tsk->delays->swapin_delay);
+	ret = nsec_to_clock_t(tsk->delays->blkio_delay);
 	raw_spin_unlock_irqrestore(&tsk->delays->lock, flags);
 	return ret;
 }
@@ -210,3 +200,17 @@ void __delayacct_thrashing_end(void)
 		      &current->delays->thrashing_delay,
 		      &current->delays->thrashing_count);
 }
+
+void __delayacct_swapin_start(void)
+{
+	current->delays->swapin_start = local_clock();
+}
+
+void __delayacct_swapin_end(void)
+{
+	delayacct_end(&current->delays->lock,
+		      &current->delays->swapin_start,
+		      &current->delays->swapin_delay,
+		      &current->delays->swapin_count);
+}
+
--- a/mm/memory.c~delayacct-support-swapin-delay-accounting-for-swapping-without-blkio
+++ a/mm/memory.c
@@ -3507,7 +3507,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (unlikely(!si))
 		goto out;
 
-	delayacct_set_flag(current, DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
 
@@ -3555,7 +3554,6 @@ vm_fault_t do_swap_page(struct vm_fault
 					vmf->address, &vmf->ptl);
 			if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
 				ret = VM_FAULT_OOM;
-			delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 			goto unlock;
 		}
 
@@ -3569,13 +3567,11 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * owner processes (which may be unknown at hwpoison time)
 		 */
 		ret = VM_FAULT_HWPOISON;
-		delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 		goto out_release;
 	}
 
 	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
 
-	delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
 		goto out_release;
--- a/mm/page_io.c~delayacct-support-swapin-delay-accounting-for-swapping-without-blkio
+++ a/mm/page_io.c
@@ -25,6 +25,7 @@
 #include <linux/psi.h>
 #include <linux/uio.h>
 #include <linux/sched/task.h>
+#include <linux/delayacct.h>
 
 void end_swap_bio_write(struct bio *bio)
 {
@@ -370,6 +371,7 @@ int swap_readpage(struct page *page, boo
 	 * significant part of overall IO time.
 	 */
 	psi_memstall_enter(&pflags);
+	delayacct_swapin_start();
 
 	if (frontswap_load(page) == 0) {
 		SetPageUptodate(page);
@@ -432,6 +434,7 @@ int swap_readpage(struct page *page, boo
 
 out:
 	psi_memstall_leave(&pflags);
+	delayacct_swapin_end();
 	return ret;
 }
 
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch

