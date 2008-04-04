From: akpm@linux-foundation.org
Subject: - watchdog-it8712f_wdt-zero-msb-timeout-byte-when-disabling-watchdog.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:44 -0700
Message-ID: <200804041900.m34J0iIp004291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYDDTA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@ishiboo.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: it8712f_wdt: zero MSB timeout byte when disabling watchdog
has been removed from the -mm tree.  Its filename was
     watchdog-it8712f_wdt-zero-msb-timeout-byte-when-disabling-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: it8712f_wdt: zero MSB timeout byte when disabling watchdog
From: "Andrew Paprocki" <andrew@ishiboo.com>

I noticed this while testing the latest code.  I'm not sure if it is required,
but the normal (or LSB) timeout value is set to zero, so the MSB should be as
well to stay consistent.

If the chip revision is >= 8, set MSB of the 16-bit timeout value to zero when
disabling the watchdog in it8712f_wdt_disable().

Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/it8712f_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/watchdog/it8712f_wdt.c~watchdog-it8712f_wdt-zero-msb-timeout-byte-when-disabling-watchdog drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c~watchdog-it8712f_wdt-zero-msb-timeout-byte-when-disabling-watchdog
+++ a/drivers/watchdog/it8712f_wdt.c
@@ -210,6 +210,8 @@ it8712f_wdt_disable(void)
 
 	superio_outb(0, WDT_CONFIG);
 	superio_outb(0, WDT_CONTROL);
+	if (revision >= 0x08)
+		superio_outb(0, WDT_TIMEOUT + 1);
 	superio_outb(0, WDT_TIMEOUT);
 
 	superio_exit();
_

Patches currently in -mm which might be from andrew@ishiboo.com are

git-watchdog.patch

