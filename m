From: akpm@linux-foundation.org
Subject: + pcf857x-support-working-w-o-platform-data.patch added to -mm tree
Date: Mon, 21 Jun 2010 11:43:48 -0700
Message-ID: <201006211843.o5LIhm47030405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab0FUSoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 14:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, david-b@pacbell.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     pcf857x: support working w/o platform data
has been added to the -mm tree.  Its filename is
     pcf857x-support-working-w-o-platform-data.patch

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
Subject: pcf857x: support working w/o platform data
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Provide sane defaults for pcf857x, so the driver can be used w/o providing
platform data (and thus can be simply bound via OF tree).

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pcf857x.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/pcf857x.c~pcf857x-support-working-w-o-platform-data drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~pcf857x-support-working-w-o-platform-data
+++ a/drivers/gpio/pcf857x.c
@@ -190,7 +190,6 @@ static int pcf857x_probe(struct i2c_clie
 	pdata = client->dev.platform_data;
 	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data\n");
-		return -EINVAL;
 	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
@@ -200,7 +199,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	mutex_init(&gpio->lock);
 
-	gpio->chip.base = pdata->gpio_base;
+	gpio->chip.base = pdata ? pdata->gpio_base : -1;
 	gpio->chip.can_sleep = 1;
 	gpio->chip.dev = &client->dev;
 	gpio->chip.owner = THIS_MODULE;
@@ -278,7 +277,7 @@ static int pcf857x_probe(struct i2c_clie
 	 * to zero, our software copy of the "latch" then matches the chip's
 	 * all-ones reset state.  Otherwise it flags pins to be driven low.
 	 */
-	gpio->out = ~pdata->n_latch;
+	gpio->out = pdata ? ~pdata->n_latch : ~0;
 
 	status = gpiochip_add(&gpio->chip);
 	if (status < 0)
@@ -299,7 +298,7 @@ static int pcf857x_probe(struct i2c_clie
 	/* Let platform code set up the GPIOs and their users.
 	 * Now is the first time anyone could use them.
 	 */
-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		status = pdata->setup(client,
 				gpio->chip.base, gpio->chip.ngpio,
 				pdata->context);
@@ -322,7 +321,7 @@ static int pcf857x_remove(struct i2c_cli
 	struct pcf857x			*gpio = i2c_get_clientdata(client);
 	int				status = 0;
 
-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
 		status = pdata->teardown(client,
 				gpio->chip.base, gpio->chip.ngpio,
 				pdata->context);
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

linux-next.patch
pcf857x-support-working-w-o-platform-data.patch

