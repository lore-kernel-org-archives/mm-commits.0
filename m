From: akpm@linux-foundation.org
Subject: [to-be-updated] lis3-add-missing-constants-for-8bit-device.patch removed from -mm tree
Date: Fri, 05 Mar 2010 11:56:04 -0800
Message-ID: <201003051956.o25Ju4aq024345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab0CET4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 14:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: add missing constants for 8bit device
has been removed from the -mm tree.  Its filename was
     lis3-add-missing-constants-for-8bit-device.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: add missing constants for 8bit device
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Lis3 accelerometer chip family changes for power management, click and
threshold event handling.

Patch set adds interrupt handlers for click/tap events and threshold based
events.  Actual configuration which events are enabled is done via
platform data.  All the features cannot be used in parallel.  Interrupts
are implemented only for 8 bit device, since I'm not familiar with other
devices and I don't have suitable testing environment.

Changes:

lis3: Add missing constants for 8bit device This is quite clear.  Some
click feature related register definitions were missing.

lis3: Separate configuration function for 8 bit device Move platformdata
based configurations for 8 bit device to separate function to keep common
part little bit more readable.

lis3: Introduce platform data for second ff / wu unit 8 bit device has two
freefall / wakeup detection blocks.  Add possibility to configure also the
second unit.  Change hipass filter configuration to platform data.  Change
is compatible with existing platform data.

lis3: Power control for the chip This kind of feature has been in the
driver earlier.  It was removed because saving was so small in laptop
environment.  However, in smaller devices, even a small saving need to be
implemented.  When driver detects that no-one is really interested about
the acceleration, chip is powered down.  Input device, freefall device and
sysfs are controlling this.  By default, chip is powered on to keep
functionality similar to current implementation.

lis3: Add skeletons for interrupt handlers Interrupt handlers are added in
two patches to keep changes cleaner.  This first patch adds two dummy
threaded interrupt handlers for 8 bit device.  

lis3: Interrupt handlers for 8bit wakeup and click events This patch adds
content to dummy handlers.  Depending on the chip configuration, either
click or ff/wu handling is called.  For click event, BTN input event is
sent separately for each axes.  For threshold event, coordinates are
updated immediatelly to input device.  This allows input device to be used
either in polled mode and / or interrupt driven mode.  Polling can stopped
from userspace by via input device sysfs.



This patch:

Definitions for click were missing.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-missing-constants-for-8bit-device drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-missing-constants-for-8bit-device
+++ a/drivers/hwmon/lis3lv02d.h
@@ -196,6 +196,16 @@ enum lis3lv02d_dd_src {
 	DD_SRC_IA	= 0x40,
 };
 
+enum lis3lv02d_click_src_8b {
+	CLICK_SINGLE_X	= 0x01,
+	CLICK_DOUBLE_X	= 0x02,
+	CLICK_SINGLE_Y	= 0x04,
+	CLICK_DOUBLE_Y	= 0x08,
+	CLICK_SINGLE_Z	= 0x10,
+	CLICK_DOUBLE_Z	= 0x20,
+	CLICK_IA	= 0x40,
+};
+
 struct axis_conversion {
 	s8	x;
 	s8	y;
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-power-control-for-the-chip.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch

