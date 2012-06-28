From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mxcc-fix-irq-enabled-interrupts-warning.patch added to -mm tree
Date: Thu, 28 Jun 2012 14:09:00 -0700
Message-ID: <20120628210900.CB7CEA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52145 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2F1VJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 17:09:03 -0400
Received: by vcbfl13 with SMTP id fl13so258490vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 14:09:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benoit.thebaudeau@advansee.com, a.zummo@towertech.it, kernel@pengutronix.de, stable@vger.kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mxcc-fix-irq-enabled-interrupts-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Beno=EEt Th=E9baudeau <benoit.thebaudeau@advansee.com>
Subject: drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning

[   29.669224] WARNING: at /linux/kernel/irq/handle.c:146 handle_irq_ev=
ent_=3D
percpu+0x19c/0x1b8()
[   29.669269] irq 25 handler mxc_rtc_interrupt+0x0/0xac enabled interr=
upts
[   29.669284] Modules linked in:
[   29.669324] [<c0012218>] (unwind_backtrace+0x0/0xf0) from [<c001c1dc=
>] (=3D
warn_slowpath_common+0x4c/0x64)
[   29.669361] [<c001c1dc>] (warn_slowpath_common+0x4c/0x64) from [<c00=
1c28=3D
8>] (warn_slowpath_fmt+0x30/0x40)
[   29.669399] [<c001c288>] (warn_slowpath_fmt+0x30/0x40) from [<c004c4=
6c>]=3D
 (handle_irq_event_percpu+0x19c/0x1b8)
[   29.669439] [<c004c46c>] (handle_irq_event_percpu+0x19c/0x1b8) from =
[<c0=3D
04c4b0>] (handle_irq_event+0x28/0x38)
[   29.669479] [<c004c4b0>] (handle_irq_event+0x28/0x38) from [<c004e4b=
0>] =3D
(handle_level_irq+0x80/0xc4)
[   29.669517] [<c004e4b0>] (handle_level_irq+0x80/0xc4) from [<c004bcd=
0>] =3D
(generic_handle_irq+0x24/0x38)
[   29.669563] [<c004bcd0>] (generic_handle_irq+0x24/0x38) from [<c000e=
6cc>=3D
] (handle_IRQ+0x30/0x84)
[   29.669599] [<c000e6cc>] (handle_IRQ+0x30/0x84) from [<c0008508>] (a=
vic_=3D
handle_irq+0x2c/0x4c)
[   29.669633] [<c0008508>] (avic_handle_irq+0x2c/0x4c) from [<c000db40=
>] (=3D
__irq_svc+0x40/0x60)
[   29.669655] Exception stack(0xc050bf60 to 0xc050bfa8)
[   29.669685] bf60: 00000001 00000000 003c4208 c0018e20 c050a000 c050a=
000 =3D
c054a4c8 c050a000
[   29.669717] bf80: c05157a8 4117b363 80503bb4 00000000 01000000 c050b=
fa8 =3D
c0018e2c c000e808
[   29.669739] bfa0: 60000013 ffffffff
[   29.669769] [<c000db40>] (__irq_svc+0x40/0x60) from [<c000e808>] (de=
faul=3D
t_idle+0x1c/0x30)
[   29.669805] [<c000e808>] (default_idle+0x1c/0x30) from [<c000e9bc>] =
(cpu=3D
_idle+0x68/0xa8)
[   29.669846] [<c000e9bc>] (cpu_idle+0x68/0xa8) from [<c04e76dc>] (sta=
rt_k=3D
ernel+0x22c/0x26c)
[   29.669868] ---[ end trace 2f7406c4b6216986 ]---

Signed-off-by: Beno=EEt Th=E9baudeau <benoit.thebaudeau@advansee.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-irq-enabled-in=
terrupts-warning drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-irq-enabled-interr=
upts-warning
+++ a/drivers/rtc/rtc-mxc.c
@@ -202,10 +202,11 @@ static irqreturn_t mxc_rtc_interrupt(int
 	struct platform_device *pdev =3D dev_id;
 	struct rtc_plat_data *pdata =3D platform_get_drvdata(pdev);
 	void __iomem *ioaddr =3D pdata->ioaddr;
+	unsigned long flags;
 	u32 status;
 	u32 events =3D 0;
=20
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
 	status =3D readw(ioaddr + RTC_RTCISR) & readw(ioaddr + RTC_RTCIENR);
 	/* clear interrupt sources */
 	writew(status, ioaddr + RTC_RTCISR);
@@ -224,7 +225,7 @@ static irqreturn_t mxc_rtc_interrupt(int
 		events |=3D (RTC_PF | RTC_IRQF);
=20
 	rtc_update_irq(pdata->rtc, 1, events);
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
=20
 	return IRQ_HANDLED;
 }
_
Subject: Subject: drivers/rtc/rtc-mxc.c: fix irq enabled interrupts war=
ning

Patches currently in -mm which might be from benoit.thebaudeau@advansee=
=2Ecom are

linux-next.patch
drivers-rtc-rtc-mxcc-fix-irq-enabled-interrupts-warning.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
