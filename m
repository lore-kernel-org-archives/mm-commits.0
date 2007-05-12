From: akpm@linux-foundation.org
Subject: - documentation-gpiotxt-mentions-generic_gpio.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:37 -0700
Message-ID: <200705120532.l4C5WbrY002052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756928AbXELFct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Documentation/gpio.txt mentions GENERIC_GPIO
has been removed from the -mm tree.  Its filename was
     documentation-gpiotxt-mentions-generic_gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation/gpio.txt mentions GENERIC_GPIO
From: David Brownell <david-b@pacbell.net>

Documentation/gpio.txt should mention the Kconfig GENERIC_GPIO flag, for
platforms to declare when relevant.  This should help minimize goofs like
omitting it, or not depending on it when needed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/gpio.txt~documentation-gpiotxt-mentions-generic_gpio Documentation/gpio.txt
--- a/Documentation/gpio.txt~documentation-gpiotxt-mentions-generic_gpio
+++ a/Documentation/gpio.txt
@@ -66,7 +66,9 @@ registers; another might implement it by
 used for several very different kinds of GPIO controller.
 
 That said, if the convention is supported on their platform, drivers should
-use it when possible:
+use it when possible.  Platforms should declare GENERIC_GPIO support in
+Kconfig (boolean true), which multi-platform drivers can depend on when
+using the include file:
 
 	#include <asm/gpio.h>
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
use-menuconfig-objects-ii-rtc.patch
