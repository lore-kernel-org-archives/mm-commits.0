Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC941ABEDE;
	Wed,  7 Oct 2026 02:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338647; cv=none; b=toPHMUavQO6tvQQ+h6WLCQnRIwrZBHIvm1NFLOd5CekV+3g1ifZM92tRwnRdLEPnk7ENuHh45myeuwpN7QVmyW7kfvj0lJZNVUc1/4t2uhBWcUamJxIVHuppV2vOoKHvQwxZkzs0IKxHtmx/jzP7w9qoXrMBh+c2Y5q3NX+DuXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338647; c=relaxed/simple;
	bh=6YZ9pS97jaliZjYJ14cFEh77mMWXRvXF6h6lJaqJjDY=;
	h=Date:To:From:Subject:Message-Id; b=nsH4EkY66U6/kN3P25mNOkosoZJNrvoMB7Ec4t52Rdicwvr2Ko/jp27oqqzmYmezFqsKMP4U7FTB0OMdby1ZF5t/k2qbseAV4lPw4ZuOIdhPOywfAoTxrS/7HT+4+h18utKDSBD5Liuj5vMAeolbcjeqsOw2aLRlUeoZLSO9Oeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sUYDG62M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sUYDG62M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B691F0089C;
	Wed,  7 Oct 2026 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338645;
	bh=CbVKQO0iP3YB6cdF8JAo2mumrIdfz4HZiSSO1fT4jYY=;
	h=Date:To:From:Subject;
	b=sUYDG62M10XfnoFfpyT2Pmqzs4dzvtHJEO6rb7++B2A1fhzcEpEn6NfoNZr7cHVPy
	 SVVmThcZ3K4vjItN/Y5XPhUXatJ02+huHTUgVNTzgImnFMej0rT/p4jnnU489Klv0c
	 TZYeImrK7VDE/9LgPAIRQblaQlFUuXqriHFhgkKo=
Date: Tue, 06 Oct 2026 19:04:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] klist-avoid-accesses-after-waking-klist_remove.patch removed from -mm tree
Message-Id: <20261007020405.90B691F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: klist: avoid accesses after waking klist_remove()
has been removed from the -mm tree.  Its filename was
     klist-avoid-accesses-after-waking-klist_remove.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: klist: avoid accesses after waking klist_remove()
Date: Thu, 27 Aug 2026 06:17:08 +0200

klist_remove() waits until a node is unreferenced so that its caller can
free the containing object.  klist_release() currently publishes
waiter->woken and wakes the waiter before its final accesses to the waiter
and node.  klist_remove() can then return, allowing its stack waiter and
the containing object to be freed or reused while klist_release() is still
running.  In particular, bus_remove_driver() can free drv->p while
__device_attach() walks the same bus klist with bus_for_each_drv().

On an arm64 Cortex-A72 system, an unpatched 7.2.0-rc3 kernel with
CONFIG_PREEMPT_RT=y and CONFIG_KASAN=y reproduced the bug through the
in-tree I2C/at24 path.  KASAN reported a use-after-free in
klist_dec_and_del() reached from klist_next()/bus_for_each_drv() while
at24 was being unregistered.

Clear n_klist and take a task reference before publishing woken.  Use
release/acquire accesses for that publication and wake the referenced
task.  The task reference keeps the waiter task alive if it returns and
exits before wake_up_process().

Link: https://lore.kernel.org/20260827041708.31682-1-kmehltretter@gmail.com
Fixes: 8b0c250be489 ("[PATCH] add klist_node_attached() to determine if a node is on a list or not.")
Fixes: 210272a28465 ("driver core: Remove completion from struct klist_node")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
---

 lib/klist.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/lib/klist.c~klist-avoid-accesses-after-waking-klist_remove
+++ a/lib/klist.c
@@ -36,6 +36,7 @@
 #include <linux/klist.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/task.h>
 
 /*
  * Use the lowest bit of n_klist to mark deleted nodes and exclude
@@ -187,18 +188,24 @@ static void klist_release(struct kref *k
 
 	WARN_ON(!knode_dead(n));
 	list_del(&n->n_node);
+	knode_set_klist(n, NULL);
 	spin_lock(&klist_remove_lock);
 	list_for_each_entry_safe(waiter, tmp, &klist_remove_waiters, list) {
+		struct task_struct *p;
+
 		if (waiter->node != n)
 			continue;
 
+		p = waiter->process;
+		get_task_struct(p);
 		list_del(&waiter->list);
-		waiter->woken = 1;
+		/* Publish only after the final waiter and n accesses */
+		smp_store_release(&waiter->woken, 1);
 		mb();
-		wake_up_process(waiter->process);
+		wake_up_process(p);
+		put_task_struct(p);
 	}
 	spin_unlock(&klist_remove_lock);
-	knode_set_klist(n, NULL);
 }
 
 static int klist_dec_and_del(struct klist_node *n)
@@ -250,7 +257,8 @@ void klist_remove(struct klist_node *n)
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (waiter.woken)
+		/* Pairs with the release store in klist_release() */
+		if (smp_load_acquire(&waiter.woken))
 			break;
 		schedule();
 	}
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch
kcov-report-spurious-pcs-in-the-interrupt-selftest.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

