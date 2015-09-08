From: akpm@linux-foundation.org
Subject: [merged] arc-add-negative-dependency-for-vga_console.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:28 -0700
Message-ID: <55ef2278.UDxSvt7db2jM3p/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuriy.kolerov@synopsys.com, geert@linux-m68k.org, jayalk@intworks.biz, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/concole: add negative dependency for VGA_CONSOLE on ARC
has been removed from the -mm tree.  Its filename was
     arc-add-negative-dependency-for-vga_console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuriy Kolerov <yuriy.kolerov@synopsys.com>
Subject: drivers/video/concole: add negative dependency for VGA_CONSOLE on ARC

Architectures which support VGA console must define screen_info
structurture from "uapi/linux/screen_info.h".  Otherwise undefined symbol
error occurs.  Usually it's defined in "setup.c" for each architecture.

If an architecture does not support VGA console (ARC's case) there are 2
ways: define a dummy instance of screen_info or add a negative dependency
for VGA_CONSOLE in to prevent selecting this option.

I've implemented the second way.  However the best solution is to add
HAVE_VGA_CONSOLE option for targets which support VGA console.  Then turn
off VGA_CONSOLE by default and add dependency to HAVE_VGA_CONSOLE.  But
right now it's better to just add a negative dependency for ARC and then
consider how to collaborate about this issue with maintainers of other
architectures.

Signed-off-by: Yuriy Kolerov <yuriy.kolerov@synopsys.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jaya Kumar <jayalk@intworks.biz>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/Kconfig~arc-add-negative-dependency-for-vga_console drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~arc-add-negative-dependency-for-vga_console
+++ a/drivers/video/console/Kconfig
@@ -9,7 +9,7 @@ config VGA_CONSOLE
 	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && \
 		!SUPERH && !BLACKFIN && !AVR32 && !MN10300 && !CRIS && \
 		(!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER) && \
-		!ARM64
+		!ARM64 && !ARC
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a
_

Patches currently in -mm which might be from yuriy.kolerov@synopsys.com are


