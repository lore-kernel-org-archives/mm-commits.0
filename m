Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F39742BC4F
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816305; cv=none; b=tgLQl7Nt+MWzD8f4rnB/S0uV5WmusRUcPNmNBs2KvDk+h4d6MMUaf+1jFOaAvmN7+6mPc5hst1MpcO23pyrVTsZJ/ZV/Mpog3ZjlAbZCVGKg9FshCp5VD9ynDpN6CwUlsrqUqDKv5Zoifl95dgnJZV9vCyJTLSzn1HBgAXq1Qnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816305; c=relaxed/simple;
	bh=oGU65ZVdH8IHA7dAmlzAAKPpzG5Jb6AQEvyfhMSB9q8=;
	h=Date:To:From:Subject:Message-Id; b=BSag8Tk9wKP+yamuzSrEiu2aWLC2wP9bBKNoixKnLx9JS+Km4ePtJ7hG18MS9KFbeBCRjyyNSZR50T+T9drOsf4b01slsH9mu/gK0KbNh1pYFsQMcgmObxXZW5L0MQUAyjO+4dAFeH7V+5y1ZApqwgX5FQesTqqiGxTaw0fr340=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=itPbL9uc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="itPbL9uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2061F00A3A;
	Tue,  4 Aug 2026 04:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816304;
	bh=RIx3YVeGVU2d18YtNWknbu2KeCXtJsCdoQvR1Ap1rHU=;
	h=Date:To:From:Subject;
	b=itPbL9uc7YiS4iFA+M7wMBP8oxDoT/9/8FBAh0RLxqeBflE+kci6GlC9sGtSTDZPl
	 xN5pXBjqdLqvS0lAlzBowWfLwSpt5uarJ8fuMc/SNvgwsAPqMXbweRrs0EEoWy459z
	 o/jqgwd3U5th4X0OiUfsSqnsv9ep/1M8/ssCcmzE=
Date: Mon, 03 Aug 2026 21:05:03 -0700
To: mm-commits@vger.kernel.org,giometti@enneenne.com,calvin@wbinvd.org,bigeasy@linutronix.de,by@by-online.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch removed from -mm tree
Message-Id: <20260804040504.0F2061F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler
has been removed from the -mm tree.  Its filename was
     pps-pps-gpio-split-irq-handler-into-hardirq-timestamper-threaded-handler.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -34,33 +34,44 @@ struct pps_gpio_device_data {
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
 
@@ -209,8 +220,10 @@ static int pps_gpio_probe(struct platfor
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


