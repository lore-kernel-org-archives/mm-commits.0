From: akpm@linux-foundation.org
Subject: + lis3-update-documentation-to-match-latest-changes.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:03:11 -0800
Message-ID: <200912022303.nB2N3CtZ010704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbZLBXLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:11:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: update documentation to match latest changes
has been added to the -mm tree.  Its filename is
     lis3-update-documentation-to-match-latest-changes.patch

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
Subject: lis3: update documentation to match latest changes
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/lis3lv02d |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff -puN Documentation/hwmon/lis3lv02d~lis3-update-documentation-to-ma=
tch-latest-changes Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~lis3-update-documentation-to-match-=
latest-changes
+++ a/Documentation/hwmon/lis3lv02d
@@ -20,18 +20,35 @@ sporting the feature officially called "
 models (full list can be found in drivers/hwmon/hp_accel.c) will have =
their
 axis automatically oriented on standard way (eg: you can directly play
 neverball). The accelerometer data is readable via
-/sys/devices/platform/lis3lv02d.
+/sys/devices/platform/lis3lv02d. Reported values are scaled
+to mg values (1/1000th of earth gravity).
=20
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
 position - 3D position that the accelerometer reports. Format: "(x,y,z=
)"
-calibrate - read: values (x, y, z) that are used as the base for input
-		  class device operation.
-            write: forces the base to be recalibrated with the current
-		   position.
-rate - reports the sampling rate of the accelerometer device in HZ
+rate - read reports the sampling rate of the accelerometer device in H=
Z.
+	write changes sampling rate of the accelerometer device.
+	Only values which are supported by HW are accepted.
+selftest - performs selftest for the chip as specified by chip manufac=
turer.
=20
 This driver also provides an absolute input class device, allowing
-the laptop to act as a pinball machine-esque joystick.
+the laptop to act as a pinball machine-esque joystick. Joystick device=
 can be
+calibrated. Joystick device can be in two different modes.
+By default output values are scaled between -32768 .. 32767. In joysti=
ck raw
+mode, joystick and sysfs position entry have the same scale. There can=
 be
+small difference due to input system fuzziness feature.
+Events are also available as input event device.
+
+Selftest is meant only for hardware diagnostic purposes. It is not mea=
nt to be
+used during normal operations. Position data is not corrupted during s=
elftest
+but interrupt behaviour is not quaranteed to work reliably. In test mo=
de, the
+sensing element is internally moved little bit. Selftest measures diff=
erence
+between normal mode and test mode. Chip specifications tell the accept=
ance
+limit for each type of the chip. Limits are provided via platform data
+to allow adjustment of the limits without a change to the actual drive=
r.
+Seltest returns either "OK x y z" or "FAIL x y z" where x, y and z are
+measured difference between modes. Axes are not remapped in selftest m=
ode.
+Measurement values are provided to help HW diagnostic applications to =
make
+final decision.
=20
 On HP laptops, if the led infrastructure is activated, support for a l=
ed
 indicating disk protection will be provided as /sys/class/leds/hp::hdd=
protect.
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

linux-next.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
lis3lv02d-send-sync-event.patch
lis3lv02d-correct-memory-leak-in-module-unload.patch
lis3-update-documentation-and-comments.patch
lis3-fix-show-rate-for-8-bits-chips.patch
lis3lv02d-proper-power-on-sequence.patch
lis3-selftest-support.patch
lis3lv02d-remove-calibaration-functionality.patch
lis3-sysfs-entry-for-setting-chip-measurement-rate.patch
lis3-scale-output-values-to-mg.patch
lis3-update-documentation-to-match-latest-changes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
