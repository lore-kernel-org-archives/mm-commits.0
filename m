Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6181115687D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977360; cv=none; b=RNB8hoHO/hc64v90+6j7G9/mNs6bhM1Q5PcFzDwv4SP279L/h83umy0MsRj6iMdHKtB1Ijjy/pt6lrLsURf6/2A+LdGipu85EoAYLpBNFfqMWP+2/XSFzv0Y/LZ/G74xfKRyrmyCuDF8sSMlWEngT5KDLLleHGWTw7KcL/vCogQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977360; c=relaxed/simple;
	bh=OZ2RcXEyO3cifFWqxYvnXD64xrl67ToPJOGCao30PoY=;
	h=Date:To:From:Subject:Message-Id; b=MaRuQD2TtMhqe4IVhEMa+xT56F4Ilq6LkVZqkPHrD2rVQdaGgWu3V/iiUgEVxg0Lk5wpfsrNLn7CXeC4mPPkjK40wIZ6QsbF+S0Q085hTcN6MHwo2f6DMl3MEMlFZL81go3cp513TVuBibaaBWwsTcJ7XU+rm2dUrc71DUpyubg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jN5YbPHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jN5YbPHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0752C4CEE3;
	Sun, 20 Jul 2025 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977360;
	bh=OZ2RcXEyO3cifFWqxYvnXD64xrl67ToPJOGCao30PoY=;
	h=Date:To:From:Subject:From;
	b=jN5YbPHwPh+NRlpw9OBx6KtJ1vIqepNbef2RSmMjkpLlXUaIn7ejOkAlTxkXU2DVQ
	 Tih4oDRCjgCWlKi0Facea6b/iI44Mvu0eN0geKAqWIktgc+37XM6r/3bhDVocqznm5
	 meVwVnw2k6/cG2LGsuAiSotTmkPXbL085UcMMseU=
Date: Sat, 19 Jul 2025 19:09:19 -0700
To: mm-commits@vger.kernel.org,zi.li@linux.dev,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] locking-rwsem-make-owner-helpers-globally-available.patch removed from -mm tree
Message-Id: <20250720020919.E0752C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: locking/rwsem: make owner helpers globally available
has been removed from the -mm tree.  Its filename was
     locking-rwsem-make-owner-helpers-globally-available.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: locking/rwsem: make owner helpers globally available
Date: Fri, 27 Jun 2025 15:29:22 +0800

Patch series "extend hung task blocker tracking to rwsems".

Inspired by mutex blocker tracking[1], and having already extended it to
semaphores, let's now add support for reader-writer semaphores (rwsems).

The approach is simple: when a task enters TASK_UNINTERRUPTIBLE while
waiting for an rwsem, we just call hung_task_set_blocker().  The hung task
detector can then query the rwsem's owner to identify the lock holder.

Tracking works reliably for writers, as there can only be a single writer
holding the lock, and its task struct is stored in the owner field.

The main challenge lies with readers.  The owner field points to only one
of many concurrent readers, so we might lose track of the blocker if that
specific reader unlocks, even while others remain.  This is not a
significant issue, however.  In practice, long-lasting lock contention is
almost always caused by a writer.  Therefore, reliably tracking the writer
is the primary goal of this patch series ;)

With this change, the hung task detector can now show blocker task's info
like below:

[Fri Jun 27 15:21:34 2025] INFO: task cat:28631 blocked for more than 122 seconds.
[Fri Jun 27 15:21:34 2025]       Tainted: G S                  6.16.0-rc3 #8
[Fri Jun 27 15:21:34 2025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Fri Jun 27 15:21:34 2025] task:cat             state:D stack:0     pid:28631 tgid:28631 ppid:28501  task_flags:0x400000 flags:0x00004000
[Fri Jun 27 15:21:34 2025] Call Trace:
[Fri Jun 27 15:21:34 2025]  <TASK>
[Fri Jun 27 15:21:34 2025]  __schedule+0x7c7/0x1930
[Fri Jun 27 15:21:34 2025]  ? __pfx___schedule+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? policy_nodemask+0x215/0x340
[Fri Jun 27 15:21:34 2025]  ? _raw_spin_lock_irq+0x8a/0xe0
[Fri Jun 27 15:21:34 2025]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[Fri Jun 27 15:21:34 2025]  schedule+0x6a/0x180
[Fri Jun 27 15:21:34 2025]  schedule_preempt_disabled+0x15/0x30
[Fri Jun 27 15:21:34 2025]  rwsem_down_read_slowpath+0x55e/0xe10
[Fri Jun 27 15:21:34 2025]  ? __pfx_rwsem_down_read_slowpath+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? __pfx___might_resched+0x10/0x10
[Fri Jun 27 15:21:34 2025]  down_read+0xc9/0x230
[Fri Jun 27 15:21:34 2025]  ? __pfx_down_read+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? __debugfs_file_get+0x14d/0x700
[Fri Jun 27 15:21:34 2025]  ? __pfx___debugfs_file_get+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? handle_pte_fault+0x52a/0x710
[Fri Jun 27 15:21:34 2025]  ? selinux_file_permission+0x3a9/0x590
[Fri Jun 27 15:21:34 2025]  read_dummy_rwsem_read+0x4a/0x90
[Fri Jun 27 15:21:34 2025]  full_proxy_read+0xff/0x1c0
[Fri Jun 27 15:21:34 2025]  ? rw_verify_area+0x6d/0x410
[Fri Jun 27 15:21:34 2025]  vfs_read+0x177/0xa50
[Fri Jun 27 15:21:34 2025]  ? __pfx_vfs_read+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? fdget_pos+0x1cf/0x4c0
[Fri Jun 27 15:21:34 2025]  ksys_read+0xfc/0x1d0
[Fri Jun 27 15:21:34 2025]  ? __pfx_ksys_read+0x10/0x10
[Fri Jun 27 15:21:34 2025]  do_syscall_64+0x66/0x2d0
[Fri Jun 27 15:21:34 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Fri Jun 27 15:21:34 2025] RIP: 0033:0x7f3f8faefb40
[Fri Jun 27 15:21:34 2025] RSP: 002b:00007ffdeda5ab98 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[Fri Jun 27 15:21:34 2025] RAX: ffffffffffffffda RBX: 0000000000010000 RCX: 00007f3f8faefb40
[Fri Jun 27 15:21:34 2025] RDX: 0000000000010000 RSI: 00000000010fa000 RDI: 0000000000000003
[Fri Jun 27 15:21:34 2025] RBP: 00000000010fa000 R08: 0000000000000000 R09: 0000000000010fff
[Fri Jun 27 15:21:34 2025] R10: 00007ffdeda59fe0 R11: 0000000000000246 R12: 00000000010fa000
[Fri Jun 27 15:21:34 2025] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000fff
[Fri Jun 27 15:21:34 2025]  </TASK>
[Fri Jun 27 15:21:34 2025] INFO: task cat:28631 <reader> blocked on an rw-semaphore likely owned by task cat:28630 <writer>
[Fri Jun 27 15:21:34 2025] task:cat             state:S stack:0     pid:28630 tgid:28630 ppid:28501  task_flags:0x400000 flags:0x00004000
[Fri Jun 27 15:21:34 2025] Call Trace:
[Fri Jun 27 15:21:34 2025]  <TASK>
[Fri Jun 27 15:21:34 2025]  __schedule+0x7c7/0x1930
[Fri Jun 27 15:21:34 2025]  ? __pfx___schedule+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? __mod_timer+0x304/0xa80
[Fri Jun 27 15:21:34 2025]  schedule+0x6a/0x180
[Fri Jun 27 15:21:34 2025]  schedule_timeout+0xfb/0x230
[Fri Jun 27 15:21:34 2025]  ? __pfx_schedule_timeout+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? __pfx_process_timeout+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? down_write+0xc4/0x140
[Fri Jun 27 15:21:34 2025]  msleep_interruptible+0xbe/0x150
[Fri Jun 27 15:21:34 2025]  read_dummy_rwsem_write+0x54/0x90
[Fri Jun 27 15:21:34 2025]  full_proxy_read+0xff/0x1c0
[Fri Jun 27 15:21:34 2025]  ? rw_verify_area+0x6d/0x410
[Fri Jun 27 15:21:34 2025]  vfs_read+0x177/0xa50
[Fri Jun 27 15:21:34 2025]  ? __pfx_vfs_read+0x10/0x10
[Fri Jun 27 15:21:34 2025]  ? fdget_pos+0x1cf/0x4c0
[Fri Jun 27 15:21:34 2025]  ksys_read+0xfc/0x1d0
[Fri Jun 27 15:21:34 2025]  ? __pfx_ksys_read+0x10/0x10
[Fri Jun 27 15:21:34 2025]  do_syscall_64+0x66/0x2d0
[Fri Jun 27 15:21:34 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Fri Jun 27 15:21:34 2025] RIP: 0033:0x7f8f288efb40
[Fri Jun 27 15:21:34 2025] RSP: 002b:00007ffffb631038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[Fri Jun 27 15:21:34 2025] RAX: ffffffffffffffda RBX: 0000000000010000 RCX: 00007f8f288efb40
[Fri Jun 27 15:21:34 2025] RDX: 0000000000010000 RSI: 000000002a4b5000 RDI: 0000000000000003
[Fri Jun 27 15:21:34 2025] RBP: 000000002a4b5000 R08: 0000000000000000 R09: 0000000000010fff
[Fri Jun 27 15:21:34 2025] R10: 00007ffffb630460 R11: 0000000000000246 R12: 000000002a4b5000
[Fri Jun 27 15:21:34 2025] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000fff
[Fri Jun 27 15:21:34 2025]  </TASK>


This patch (of 3):

In preparation for extending blocker tracking to support rwsems, make the
rwsem_owner() and is_rwsem_reader_owned() helpers globally available for
determining if the blocker is a writer or one of the readers.

Additionally, a stale owner pointer in a reader-owned rwsem can lead to
false positives in blocker tracking when CONFIG_DETECT_HUNG_TASK_BLOCKER
is enabled.  To mitigate this, clear the owner field on the reader unlock
path, similar to what CONFIG_DEBUG_RWSEMS does.  A NULL owner is better
than a stale one for diagnostics.

Link: https://lkml.kernel.org/r/20250627072924.36567-1-lance.yang@linux.dev
Link: https://lkml.kernel.org/r/20250627072924.36567-2-lance.yang@linux.dev
Link: https://lore.kernel.org/all/174046694331.2194069.15472952050240807469.stgit@mhiramat.tok.corp.google.com/ [1]
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: Zi Li <zi.li@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwsem.h  |   12 ++++++++++++
 kernel/locking/rwsem.c |   14 +++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/include/linux/rwsem.h~locking-rwsem-make-owner-helpers-globally-available
+++ a/include/linux/rwsem.h
@@ -132,6 +132,18 @@ static inline int rwsem_is_contended(str
 	return !list_empty(&sem->wait_list);
 }
 
+#if defined(CONFIG_DEBUG_RWSEMS) || defined(CONFIG_DETECT_HUNG_TASK_BLOCKER)
+/*
+ * Return just the real task structure pointer of the owner
+ */
+extern struct task_struct *rwsem_owner(struct rw_semaphore *sem);
+
+/*
+ * Return true if the rwsem is owned by a reader.
+ */
+extern bool is_rwsem_reader_owned(struct rw_semaphore *sem);
+#endif
+
 #else /* !CONFIG_PREEMPT_RT */
 
 #include <linux/rwbase_rt.h>
--- a/kernel/locking/rwsem.c~locking-rwsem-make-owner-helpers-globally-available
+++ a/kernel/locking/rwsem.c
@@ -181,11 +181,11 @@ static inline void rwsem_set_reader_owne
 	__rwsem_set_reader_owned(sem, current);
 }
 
-#ifdef CONFIG_DEBUG_RWSEMS
+#if defined(CONFIG_DEBUG_RWSEMS) || defined(CONFIG_DETECT_HUNG_TASK_BLOCKER)
 /*
  * Return just the real task structure pointer of the owner
  */
-static inline struct task_struct *rwsem_owner(struct rw_semaphore *sem)
+struct task_struct *rwsem_owner(struct rw_semaphore *sem)
 {
 	return (struct task_struct *)
 		(atomic_long_read(&sem->owner) & ~RWSEM_OWNER_FLAGS_MASK);
@@ -194,7 +194,7 @@ static inline struct task_struct *rwsem_
 /*
  * Return true if the rwsem is owned by a reader.
  */
-static inline bool is_rwsem_reader_owned(struct rw_semaphore *sem)
+bool is_rwsem_reader_owned(struct rw_semaphore *sem)
 {
 	/*
 	 * Check the count to see if it is write-locked.
@@ -207,10 +207,10 @@ static inline bool is_rwsem_reader_owned
 }
 
 /*
- * With CONFIG_DEBUG_RWSEMS configured, it will make sure that if there
- * is a task pointer in owner of a reader-owned rwsem, it will be the
- * real owner or one of the real owners. The only exception is when the
- * unlock is done by up_read_non_owner().
+ * With CONFIG_DEBUG_RWSEMS or CONFIG_DETECT_HUNG_TASK_BLOCKER configured,
+ * it will make sure that the owner field of a reader-owned rwsem either
+ * points to a real reader-owner(s) or gets cleared. The only exception is
+ * when the unlock is done by up_read_non_owner().
  */
 static inline void rwsem_clear_reader_owned(struct rw_semaphore *sem)
 {
_

Patches currently in -mm which might be from lance.yang@linux.dev are


