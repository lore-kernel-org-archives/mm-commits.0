From: akpm@linux-foundation.org
Subject: + arc-add-negative-dependency-for-vga_console.patch added to -mm
 tree
Date: Mon, 17 Aug 2015 13:25:58 -0700
Message-ID: <55d24356.sFBmgOGrdyjTAviW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbbHQUZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuriy.kolerov@synopsys.com, geert@linux-m68k.org, jayalk@intworks.biz, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/concole: add negative dependency for VGA_CONSOLE on ARC
has been added to the -mm tree.  Its filename is
     arc-add-negative-dependency-for-vga_console.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-add-negative-dependency-for-vga_console.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-add-negative-dependency-for-vga_console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arc-add-negative-dependency-for-vga_console.patch

