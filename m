From: akpm@linux-foundation.org
Subject: + input-documentation-abi-testing-game_device-sysfs-interface-document-game_device-interface-added-to-xpad-driver.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:45:37 -0800
Message-ID: <200903042145.n24LjcrX006197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756976AbZCDVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mamurph@cs.clemson.edu, dtor@mail.ru


The patch titled
     input: Documentation/ABI/testing/game_device-sysfs-interface: document game_device interface added to xpad driver
has been added to the -mm tree.  Its filename is
     input-documentation-abi-testing-game_device-sysfs-interface-document-game_device-interface-added-to-xpad-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: Documentation/ABI/testing/game_device-sysfs-interface: document game_device interface added to xpad driver
From: Mike Murphy <mamurph@cs.clemson.edu>

Add documentation for the game_device sysfs interface that was added
to the xpad driver in this patchset.

Signed-off-by: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/game_device-sysfs-interface |   86 ++++++++++
 1 file changed, 86 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/game_device-sysfs-interface
--- /dev/null
+++ a/Documentation/ABI/testing/game_device-sysfs-interface
@@ -0,0 +1,86 @@
+What:		/sys/class/input/inputXX/game_device
+		(exact location depends on kernel and userspace rules)
+Date:		February 2009
+KernelVersion:	2.6.28
+Contact:	Mike Murphy <mamurph@cs.clemson.edu>
+Description:	The game_device subdirectory provides a mechanism for gaming
+		devices, such as joysticks and gamepads, to report information
+		and allow changes to calibration and behavior. The name of
+		this directory SHOULD be game_device for all drivers that
+		support it, and those drivers SHOULD have ABI documentation
+		in this file. However, the exact contents of the directory
+		MAY vary by device type, so that devices can expose whatever
+		properties and settings are appropriate for the hardware
+		and/or driver software.
+
+
+What:		game_device interface for the xpad driver
+		(drivers/input/joystick/xpad.c)
+Date:		February 2009
+KernelVersion:	2.6.28
+Contact:	Mike Murphy <mamurph@cs.clemson.edu>
+Description:	The game_device subdirectory for the Xbox/360 controller
+		driver provides the following files for retrieving information
+		and setting properties:
+
+		left_dead_zone			uint, read/write
+		right_dead_zone			uint, read/write
+
+			Set the size of the analog stick dead zones for the
+			left and right sticks, respectively. Minimum value
+			0, default 8192, maximum 31743 (or 1024 less than
+			the stick_limit for the corresponding stick).
+
+		left_stick_limit		uint, read/write
+		right_stick_limit		uint, read/write
+
+			Set the square-axis limits of the analog left and
+			right sticks, respectively. Minimum value 1024,
+			default 32767, maximum 32767. The minimum is
+			constrained to be the size of the dead zone plus
+			1024. See Documentation/input/xpad.txt for more
+			information.
+
+		rumble_enable			bool, read/write
+
+			Enable or disable the controller's rumble effect.
+			Default 1 (enabled).
+
+		left_trigger_full_axis		bool, read/write
+		right_trigger_full_axis		bool, read/write
+
+			Enable or disable use of a full axis (-32767 to
+			+32767) for each of the left and right triggers,
+			respectively. Default 0 (disabled: use a half axis
+			from 0 to +32767).
+
+		controller_number		uint, read-only
+
+			Controller slot number (1-4) for a wireless Xbox
+			360 gaming receiver. This value will be zero for all
+			wired devices.
+
+		controller_present		bool, read-only
+
+			Controller presence indicator for a wireless Xbox
+			360 gaming receiver. Has the value 1 whenever the
+			controller is turned on and connected to the receiver
+			slot corresponding to the input device. This value
+			will always be 1 for all wired devices.
+
+		controller_type			uint, read-only
+
+			Type of controller that is connected:
+
+			0	No controller connected
+			1	Pad
+			2	Guitar
+			3	Dance pad
+			255	Other/unknown type
+
+		id				string [17], read-only
+
+			16-character (plus NUL byte) presumably unique
+			identifier for each connected WIRELESS controller.
+			Presently, this value is an empty string for all
+			wired devices.
_

Patches currently in -mm which might be from mamurph@cs.clemson.edu are

input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
input-documentation-abi-testing-game_device-sysfs-interface-document-game_device-interface-added-to-xpad-driver.patch

