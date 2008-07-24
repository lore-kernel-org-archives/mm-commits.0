From: akpm@linux-foundation.org
Subject: - tridentfb-use-mmio-access-for-clock-setting.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:57 -0700
Message-ID: <200807242330.m6ONUvRr011565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756528AbYGXXa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: use mmio access for clock setting
has been removed from the -mm tree.  Its filename was
     tridentfb-use-mmio-access-for-clock-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: use mmio access for clock setting
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the mmio outb function instead of direct one.  The mmio registers are
already mapped (in the probe function).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-use-mmio-access-for-clock-setting drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-use-mmio-access-for-clock-setting
+++ a/drivers/video/tridentfb.c
@@ -680,8 +680,8 @@ static void set_vclk(struct tridentfb_pa
 		vga_mm_wseq(par->io_virt, ClockHigh, hi);
 		vga_mm_wseq(par->io_virt, ClockLow, lo);
 	} else {
-		outb(lo, 0x43C8);
-		outb(hi, 0x43C9);
+		t_outb(par, lo, 0x43C8);
+		t_outb(par, hi, 0x43C9);
 	}
 	debug("VCLK = %X %X\n", hi, lo);
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

