Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C246B361947;
	Thu, 27 Aug 2026 22:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871171; cv=none; b=KOAxiDOlgFwXC77Mim6FGTfJiNX2E7sAcwqcDmMH4q8QPe8hiZs+dQsbUeu6zJix8NDmy//aHKqYKEKRoM7bM3+185uiOYn7P1sycGVx3ipRzphbbmjR5C9zflneH3MGCnfO4Jf0GwFbeq/KMaFvV1S0el6A5A8iYUMql4XT/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871171; c=relaxed/simple;
	bh=9rvW2Vk3rr6D9YxKynockFJ/nOOIWUooi3KLEiwWJzY=;
	h=Date:To:From:Subject:Message-Id; b=LaeaxiJtqqkOm6VgLKffnHVDlmTrnl27JziEf2lpJeVqvrQ4FPq8M8kUfA9wv/MTrishY9x9emrbB6oWforG4SOFSDFNi86+X+4I0VW6mH9LoS9dbUaJFSxr9PeCiN6zUn3Rt90xPZ01/XCYPTzJgKFNAZl63bsteLhuwmYIf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ZJU4CPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ZJU4CPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569CD1F000E9;
	Thu, 27 Aug 2026 22:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787871169;
	bh=/oYtrQxXePhTzWJq7M2xIv8gmbvh5aKqHf0MtpGmirA=;
	h=Date:To:From:Subject;
	b=2ZJU4CPUNXRCUkxj3+VWyx7Yn86UqzD/X8/DBMv1upXj7V5WXGNLQMW6+aVIWvw5l
	 mpWd2Og8fKqXDWCEo9WyJyQ5DBKQufiMpOw+Wv4qnlsucAJt57NvzT+33g62g9dG5P
	 tqo6F9MOOaPyb3sO6py4hZXTMp77yTFA1VkgjHyE=
Date: Thu, 27 Aug 2026 15:52:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + klist-avoid-accesses-after-waking-klist_remove.patch added to mm-nonmm-unstable branch
Message-Id: <20260827225249.569CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: klist: avoid accesses after waking klist_remove()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     klist-avoid-accesses-after-waking-klist_remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/klist-avoid-accesses-after-waking-klist_remove.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

klist-avoid-accesses-after-waking-klist_remove.patch

