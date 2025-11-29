Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83587FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441716; cv=none; b=Wlti3t9YvmYvK8i1HZrednsU1lBTte+melQdQ2sKSHIuJPkenPA+amLncnTbbiO1xXKLZv0V3gE6MLw0UVtx3TdZoAcDVEgw8yk26oSnnE1idF1wVWv5WzDRIH1peQ5E+AMasVP4keLqCnclJtiQ03WcRig/UDG3iFzkisj5n0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441716; c=relaxed/simple;
	bh=4cN/x7R2++myQS3HfB1clDPWPZ+hCyixHVsSoDjEDik=;
	h=Date:To:From:Subject:Message-Id; b=Hr+6Zngpe+C2KwcSudXriWnlAGD9WsvVBtLc91RTUN9MTtEZjdYjJ5KZBBy5ALVmCHUmUPlU7QHMghXM1exNTr9CCc0c5M+WN5fV0FfKxBPDfh8biaF48MSE4pjOeNlpOhZDBMx0HNUn5ePxBhUlNduCsdqBGDjiJV5R0fK1DPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V2JbddLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V2JbddLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67392C4CEF7;
	Sat, 29 Nov 2025 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441716;
	bh=4cN/x7R2++myQS3HfB1clDPWPZ+hCyixHVsSoDjEDik=;
	h=Date:To:From:Subject:From;
	b=V2JbddLiBcBXtIa1DnlMAoWJdzUXfs0tUut6SGkM7BGiqh21uCPkNUx0ObIegMo01
	 SbwqPdv4tmXy4NaDb29r0qlQokGbRU0PPMym5TqI9Q/XkUeZVx6GQL0H9F4q71nuGh
	 SmGbi6yRnCGm/FKkLmpg2g+XiJx68yMfu9mkQyxw=
Date: Sat, 29 Nov 2025 10:41:55 -0800
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch removed from -mm tree
Message-Id: <20251129184156.67392C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: add reboot notifier to disable KFENCE on shutdown
has been removed from the -mm tree.  Its filename was
     mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20251127-kfence-v2-1-daeccb5ef9aa@debian.org
Link: https://lkml.kernel.org/r/20251126-kfence-v1-1-5a6e1d7c681c@debian.org
Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
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


