From: akpm@linux-foundation.org
Subject: [merged] lis3-update-documentation-to-match-latest-changes.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:42 -0800
Message-ID: <200912152159.nBFLxgQH015926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933854AbZLOWAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lis3: update documentation to match latest changes
has been removed from the -mm tree.  Its filename was
     lis3-update-documentation-to-match-latest-changes.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: update documentation to match latest changes
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

[akpm@linux-foundation.org: s/q/g/ (Randy)]
Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
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
+but interrupt behaviour is not guaranteed to work reliably. In test mo=
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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
