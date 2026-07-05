Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CBF70809
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 01:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783213585; cv=none; b=Y/1/9YSbm4GKRtfYfxVaBlrIBahHoVMGb3vvTdMCRbItK0aFfyz7Zw4OYIffc6oDnWGMwiA2cgPMVRjtykqBfu7KLKmOXKxN9Y7ZSrMaSZZNxvef2YR1i0T8n5SNfcqGPub42RK72hTWmIudYDnCTJtnx7cVIU0fTkt3v/tIOQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783213585; c=relaxed/simple;
	bh=5wqE2H94b2eAJ0crbFTbb00/F/9UxU1uAnvrYGaqnHc=;
	h=Date:To:From:Subject:Message-Id; b=h8nLdean/7cjQiGNG5w6eFlIzjs7plyRFNFM2hfiBETnk73YsugSk4CXlPPu3x35H/f+hdozbVJfVynEYAWeJxdm4ZuAChYzZKFJfWSN2Q1PE1a9MLb4xGe5uS1pi0t2JhINb7W67bkcoA9bV7xe9FdEXSmSg7qc7+mWQRsQ3iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2W7f7hqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2W7f7hqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC821F000E9;
	Sun,  5 Jul 2026 01:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783213584;
	bh=AisfbAonOOvmfNNDDq41ZEU+ao5TFZlPfC3+YC2Ti5E=;
	h=Date:To:From:Subject;
	b=2W7f7hqGjonz2WKAmmFvjnqhS7+YcGeujIdT7N3YtAFW1BsRrpZwcMGHDVJ6mqCbY
	 1A2CeyxIf1GRapTmPKEkL2aShXoBP3tW/t5gTSdq+1h+3VsVTbDypaLnzfStL8jr6X
	 2ZpXZ+rNk+XIMQIxRPB+8RvFOSTSYdu51hz64Epk=
Date: Sat, 04 Jul 2026 18:06:23 -0700
To: mm-commits@vger.kernel.org,giometti@enneenne.com,calvin@wbinvd.org,bigeasy@linutronix.de,by@by-online.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch added to mm-nonmm-unstable branch
Message-Id: <20260705010624.2EC821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch

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
From: Michael Byczkowski <by@by-online.de>
Subject: pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler
Date: Mon, 1 Jun 2026 17:44:09 -0700

Split the pps-gpio interrupt handler into a primary (hardirq) handler that
captures the PPS timestamp at interrupt entry, and a threaded handler that
processes the event.  This produces the same two-part handler structure on
both PREEMPT_RT and non-RT kernels.

On non-RT kernels the threaded portion runs immediately after the primary,
with no behavioral change compared to the previous single-handler
implementation.

On PREEMPT_RT, where interrupt handlers are force-threaded by default, the
previous single-handler implementation captured the timestamp inside the
threaded portion, after IRQ-thread scheduling delay.  With the split, the
timestamp is captured in true hardirq context as it is on non-RT kernels,
eliminating a significant source of PPS jitter on RT systems.

Link: https://lore.kernel.org/2e32729029fbf6977ecf04665eb00f2efd3e2c17.1780359378.git.calvin@wbinvd.org
Signed-off-by: Michael Byczkowski <by@by-online.de>
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Michael Byczkowski <by@by-online.de>
Tested-by: Calvin Owens <calvin@wbinvd.org>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |   37 ++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/drivers/pps/clients/pps-gpio.c~pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler
+++ a/drivers/pps/clients/pps-gpio.c
@@ -35,33 +35,44 @@ struct pps_gpio_device_data {
 	bool capture_clear;
 	unsigned int echo_active_ms;	/* PPS echo active duration */
 	unsigned long echo_timeout;	/* timer timeout value in jiffies */
+	struct pps_event_time ts;	/* timestamp captured in hardirq */
 };
 
 /*
  * Report the PPS event
  */
 
-static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
+/*
+ * Primary hardirq handler -- runs in hardirq context even on PREEMPT_RT.
+ * Only captures the timestamp; all other work is deferred to the thread.
+ */
+static irqreturn_t pps_gpio_irq_hardirq(int irq, void *data)
 {
-	const struct pps_gpio_device_data *info;
-	struct pps_event_time ts;
-	int rising_edge;
+	struct pps_gpio_device_data *info = data;
+
+	pps_get_ts(&info->ts);
 
-	/* Get the time stamp first */
-	pps_get_ts(&ts);
+	return IRQ_WAKE_THREAD;
+}
 
-	info = data;
+/*
+ * Threaded handler -- processes the PPS event using the timestamp
+ * captured in hardirq context above.
+ */
+static irqreturn_t pps_gpio_irq_thread(int irq, void *data)
+{
+	struct pps_gpio_device_data *info = data;
+	int rising_edge;
 
-	/* Small trick to bypass the check on edge's direction when capture_clear is unset */
 	rising_edge = info->capture_clear ?
 		      gpiod_get_value(info->gpio_pin) : !info->assert_falling_edge;
 	if ((rising_edge && !info->assert_falling_edge) ||
 			(!rising_edge && info->assert_falling_edge))
-		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, data);
+		pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
 	else if (info->capture_clear &&
 			((rising_edge && info->assert_falling_edge) ||
 			(!rising_edge && !info->assert_falling_edge)))
-		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, data);
+		pps_event(info->pps, &info->ts, PPS_CAPTURECLEAR, data);
 	else
 		dev_warn_ratelimited(&info->pps->dev, "IRQ did not trigger any PPS event\n");
 
@@ -210,8 +221,10 @@ static int pps_gpio_probe(struct platfor
 	}
 
 	/* register IRQ interrupt handler */
-	ret = request_irq(data->irq, pps_gpio_irq_handler,
-			  get_irqf_trigger_flags(data), data->info.name, data);
+	ret = request_threaded_irq(data->irq,
+			  pps_gpio_irq_hardirq, pps_gpio_irq_thread,
+			  get_irqf_trigger_flags(data) | IRQF_ONESHOT,
+			  data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
_

Patches currently in -mm which might be from by@by-online.de are

pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch

