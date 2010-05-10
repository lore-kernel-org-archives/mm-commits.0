From: akpm@linux-foundation.org
Subject: + ad525x_dpot-extend-write-argument-to-16bits.patch added to -mm tree
Date: Mon, 10 May 2010 15:11:28 -0700
Message-ID: <201005102211.o4AMBSpZ025606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878Ab0EJWLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     ad525x_dpot: extend write argument to 16bits
has been added to the -mm tree.  Its filename is
     ad525x_dpot-extend-write-argument-to-16bits.patch

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
Subject: ad525x_dpot: extend write argument to 16bits
From: Michael Hennerich <michael.hennerich@analog.com>

The possible output data is 16bits, not 8bits, so don't truncate it.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/ad525x_dpot.c~ad525x_dpot-extend-write-argument-to-16bits drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~ad525x_dpot-extend-write-argument-to-16bits
+++ a/drivers/misc/ad525x_dpot.c
@@ -75,7 +75,7 @@ enum dpot_devid {
 #define AD525X_INC_ALL		(AD525X_I2C_CMD | (0xB << 3))
 
 static s32 ad525x_read(struct i2c_client *client, u8 reg);
-static s32 ad525x_write(struct i2c_client *client, u8 reg, u8 value);
+static s32 ad525x_write(struct i2c_client *client, u8 reg, u16 value);
 
 /*
  * Client data (each client gets its own)
@@ -296,7 +296,7 @@ static s32 ad525x_read(struct i2c_client
  * A negative return value indicates an error occurred while reading
  * the register.
  */
-static s32 ad525x_write(struct i2c_client *client, u8 reg, u8 value)
+static s32 ad525x_write(struct i2c_client *client, u8 reg, u16 value)
 {
 	struct dpot_data *data = i2c_get_clientdata(client);
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch
linux-next.patch
backlight-new-driver-for-the-adp8860-backlight-parts.patch
ad525x_dpot-simplify-duplicated-sysfs-defines.patch
ad525x_dpot-extend-write-argument-to-16bits.patch
ad525x_dpot-add-support-for-spi-parts.patch
ad525x_dpot-add-support-for-ad524x-pots.patch
ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch
ad525x_dpot-add-support-for-one-time-programmable-pots.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch

