From: akpm@linux-foundation.org
Subject: + dvb-fix-i2c-adapters-name-size.patch added to -mm tree
Date: Tue, 26 Aug 2008 17:30:09 -0700
Message-ID: <200808270030.m7R0U9tu003198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYH0Abu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 20:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, mchehab@infradead.org, mkrufky@linuxtv.org, patrick.boettcher@desy.de, stoth@hauppauge.com, uwe.bugla@gmx.de


The patch titled
     dvb: fix I2C adapters name size
has been added to the -mm tree.  Its filename is
     dvb-fix-i2c-adapters-name-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb: fix I2C adapters name size
From: Jean Delvare <khali@linux-fr.org>

Some DVB drivers are incorrectly assuming that the size of
i2c_adapter.name is I2C_NAME_SIZE.  Here's a fix.

Also change strncpy to strlcpy, as the former is error-prone (and was
indeed incorrectly used.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Uwe Bugla <uwe.bugla@gmx.de>
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
Acked-by: Steven Toth <stoth@hauppauge.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <patrick.boettcher@desy.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/b2c2/flexcop-i2c.c  |   12 ++++++------
 drivers/media/dvb/frontends/cx24123.c |    4 ++--
 drivers/media/dvb/frontends/s5h1420.c |    3 ++-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/media/dvb/b2c2/flexcop-i2c.c~dvb-fix-i2c-adapters-name-size drivers/media/dvb/b2c2/flexcop-i2c.c
--- a/drivers/media/dvb/b2c2/flexcop-i2c.c~dvb-fix-i2c-adapters-name-size
+++ a/drivers/media/dvb/b2c2/flexcop-i2c.c
@@ -221,12 +221,12 @@ int flexcop_i2c_init(struct flexcop_devi
 	fc->fc_i2c_adap[1].port = FC_I2C_PORT_EEPROM;
 	fc->fc_i2c_adap[2].port = FC_I2C_PORT_TUNER;
 
-	strncpy(fc->fc_i2c_adap[0].i2c_adap.name,
-		"B2C2 FlexCop I2C to demod", I2C_NAME_SIZE);
-	strncpy(fc->fc_i2c_adap[1].i2c_adap.name,
-		"B2C2 FlexCop I2C to eeprom", I2C_NAME_SIZE);
-	strncpy(fc->fc_i2c_adap[2].i2c_adap.name,
-		"B2C2 FlexCop I2C to tuner", I2C_NAME_SIZE);
+	strlcpy(fc->fc_i2c_adap[0].i2c_adap.name, "B2C2 FlexCop I2C to demod",
+		sizeof(fc->fc_i2c_adap[0].i2c_adap.name));
+	strlcpy(fc->fc_i2c_adap[1].i2c_adap.name, "B2C2 FlexCop I2C to eeprom",
+		sizeof(fc->fc_i2c_adap[1].i2c_adap.name));
+	strlcpy(fc->fc_i2c_adap[2].i2c_adap.name, "B2C2 FlexCop I2C to tuner",
+		sizeof(fc->fc_i2c_adap[2].i2c_adap.name));
 
 	i2c_set_adapdata(&fc->fc_i2c_adap[0].i2c_adap, &fc->fc_i2c_adap[0]);
 	i2c_set_adapdata(&fc->fc_i2c_adap[1].i2c_adap, &fc->fc_i2c_adap[1]);
diff -puN drivers/media/dvb/frontends/cx24123.c~dvb-fix-i2c-adapters-name-size drivers/media/dvb/frontends/cx24123.c
--- a/drivers/media/dvb/frontends/cx24123.c~dvb-fix-i2c-adapters-name-size
+++ a/drivers/media/dvb/frontends/cx24123.c
@@ -1072,8 +1072,8 @@ struct dvb_frontend* cx24123_attach(cons
     if (config->dont_use_pll)
 	cx24123_repeater_mode(state, 1, 0);
 
-	strncpy(state->tuner_i2c_adapter.name,
-		"CX24123 tuner I2C bus", I2C_NAME_SIZE);
+	strlcpy(state->tuner_i2c_adapter.name, "CX24123 tuner I2C bus",
+		sizeof(state->tuner_i2c_adapter.name));
 	state->tuner_i2c_adapter.class     = I2C_CLASS_TV_DIGITAL,
 	state->tuner_i2c_adapter.algo      = &cx24123_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
diff -puN drivers/media/dvb/frontends/s5h1420.c~dvb-fix-i2c-adapters-name-size drivers/media/dvb/frontends/s5h1420.c
--- a/drivers/media/dvb/frontends/s5h1420.c~dvb-fix-i2c-adapters-name-size
+++ a/drivers/media/dvb/frontends/s5h1420.c
@@ -915,7 +915,8 @@ struct dvb_frontend *s5h1420_attach(cons
 	state->frontend.demodulator_priv = state;
 
 	/* create tuner i2c adapter */
-	strncpy(state->tuner_i2c_adapter.name, "S5H1420-PN1010 tuner I2C bus", I2C_NAME_SIZE);
+	strlcpy(state->tuner_i2c_adapter.name, "S5H1420-PN1010 tuner I2C bus",
+		sizeof(state->tuner_i2c_adapter.name));
 	state->tuner_i2c_adapter.class     = I2C_CLASS_TV_DIGITAL,
 	state->tuner_i2c_adapter.algo      = &s5h1420_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
dvb-fix-i2c-adapters-name-size.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
resource-add-resource_type-and-ioresource_type_bits.patch
i2c-use-bcd2bin-bin2bcd.patch

