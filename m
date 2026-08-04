Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F4342123B
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816311; cv=none; b=WqnJdoy5ZJKf4WEuZ9YwAWmG6U/w6NNGjOZvTcy+Wu96ImVPyaQucJolH9kFclvlTp0VSc4Mmsj+0IwHM77fDxqPUVzV//J/Cgq80KwokqjUBQaUZwgEEs8cK0BwYOJY/xKJl4FPv0SmmWOmP59nR1C5BNk0vogj00Fn5SH0cWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816311; c=relaxed/simple;
	bh=4xIua15D0fopYdmzE3bFueCve6odpfjmv1tpsrN31Uc=;
	h=Date:To:From:Subject:Message-Id; b=t6RkpqAWzAwhFoDzsTt5xBoQ68J7k1I/PXgu/WP1FfKAYX4aq3ld00lt0A78EyNL5ViYICUs0whuDlm9es4Epgc/E7veqpm+vuJ1bXiK6P7r1PDP6N/yayd6r9gyYhVTXFzH9MjYSWAh3+WolpJ26Z7vkNYmkBOQLVbVz5ci+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oGq9Y9Vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oGq9Y9Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0701F000E9;
	Tue,  4 Aug 2026 04:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816310;
	bh=ME5+1SpVKfKL5lFZgphycqmtjTzmmpUzyUjjjUOKlSM=;
	h=Date:To:From:Subject;
	b=oGq9Y9VlH3JKM+ax/XqLOyxNzDpkaMoYoyFm1RGKr9rA2C84KK/xp3ibySdW3Nzvd
	 edG3S56Ww3jA+cehxBRD/IQueBhf2BXmdM10zb237cDUectfmZg9IF796uZPITLwqy
	 A953Rx/Jb1hrwhQCdFSXyDWv0gwYdpbKqP02jEBs=
Date: Mon, 03 Aug 2026 21:05:09 -0700
To: mm-commits@vger.kernel.org,giometti@enneenne.com,calvin@wbinvd.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pps-gpio-remove-dead-capture_clear-code.patch removed from -mm tree
Message-Id: <20260804040510.5B0701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pps-gpio: remove dead capture_clear code
has been removed from the -mm tree.  Its filename was
     pps-gpio-remove-dead-capture_clear-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Calvin Owens <calvin@wbinvd.org>
Subject: pps-gpio: remove dead capture_clear code
Date: Mon, 6 Jul 2026 10:19:07 -0700

The capture_clear field is never set, and all code conditional on it being
set has been unreachable since the platform data logic was removed from
pps-gpio in ee89646619ba ("pps: clients: gpio: Get rid of legacy platform
data").

I think the only logical thing to do here is to remove it all, since no
in-tree code ever actually used it in the first place, and it has been
completely dead code for over five years (since v5.13).

Sashiko asked some questions about the gpiod_get_value() call which caused
me to look deeper and figure this out, but it did not actually notice
capture_clear is never set.

Link: https://lore.kernel.org/f70196bafcf75d9782dd36ed784e42345b6e8a1b.1783355507.git.calvin@wbinvd.org
Fixes: ee89646619ba ("pps: clients: gpio: Get rid of legacy platform data")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Closes: https://sashiko.dev/#/patchset/cover.1779733602.git.calvin%40wbinvd.org?part=1
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |   35 ++-----------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

--- a/drivers/pps/clients/pps-gpio.c~pps-gpio-remove-dead-capture_clear-code
+++ a/drivers/pps/clients/pps-gpio.c
@@ -31,7 +31,6 @@ struct pps_gpio_device_data {
 	struct gpio_desc *echo_pin;
 	struct timer_list echo_timer;	/* timer to reset echo active state */
 	bool assert_falling_edge;
-	bool capture_clear;
 	unsigned int echo_active_ms;	/* PPS echo active duration */
 	unsigned long echo_timeout;	/* timer timeout value in jiffies */
 	struct pps_event_time ts;	/* timestamp captured in hardirq */
@@ -61,19 +60,8 @@ static irqreturn_t pps_gpio_irq_hardirq(
 static irqreturn_t pps_gpio_irq_thread(int irq, void *data)
 {
 	struct pps_gpio_device_data *info = data;
-	int rising_edge;
 
-	rising_edge = info->capture_clear ?
-		      gpiod_get_value(info->gpio_pin) : !info->assert_falling_edge;
-	if ((rising_edge && !info->assert_falling_edge) ||
-			(!rising_edge && info->assert_falling_edge))
-		pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
-	else if (info->capture_clear &&
-			((rising_edge && info->assert_falling_edge) ||
-			(!rising_edge && !info->assert_falling_edge)))
-		pps_event(info->pps, &info->ts, PPS_CAPTURECLEAR, data);
-	else
-		dev_warn_ratelimited(&info->pps->dev, "IRQ did not trigger any PPS event\n");
+	pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
 
 	return IRQ_HANDLED;
 }
@@ -89,11 +77,6 @@ static void pps_gpio_echo(struct pps_dev
 		if (pps->params.mode & PPS_ECHOASSERT)
 			gpiod_set_value(info->echo_pin, 1);
 		break;
-
-	case PPS_CAPTURECLEAR:
-		if (pps->params.mode & PPS_ECHOCLEAR)
-			gpiod_set_value(info->echo_pin, 1);
-		break;
 	}
 
 	/* fire the timer */
@@ -155,15 +138,8 @@ static int pps_gpio_setup(struct device
 static unsigned long
 get_irqf_trigger_flags(const struct pps_gpio_device_data *data)
 {
-	unsigned long flags = data->assert_falling_edge ?
-		IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
-
-	if (data->capture_clear) {
-		flags |= ((flags & IRQF_TRIGGER_RISING) ?
-				IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING);
-	}
-
-	return flags;
+	return data->assert_falling_edge ? IRQF_TRIGGER_FALLING :
+					   IRQF_TRIGGER_RISING;
 }
 
 static int pps_gpio_probe(struct platform_device *pdev)
@@ -196,9 +172,6 @@ static int pps_gpio_probe(struct platfor
 	/* initialize PPS specific parts of the bookkeeping data structure. */
 	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 		PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
-	if (data->capture_clear)
-		data->info.mode |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR |
-			PPS_ECHOCLEAR;
 	data->info.owner = THIS_MODULE;
 	snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
 		 pdev->name, pdev->id);
@@ -210,8 +183,6 @@ static int pps_gpio_probe(struct platfor
 
 	/* register PPS source */
 	pps_default_params = PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
-	if (data->capture_clear)
-		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (IS_ERR(data->pps)) {
 		dev_err(dev, "failed to register IRQ %d as PPS source\n",
_

Patches currently in -mm which might be from calvin@wbinvd.org are


