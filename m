Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219AE2D595B
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 20:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768596874; cv=none; b=g0XGk+bRfeuPHbxW/PZAdilBqfwFWQDGZBrZhYp3H/cqChep33R+NEMffxMkgUiMfZaqBmupEbERaxkMXHBuNmsiSI3fkiz6A9aAJaeJXcSi7I7c0B8rIG89DBFa1Yut7t9EOn1xugI0wXxaWZO7P8ccYwni1AURa2phcz5KAd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768596874; c=relaxed/simple;
	bh=dCbU6aGf99jHIWhyA1k8MUmdPhRFsmhju+jc31Fbuzw=;
	h=Date:To:From:Subject:Message-Id; b=Z+7gpA+kXdSZsIQwY0ziTZWBaOYQ5U71xBYA/HD4Rg7fuyF7a8NKlEr9Pv8OAAt/3bPCm+1Uk3Su2SkTLQzRRVFFGxXPg5uPhMg+rd3Pm0O1NQ8bzDYge4lesH28wLPuyK1PL5/fto8ozAeZePc7oFcmXqYIZaRAx4SQyRGio/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V5iwfyQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V5iwfyQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D00FC116C6;
	Fri, 16 Jan 2026 20:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768596873;
	bh=dCbU6aGf99jHIWhyA1k8MUmdPhRFsmhju+jc31Fbuzw=;
	h=Date:To:From:Subject:From;
	b=V5iwfyQhXmNVbrG20OpFJcLn0FLuINvUyXiEtf4KL/8kvL2Qlr4s82AG7raL5Xglf
	 ddSZeWBszHqFII8sZ8WMJzaIh/zmaudIXpHZnhibb3YOtiOgoH2zq9W90+eu12N5Nr
	 O+U5XVaYPPMfzhEtgEnZiMVPtI979QZUeXuV2DOs=
Date: Fri, 16 Jan 2026 12:54:32 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,clm@meta.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch added to mm-hotfixes-unstable branch
Message-Id: <20260116205433.8D00FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: fix potential deadlock in reboot notifier
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Breno Leitao <leitao@debian.org>
Subject: mm/kfence: fix potential deadlock in reboot notifier
Date: Fri, 16 Jan 2026 06:10:11 -0800

The reboot notifier callback can deadlock when calling
cancel_delayed_work_sync() if toggle_allocation_gate() is blocked in
wait_event_idle() waiting for allocations, that might not happen on
shutdown path.

The issue is that cancel_delayed_work_sync() waits for the work to
complete, but the work is waiting for kfence_allocation_gate > 0 which
requires allocations to happen (each allocation is increated by 1) -
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
Cc: Alexander Potapenko <glider@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
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

mm-kfence-fix-potential-deadlock-in-reboot-notifier.patch

