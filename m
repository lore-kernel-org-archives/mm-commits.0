Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B221821CC51
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764180943; cv=none; b=dpHQ7tp/AnCeh9FxxTE/FLryYQpxdztoIn1urWNgPTiVFalOWy4MUlB+5cOxRNkdfenteDQClXMbWfmlpfQjZhIquU8WDarcQ+w1TrV5TQpWRs8TBgmeAUUYsrDRhKLwSzwD7KzFemwQ3Z26GmbbkcMpOD3cf4tIYPcqLkvc4rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764180943; c=relaxed/simple;
	bh=5NlB3qXmK0FiJLrja9HIY9RXNT1zAJvxj1NnRzHldeM=;
	h=Date:To:From:Subject:Message-Id; b=Y8uzOJo5lJJmZhElIKPM+wni/BVKQQ5vGH4/MiP9RHZ3SEwboOToPUzKOOYDa/1NI49UOX0V/FIKdhwEq8Dfyyafvaj95itCnYOjTv97xr2m05eUOc1CA1klwqJhiI4PXEf1+zDBoEFkz22gS7l+gPoFMpHCTm/IbIuWSw38p2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PMQDpBcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PMQDpBcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED65C4CEF7;
	Wed, 26 Nov 2025 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764180943;
	bh=5NlB3qXmK0FiJLrja9HIY9RXNT1zAJvxj1NnRzHldeM=;
	h=Date:To:From:Subject:From;
	b=PMQDpBcmg8AQeFKUQ7lOzKT7XEDhc7Ke1sg47rNaTzBdFzvcQ9fdWDR6RbVEylD2I
	 H6BqYA+Eim0Q86VyYYP3uY03rBQl9YGybkfF8h9Lk684wqo87/K3/0iGErtJt6X/T9
	 5gUvCeGoXFkzx0tDr58PvbJr8sMyY4+RdgK1/5Iw=
Date: Wed, 26 Nov 2025 10:15:42 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch added to mm-unstable branch
Message-Id: <20251126181543.3ED65C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: add reboot notifier to disable KFENCE on shutdown
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kfence: add reboot notifier to disable KFENCE on shutdown
Date: Wed, 26 Nov 2025 09:46:18 -0800

During system shutdown, KFENCE can cause IPI synchronization issues if it
remains active through the reboot process.  To prevent this, register a
reboot notifier that disables KFENCE and cancels any pending timer work
early in the shutdown sequence.

This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as this
configuration sends IPIs that can interfere with shutdown.  Without static
keys, no IPIs are generated and KFENCE can safely remain active.

The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts down
before other subsystems that might still depend on stable memory
allocation behavior.

This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
that is busy in a IRQ-disabled context printing characters to the console.

Link: https://lkml.kernel.org/r/20251126-kfence-v1-1-5a6e1d7c681c@debian.org
Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/kfence/core.c~mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown
+++ a/mm/kfence/core.c
@@ -26,6 +26,7 @@
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/reboot.h>
 #include <linux/sched/clock.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -820,6 +821,25 @@ static struct notifier_block kfence_chec
 static struct delayed_work kfence_timer;
 
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+static int kfence_reboot_callback(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	/*
+	 * Disable kfence to avoid static keys IPI synchronization during
+	 * late shutdown/kexec
+	 */
+	WRITE_ONCE(kfence_enabled, false);
+	/* Cancel any pending timer work */
+	cancel_delayed_work_sync(&kfence_timer);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kfence_reboot_notifier = {
+	.notifier_call = kfence_reboot_callback,
+	.priority = INT_MAX, /* Run early to stop timers ASAP */
+};
+
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
 
@@ -901,6 +921,10 @@ static void kfence_init_enable(void)
 	if (kfence_check_on_panic)
 		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
 
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+	register_reboot_notifier(&kfence_reboot_notifier);
+#endif
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch
vmcoreinfo-track-and-log-recoverable-hardware-errors.patch

