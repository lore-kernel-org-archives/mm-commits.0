Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7296D29B8E1
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 20:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854668; cv=none; b=XW2IUERPKaWAyp2YsI58I1SMEDEv1vIbDJEDZDxmyMCtXg1ZV3gl+e+kItkEjP533KP2zueI/YEAxOIgbWufprcMAJS72Ax4vkQ8VTgpwSSVt+QXdb29gF43PLjYR/59tFOVpNArsoInCiCsxbFTtq5/jqGrKvJsPCsIzGmW3K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854668; c=relaxed/simple;
	bh=WaP6lq/ac3jMdOpZ6Kc9LqkmtvqQ+nT45gDT7I0wLc4=;
	h=Date:To:From:Subject:Message-Id; b=dMZcpVNIRruqA1qYzZGjUyj8YYnhZc7yu5AHQEs33Q9s9Eff4TAut6Y0Tj6hxFfTLBPk4BA5RwYh0KdQaz4xLZlH6fFSGKCLh0GWROf/jteRkM0ywktzMA8ZewfptuQ1OiIRAQpRpvRqaq8bJOA7J8NW7zUplrXPGfbx8hbzCWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vHhj9Wst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vHhj9Wst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150F6C19424;
	Mon, 19 Jan 2026 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854668;
	bh=WaP6lq/ac3jMdOpZ6Kc9LqkmtvqQ+nT45gDT7I0wLc4=;
	h=Date:To:From:Subject:From;
	b=vHhj9Wst5UFQ/caU7DaHo6M26wYAuMO+ZrZeGIvTMM2KXe3SYdBuneba/0sov6a42
	 +w2MrqfP26oVwozhtn8wYL55oLJJJ8uf/LRFLjt/RU8hkkFI+nfDaimh2+HxSgBJL4
	 Q/eWHP1XOljC9fz6e82VzM9izUr73O9VzPpctfyE=
Date: Mon, 19 Jan 2026 12:31:07 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,clm@meta.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch removed from -mm tree
Message-Id: <20260119203108.150F6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: fix potential deadlock in reboot notifier
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kfence: fix potential deadlock in reboot notifier
Date: Fri, 16 Jan 2026 06:10:11 -0800

The reboot notifier callback can deadlock when calling
cancel_delayed_work_sync() if toggle_allocation_gate() is blocked in
wait_event_idle() waiting for allocations, that might not happen on
shutdown path.

The issue is that cancel_delayed_work_sync() waits for the work to
complete, but the work is waiting for kfence_allocation_gate > 0 which
requires allocations to happen (each allocation is increased by 1) -
allocations that may have stopped during shutdown.

Fix this by:
1. Using cancel_delayed_work() (non-sync) to avoid blocking. Now the
   callback succeeds and return.
2. Adding wake_up() to unblock any waiting toggle_allocation_gate()
3. Adding !kfence_enabled to the wait condition so the wake succeeds

The static_branch_disable() IPI will still execute after the wake, but at
this early point in shutdown (reboot notifier runs with INT_MAX priority),
the system is still functional and CPUs can respond to IPIs.

Link: https://lkml.kernel.org/r/20260116-kfence_fix-v1-1-4165a055933f@debian.org
Fixes: ce2bba89566b ("mm/kfence: add reboot notifier to disable KFENCE on shutdown")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113140234.677117-1-clm@meta.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-fix-potential-deadlock-in-reboot-notifier
+++ a/mm/kfence/core.c
@@ -823,6 +823,9 @@ static struct notifier_block kfence_chec
 static struct delayed_work kfence_timer;
 
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+/* Wait queue to wake up allocation-gate timer task. */
+static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
+
 static int kfence_reboot_callback(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
@@ -832,7 +835,12 @@ static int kfence_reboot_callback(struct
 	 */
 	WRITE_ONCE(kfence_enabled, false);
 	/* Cancel any pending timer work */
-	cancel_delayed_work_sync(&kfence_timer);
+	cancel_delayed_work(&kfence_timer);
+	/*
+	 * Wake up any blocked toggle_allocation_gate() so it can complete
+	 * early while the system is still able to handle IPIs.
+	 */
+	wake_up(&allocation_wait);
 
 	return NOTIFY_OK;
 }
@@ -842,9 +850,6 @@ static struct notifier_block kfence_rebo
 	.priority = INT_MAX, /* Run early to stop timers ASAP */
 };
 
-/* Wait queue to wake up allocation-gate timer task. */
-static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
-
 static void wake_up_kfence_timer(struct irq_work *work)
 {
 	wake_up(&allocation_wait);
@@ -873,7 +878,9 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate) > 0);
+	wait_event_idle(allocation_wait,
+			atomic_read(&kfence_allocation_gate) > 0 ||
+			!READ_ONCE(kfence_enabled));
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
_

Patches currently in -mm which might be from leitao@debian.org are


