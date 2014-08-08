From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-pcf85063-support-fix.patch removed from
 -mm tree
Date: Fri, 08 Aug 2014 13:56:32 -0700
Message-ID: <53e53980.CRoa+ZD5Zz0VktA2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:32889 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229AbaHHU4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:56:33 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so252001igi.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:56:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, san@rosetechnology.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-pcf85063-support-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-pcf85063-support-fix.patch

This patch was dropped because it was folded into rtc-add-pcf85063-supp=
ort.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-pcf85063-support-fix

fix comment typo, tweak conding style

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: S=F8ren Andersen <san@rosetechnology.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf85063.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf85063.c~rtc-add-pcf85063-support-fix drive=
rs/rtc/rtc-pcf85063.c
--- a/drivers/rtc/rtc-pcf85063.c~rtc-add-pcf85063-support-fix
+++ a/drivers/rtc/rtc-pcf85063.c
@@ -36,7 +36,7 @@ static struct i2c_driver pcf85063_driver
 struct pcf85063 {
 	struct rtc_device *rtc;
 	int c_polarity;	/* 0: MO_C=3D1 means 19xx, otherwise MO_C=3D1 means 2=
0xx */
-	int voltage_low; /* incicates if a low_voltage was detected */
+	int voltage_low; /* indicates if a low_voltage was detected */
 };
=20
 /*
@@ -47,7 +47,6 @@ static int pcf85063_get_datetime(struct
 {
 	struct pcf85063 *pcf85063 =3D i2c_get_clientdata(client);
 	unsigned char buf[13] =3D { PCF85063_REG_CTRL1 };
-
 	struct i2c_msg msgs[] =3D {
 		{/* setup read ptr */
 			.addr =3D client->addr,
@@ -61,6 +60,7 @@ static int pcf85063_get_datetime(struct
 			.buf =3D buf
 		},
 	};
+
 	/* read registers */
 	if ((i2c_transfer(client->adapter, msgs, 2)) !=3D 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.pa=
tch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
