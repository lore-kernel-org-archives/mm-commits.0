From: akpm@linux-foundation.org
Subject: + adcxx-fix-for-single-channel-adcs.patch added to -mm tree
Date: Fri, 12 Feb 2010 12:11:29 -0800
Message-ID: <201002122011.o1CKBThH024222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab0BLUMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jose.goncalves@inov.pt, avorontsov@ru.mvista.com, marc.pignat@hevs.ch


The patch titled
     drivers/hwmon/adcxx.c: fix for single-channel ADCs
has been added to the -mm tree.  Its filename is
     adcxx-fix-for-single-channel-adcs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/hwmon/adcxx.c: fix for single-channel ADCs
=46rom: Jos=E9 Miguel Gon=E7alves <jose.goncalves@inov.pt>

While testing an ADC121S021 in an embedded board with a S3C2142 SoC (AR=
M
core), I have found that the 'adcxx' driver does not handle correctly
single channel ADCs from this chip family.  For single channel chips yo=
u
must only issue one read transfer for correct measurement.

Signed-off-by: Jose Miguel Goncalves <jose.goncalves@inov.pt>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adcxx.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/adcxx.c~adcxx-fix-for-single-channel-adcs drive=
rs/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~adcxx-fix-for-single-channel-adcs
+++ a/drivers/hwmon/adcxx.c
@@ -62,18 +62,23 @@ static ssize_t adcxx_read(struct device=20
 	struct spi_device *spi =3D to_spi_device(dev);
 	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
 	struct adcxx *adc =3D dev_get_drvdata(&spi->dev);
-	u8 tx_buf[2] =3D { attr->index << 3 }; /* other bits are don't care *=
/
+	u8 tx_buf[2];
 	u8 rx_buf[2];
 	int status;
-	int value;
+	u32 value;
=20
 	if (mutex_lock_interruptible(&adc->lock))
 		return -ERESTARTSYS;
=20
-	status =3D spi_write_then_read(spi, tx_buf, sizeof(tx_buf),
-					rx_buf, sizeof(rx_buf));
+	if (adc->channels =3D=3D 1) {
+		status =3D spi_read(spi, rx_buf, sizeof(rx_buf));
+	} else {
+		tx_buf[0] =3D attr->index << 3; /* other bits are don't care */
+		status =3D spi_write_then_read(spi, tx_buf, sizeof(tx_buf),
+						rx_buf, sizeof(rx_buf));
+	}
 	if (status < 0) {
-		dev_warn(dev, "spi_write_then_read failed with status %d\n",
+		dev_warn(dev, "SPI synch. transfer failed with status %d\n",
 				status);
 		goto out;
 	}
_

Patches currently in -mm which might be from jose.goncalves@inov.pt are

adcxx-fix-for-single-channel-adcs.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
