From: akpm@linux-foundation.org
Subject: + rtc-cmos-fix-wakeup-from-s5-without-config_pm_sleep.patch added to -mm tree
Date: Mon, 06 Oct 2014 11:25:51 -0700
Message-ID: <5432deaf.DjyJ6IE28IEp/A7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaJFSZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Oct 2014 14:25:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel-gl@gmx.net, a.zummo@towertech.it, mika.westerberg@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-cmos: fix wakeup from S5 without CONFIG_PM_SLEEP
has been added to the -mm tree.  Its filename is
     rtc-cmos-fix-wakeup-from-s5-without-config_pm_sleep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-cmos-fix-wakeup-from-s=
5-without-config_pm_sleep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-cmos-fix-wakeup-from-s=
5-without-config_pm_sleep.patch

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
=46rom: Daniel Gl=F6ckner <daniel-gl@gmx.net>
Subject: rtc-cmos: fix wakeup from S5 without CONFIG_PM_SLEEP

b5ada4600d ("drivers/rtc/rtc-cmos.c: fix compilation warning when
!CONFIG_PM_SLEEP") broke wakeup from S5 by making cmos_poweroff a nop
unless CONFIG_PM_SLEEP was defined.  Fix this by restricting the #ifdef=
 to
cmos_resume and restoring the old dependency on CONFIG_PM for cmos_susp=
end
and cmos_poweroff.

Signed-off-by: Daniel Gl=F6ckner <daniel-gl@gmx.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-fix-wakeup-from-s5-without-co=
nfig_pm_sleep drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-fix-wakeup-from-s5-without-config=
_pm_sleep
+++ a/drivers/rtc/rtc-cmos.c
@@ -856,7 +856,7 @@ static void __exit cmos_do_remove(struct
 	cmos->dev =3D NULL;
 }
=20
-#ifdef	CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
=20
 static int cmos_suspend(struct device *dev)
 {
@@ -907,6 +907,8 @@ static inline int cmos_poweroff(struct d
 	return cmos_suspend(dev);
 }
=20
+#ifdef	CONFIG_PM_SLEEP
+
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos =3D dev_get_drvdata(dev);
@@ -954,6 +956,7 @@ static int cmos_resume(struct device *de
 	return 0;
 }
=20
+#endif
 #else
=20
 static inline int cmos_poweroff(struct device *dev)
_

Patches currently in -mm which might be from daniel-gl@gmx.net are

rtc-cmos-fix-wakeup-from-s5-without-config_pm_sleep.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
