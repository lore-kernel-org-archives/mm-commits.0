From: akpm@linux-foundation.org
Subject: + genirq-better-warning-on-irqchip-set_type-failure.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:19:43 -0700
Message-ID: <200807290719.m6T7JhQr020656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbYG2HUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, Uwe.Kleine-Koenig@digi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: better warning on irqchip->set_type() failure
has been added to the -mm tree.  Its filename is
     genirq-better-warning-on-irqchip-set_type-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: genirq: better warning on irqchip->set_type() failure
=46rom: David Brownell <dbrownell@users.sourceforge.net>

While I'm glad to finally see the hole fixed whereby passing an invalid
IRQ trigger type to request_irq() would be ignored, the current diagnos=
tic
isn't quite useful.  Fixed by also listing the trigger type which was
rejected.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~genirq-better-warning-on-irqchip-set_type=
-failure kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-better-warning-on-irqchip-set_type-fai=
lure
+++ a/kernel/irq/manage.c
@@ -330,7 +330,8 @@ static int __irq_set_trigger(struct irq_
 	ret =3D chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
=20
 	if (ret)
-		pr_err("setting flow type for irq %u failed (%pF)\n",
+		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
+				(int)(flags & IRQF_TRIGGER_MASK),
 				irq, chip->set_type);
=20
 	return ret;
_

Patches currently in -mm which might be from dbrownell@users.sourceforg=
e.net are

origin.patch
arm-fix-have_clk-merge-goof.patch
mpc52xx_psc_spi-fix-block-transfer.patch
spi_s3c24xx-really-assign-busnum.patch
gpio-fix-build-on-config_gpio_sysfs=3Dn.patch
rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
linux-next.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
