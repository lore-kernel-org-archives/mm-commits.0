From: akpm@linux-foundation.org
Subject: + rtc_cmos-convert-shutdown-to-new-pnp_driver-shutdown.patch added to -mm tree
Date: Tue, 05 Jan 2010 17:10:03 -0800
Message-ID: <201001060110.o061A34g031976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674Ab0AFBLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 20:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, a.zummo@towertech.it, bjorn.helgaas@hp.com, david@hardeman.nu, dtor@mail.ru, maltesch@gmx.de, p_gortmaker@yahoo.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     rtc_cmos: convert shutdown to new pnp_driver->shutdown
has been added to the -mm tree.  Its filename is
     rtc_cmos-convert-shutdown-to-new-pnp_driver-shutdown.patch

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
Subject: rtc_cmos: convert shutdown to new pnp_driver->shutdown
=46rom: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit abd6633c67925f90775bb74755f9c547e30f1f20 ("pnp: add a shutdown
method to pnp drivers") adds shutdown method to bus driver blindly.  Wi=
th
it, driver->shutdown is no longer valid.

Use pnp_driver->shutdown instead.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=3D14889

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Malte Schr=F6der <maltesch@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: David Hardeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: <stable@kernel.org>		[2.6.32.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc_cmos-convert-shutdown-to-new-pnp_d=
river-shutdown drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc_cmos-convert-shutdown-to-new-pnp_drive=
r-shutdown
+++ a/drivers/rtc/rtc-cmos.c
@@ -1096,9 +1096,9 @@ static int cmos_pnp_resume(struct pnp_de
 #define	cmos_pnp_resume		NULL
 #endif
=20
-static void cmos_pnp_shutdown(struct device *pdev)
+static void cmos_pnp_shutdown(struct pnp_dev *pnp)
 {
-	if (system_state =3D=3D SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
+	if (system_state =3D=3D SYSTEM_POWER_OFF && !cmos_poweroff(&pnp->dev)=
)
 		return;
=20
 	cmos_do_shutdown();
@@ -1117,15 +1117,12 @@ static struct pnp_driver cmos_pnp_driver
 	.id_table	=3D rtc_ids,
 	.probe		=3D cmos_pnp_probe,
 	.remove		=3D __exit_p(cmos_pnp_remove),
+	.shutdown	=3D cmos_pnp_shutdown,
=20
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		=3D PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.suspend	=3D cmos_pnp_suspend,
 	.resume		=3D cmos_pnp_resume,
-	.driver		=3D {
-		.name	  =3D (char *)driver_name,
-		.shutdown =3D cmos_pnp_shutdown,
-	}
 };
=20
 #endif	/* CONFIG_PNP */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.j=
p are

origin.patch
rtc_cmos-convert-shutdown-to-new-pnp_driver-shutdown.patch
tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
