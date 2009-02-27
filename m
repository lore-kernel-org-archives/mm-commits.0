From: akpm@linux-foundation.org
Subject: + input-ads7846-introduce-platform-specific-way-to-synchronize-sampling.patch added to -mm tree
Date: Fri, 27 Feb 2009 11:54:59 -0800
Message-ID: <200902271954.n1RJsx7k028891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbZB0TzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 14:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, david-b@pacbell.net, dtor@mail.ru


The patch titled
     input: ads7846: introduce platform specific way to synchronize sampling
has been added to the -mm tree.  Its filename is
     input-ads7846-introduce-platform-specific-way-to-synchronize-sampling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: ads7846: introduce platform specific way to synchronize sampling
From: Eric Miao <eric.miao@marvell.com>

Noises can be introduced when LCD signals are being driven, some platforms
provide a signal to assist the synchronization of this sampling procedure.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |   10 ++++++++++
 include/linux/spi/ads7846.h         |    2 ++
 2 files changed, 12 insertions(+)

diff -puN drivers/input/touchscreen/ads7846.c~input-ads7846-introduce-platform-specific-way-to-synchronize-sampling drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~input-ads7846-introduce-platform-specific-way-to-synchronize-sampling
+++ a/drivers/input/touchscreen/ads7846.c
@@ -127,6 +127,8 @@ struct ads7846 {
 	void			(*filter_cleanup)(void *data);
 	int			(*get_pendown_state)(void);
 	int			gpio_pendown;
+
+	void			(*wait_for_sync)(void);
 };
 
 /* leave chip selected when we're done, for quicker re-select? */
@@ -511,6 +513,10 @@ static int get_pendown_state(struct ads7
 	return !gpio_get_value(ts->gpio_pendown);
 }
 
+static void null_wait_for_sync(void)
+{
+}
+
 /*
  * PENIRQ only kicks the timer.  The timer only reissues the SPI transfer,
  * to retrieve touchscreen status.
@@ -686,6 +692,7 @@ static void ads7846_rx_val(void *ads)
 	default:
 		BUG();
 	}
+	ts->wait_for_sync();
 	status = spi_async(ts->spi, m);
 	if (status)
 		dev_err(&ts->spi->dev, "spi_async --> %d\n",
@@ -723,6 +730,7 @@ static enum hrtimer_restart ads7846_time
 	} else {
 		/* pen is still down, continue with the measurement */
 		ts->msg_idx = 0;
+		ts->wait_for_sync();
 		status = spi_async(ts->spi, &ts->msg[0]);
 		if (status)
 			dev_err(&ts->spi->dev, "spi_async --> %d\n", status);
@@ -949,6 +957,8 @@ static int __devinit ads7846_probe(struc
 		ts->penirq_recheck_delay_usecs =
 				pdata->penirq_recheck_delay_usecs;
 
+	ts->wait_for_sync = (pdata->wait_for_sync) ? : null_wait_for_sync;
+
 	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", dev_name(&spi->dev));
 
 	input_dev->name = "ADS784x Touchscreen";
diff -puN include/linux/spi/ads7846.h~input-ads7846-introduce-platform-specific-way-to-synchronize-sampling include/linux/spi/ads7846.h
--- a/include/linux/spi/ads7846.h~input-ads7846-introduce-platform-specific-way-to-synchronize-sampling
+++ a/include/linux/spi/ads7846.h
@@ -51,5 +51,7 @@ struct ads7846_platform_data {
 				 void **filter_data);
 	int	(*filter)	(void *filter_data, int data_idx, int *val);
 	void	(*filter_cleanup)(void *filter_data);
+
+	void	(*wait_for_sync)(void);
 };
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

linux-next.patch
input-ads7846-introduce-platform-specific-way-to-synchronize-sampling.patch
spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases.patch

