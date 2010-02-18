From: akpm@linux-foundation.org
Subject: [merged] x86-move-hp-wmis-probe-function-to-devinittext.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:39 -0800
Message-ID: <201002182045.o1IKjdRl002754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, Larry.Finger@lwfinger.net, deller@gmx.de, elendil@planet.nl, greg@kroah.com, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86: move hp-wmi's probe function to .devinit.text
has been removed from the -mm tree.  Its filename was
     x86-move-hp-wmis-probe-function-to-devinittext.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: move hp-wmi's probe function to .devinit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to hp_wmi_bios_setup is passed to the core via
platform_driver_register and so the function must not disappear when th=
e
=2Einit sections are discarded.  Otherwise (if also having HOTPLUG=3Dy)
unbinding and binding a device to the driver via sysfs will result in a=
n
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe functio=
n
from the struct platform_driver.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Frans Pop <elendil@planet.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~x86-move-hp-wmis-probe-function=
-to-devinittext drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~x86-move-hp-wmis-probe-function-to-=
devinittext
+++ a/drivers/platform/x86/hp-wmi.c
@@ -57,7 +57,7 @@ enum hp_wmi_radio {
 	HPWMI_WWAN =3D 2,
 };
=20
-static int __init hp_wmi_bios_setup(struct platform_device *device);
+static int __devinit hp_wmi_bios_setup(struct platform_device *device)=
;
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
 static int hp_wmi_resume_handler(struct device *device);
=20
@@ -446,7 +446,7 @@ static void cleanup_sysfs(struct platfor
 	device_remove_file(&device->dev, &dev_attr_tablet);
 }
=20
-static int __init hp_wmi_bios_setup(struct platform_device *device)
+static int __devinit hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
 	int wireless =3D hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
