From: akpm@linux-foundation.org
Subject: [patch 34/84] signal: make oom_flags a bool
Date: Mon, 23 May 2016 16:23:57 -0700
Message-ID: <5743910d.0ZkIf4hdv753TgOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcEWXX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, hughd@google.com

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: signal: make oom_flags a bool

Currently the size of "struct signal_struct"->oom_flags member is
sizeof(unsigned) bytes, but only one flag OOM_FLAG_ORIGIN which is
updated by current thread is defined. We can convert OOM_FLAG_ORIGIN
into a bool, and reuse the saved bytes for updating from the OOM killer
and/or the OOM reaper thread.

By the way, do we care about a race window between run_store() and
swapoff() because it would be theoretically possible that two threads
sharing the "struct signal_struct" concurrently call respective
functions? If we care, we can make oom_flags an atomic_t.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h   |    9 +++------
 include/linux/sched.h |    6 +++++-
 include/linux/types.h |    1 -
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/oom.h~signal-make-oom_flags-a-bool include/linux/oom.h
--- a/include/linux/oom.h~signal-make-oom_flags-a-bool
+++ a/include/linux/oom.h
@@ -50,24 +50,21 @@ enum oom_scan_t {
 	OOM_SCAN_SELECT,	/* always select this thread first */
 };
 
-/* Thread is the potential origin of an oom condition; kill first on oom */
-#define OOM_FLAG_ORIGIN		((__force oom_flags_t)0x1)
-
 extern struct mutex oom_lock;
 
 static inline void set_current_oom_origin(void)
 {
-	current->signal->oom_flags |= OOM_FLAG_ORIGIN;
+	current->signal->oom_flag_origin = true;
 }
 
 static inline void clear_current_oom_origin(void)
 {
-	current->signal->oom_flags &= ~OOM_FLAG_ORIGIN;
+	current->signal->oom_flag_origin = false;
 }
 
 static inline bool oom_task_origin(const struct task_struct *p)
 {
-	return !!(p->signal->oom_flags & OOM_FLAG_ORIGIN);
+	return p->signal->oom_flag_origin;
 }
 
 extern void mark_oom_victim(struct task_struct *tsk);
diff -puN include/linux/sched.h~signal-make-oom_flags-a-bool include/linux/sched.h
--- a/include/linux/sched.h~signal-make-oom_flags-a-bool
+++ a/include/linux/sched.h
@@ -794,7 +794,11 @@ struct signal_struct {
 	struct tty_audit_buf *tty_audit_buf;
 #endif
 
-	oom_flags_t oom_flags;
+	/*
+	 * Thread is the potential origin of an oom condition; kill first on
+	 * oom
+	 */
+	bool oom_flag_origin;
 	short oom_score_adj;		/* OOM kill score adjustment */
 	short oom_score_adj_min;	/* OOM kill score adjustment min value.
 					 * Only settable by CAP_SYS_RESOURCE. */
diff -puN include/linux/types.h~signal-make-oom_flags-a-bool include/linux/types.h
--- a/include/linux/types.h~signal-make-oom_flags-a-bool
+++ a/include/linux/types.h
@@ -156,7 +156,6 @@ typedef u32 dma_addr_t;
 
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
-typedef unsigned __bitwise__ oom_flags_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
_
