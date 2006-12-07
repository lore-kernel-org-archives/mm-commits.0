From: akpm@osdl.org
Subject: - s2ram-debugging-documentation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:53 -0800
Message-ID: <200612072259.kB7MxrNN029559@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163703AbWLGXAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     s2ram debugging documentation
has been removed from the -mm tree.  Its filename was
     s2ram-debugging-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s2ram debugging documentation
From: Pavel Machek <pavel@ucw.cz>

Linus posted quite nice TRACE_RESUME how-to, and I think it is too nice to
be hidden in archives of mailing list, so I turned it into Documentation
piece.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/power/s2ram.txt |   56 ++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff -puN /dev/null Documentation/power/s2ram.txt
--- /dev/null
+++ a/Documentation/power/s2ram.txt
@@ -0,0 +1,56 @@
+			How to get s2ram working
+			~~~~~~~~~~~~~~~~~~~~~~~~
+			2006 Linus Torvalds
+			2006 Pavel Machek
+
+1) Check suspend.sf.net, program s2ram there has long whitelist of
+   "known ok" machines, along with tricks to use on each one.
+
+2) If that does not help, try reading tricks.txt and
+   video.txt. Perhaps problem is as simple as broken module, and
+   simple module unload can fix it.
+
+3) You can use Linus' TRACE_RESUME infrastructure, described below.
+
+		      Using TRACE_RESUME
+		      ~~~~~~~~~~~~~~~~~~
+
+I've been working at making the machines I have able to STR, and almost
+always it's a driver that is buggy. Thank God for the suspend/resume
+debugging - the thing that Chuck tried to disable. That's often the _only_
+way to debug these things, and it's actually pretty powerful (but
+time-consuming - having to insert TRACE_RESUME() markers into the device
+driver that doesn't resume and recompile and reboot).
+
+Anyway, the way to debug this for people who are interested (have a
+machine that doesn't boot) is:
+
+ - enable PM_DEBUG, and PM_TRACE
+
+ - use a script like this:
+
+	#!/bin/sh
+	sync
+	echo 1 > /sys/power/pm_trace
+	echo mem > /sys/power/state
+
+   to suspend
+
+ - if it doesn't come back up (which is usually the problem), reboot by
+   holding the power button down, and look at the dmesg output for things
+   like
+
+	Magic number: 4:156:725
+	hash matches drivers/base/power/resume.c:28
+	hash matches device 0000:01:00.0
+
+   which means that the last trace event was just before trying to resume
+   device 0000:01:00.0. Then figure out what driver is controlling that
+   device (lspci and /sys/devices/pci* is your friend), and see if you can
+   fix it, disable it, or trace into its resume function.
+
+For example, the above happens to be the VGA device on my EVO, which I
+used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
+that "radeonfb" simply cannot resume that device - it tries to set the
+PLL's, and it just _hangs_. Using the regular VGA console and letting X
+resume it instead works fine.
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-acpi.patch
backlight-do-not-power-off-backlight-when-unregistering-try-3.patch

