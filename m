Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E038E8A1
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298407; cv=none; b=HsPTfFrcsLOyUxI61bPFZAHZMwY7h5eANnp5ZNleFFuSBZ7iE/JTIi9o65Z/JpOSDQpDkvqd4n3YoPMEYKYgIvxnuqyQ1mp6VkSft5pOWforgnngpS/ilgA2W7080w2MRAH+GNwt6al3vWU+yxqRxn2Yg1OBBCSM8kL4gW4+O0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298407; c=relaxed/simple;
	bh=ldIsOoEUc9S8hJ3FY4ii0b7iREssPkxQWwDOiB8+M5E=;
	h=Date:To:From:Subject:Message-Id; b=TOWUhCeh1DciKcP7snZm+/FDV62eOZEjjXoIL8MDxouk7nB5SeMRVFcS4Hsr0q3zIGHkVXpA9N0QHAuffc9DeZBUOJj/KgHDPbNTqFGIVMb5cn4Itjnm5M4edtQzWWyn19kF+SE8bomIdU915PNspLhvNISuQr9WEBubn6ffUs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2RwgkFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2RwgkFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804BB1F000E9;
	Wed, 29 Jul 2026 04:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298405;
	bh=kpnSkGhIqPJy8JvuG0QGVSSQzqd90PR01IxjiBSsvd0=;
	h=Date:To:From:Subject;
	b=x2RwgkFaJ6llHu9hZcnCqGkuPK18k/0Jau9ZYhsPoEBnFkVPCTVnG/MD6RqnPLWYS
	 h6oFxfSzMKqcAAMVsqrUtGXxe0OfPFWCQfMqzTvlcIC+UixIU6VquCHXLWNhcysMeU
	 Q1tyWQ7IdjEuJfuVBBoFm5O40RZX6hdkFpMJJ8Yo=
Date: Tue, 28 Jul 2026 21:13:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,oleg@redhat.com,lance.yang@linux.dev,dave@stgolabs.net,catalin.marinas@arm.com,cai@lca.pw,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch removed from -mm tree
Message-Id: <20260729041325.804BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: stop the task stack scan early when interrupted
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: stop the task stack scan early when interrupted
Date: Mon, 15 Jun 2026 10:49:07 -0700

scan_block() already checks scan_should_stop() for every pointer and bails
out of the current block, but the task stack walk cannot tell and keeps
issuing a separate scan_should_stop() between every task.

Return that status from scan_block() and use it as the task stack loop
condition, so the walk stops as soon as a scan is interrupted.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-2-acecd7d7fd92@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted
+++ a/mm/kmemleak.c
@@ -1525,22 +1525,25 @@ static int scan_should_stop(void)
 
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
- * found to the gray list.
+ * found to the gray list. Return non-zero if the scan was interrupted.
  */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned)
+static int scan_block(void *_start, void *_end,
+		      struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 	unsigned long flags;
+	int stop = 0;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		unsigned long pointer;
 
-		if (scan_should_stop())
+		if (scan_should_stop()) {
+			stop = 1;
 			break;
+		}
 
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
@@ -1550,6 +1553,8 @@ static void scan_block(void *_start, voi
 		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return stop;
 }
 
 /*
@@ -1705,6 +1710,7 @@ static void kmemleak_scan_task_stacks(vo
 {
 	struct pid *pid;
 	int nr = 1;
+	int stop = 0;
 
 	do {
 		struct task_struct *p = NULL;
@@ -1723,13 +1729,13 @@ static void kmemleak_scan_task_stacks(vo
 			void *stack = try_get_task_stack(p);
 
 			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
+				stop = scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
 			put_task_struct(p);
 		}
 		cond_resched();
-	} while (pid && !scan_should_stop());
+	} while (pid && !stop);
 }
 
 /*
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch

