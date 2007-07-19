From: akpm@linux-foundation.org
Subject: - gpio-calls-dont-need-i-o-barriers.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:51 -0700
Message-ID: <200707192000.l6JK0p80019480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760946AbXGSUSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio calls don't need i/o barriers
has been removed from the -mm tree.  Its filename was
     gpio-calls-dont-need-i-o-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gpio calls don't need i/o barriers
From: David Brownell <david-b@pacbell.net>

Clarify that drivers using the GPIO operations don't need to issue io
barrier instructions themselves.  Previously this wasn't clear, and at
least one platform assumed otherwise (and would thus break various
otherwise-portable drivers which don't issue barriers).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/gpio.txt~gpio-calls-dont-need-i-o-barriers Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-calls-dont-need-i-o-barriers
+++ a/Documentation/gpio.txt
@@ -75,6 +75,9 @@ using the include file:
 If you stick to this convention then it'll be easier for other developers to
 see what your code is doing, and help maintain it.
 
+Note that these operations include I/O barriers on platforms which need to
+use them; drivers don't need to add them explicitly.
+
 
 Identifying GPIOs
 -----------------
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
