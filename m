From: akpm@linux-foundation.org
Subject: - maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:21 -0800
Message-ID: <200802082018.m18KI2ub010889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbYBHUu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add Haavard as maintainer of the atmel_serial driver
has been removed from the -mm tree.  Its filename was
     maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add Haavard as maintainer of the atmel_serial driver
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

The following patchset cleans up the atmel_serial driver a bit, moves a
significant portion of the interrupt handler into a tasklet, and adds DMA
support.  This is the result of a combined effort by Chip Coldwell, Remy
Bohmer and me.  The patches should apply cleanly onto Linus' latest git tree,
and I've also tested it on -mm (with a couple of avr32 fixes applied to make
the rest of the tree compile.)

With DMA, I see transfer rates around 92 kbps when transferring a big file
using ZModem (both directions are roughly the same.) I've also tested the same
thing with a bunch of debug options enabled.  The transfer rate is slightly
lower, but no errors are reported.

Note that break and error handling doesn't work too well with DMA enabled. 
This is a common problem with all the efforts I've seen adding DMA support to
this driver (including my own).  The PDC error handling also accesses icount
without locking.  I'm tempted to just ignore the problem for now and hopefully
come up with a solution later.


This patch:

The atmel_serial driver never had a MAINTAINERS entry, although Andrew Victor
has effectively been acting as a maintainer since he got the driver merged
into mainline in the first place.

I'll keep Cc'ing Andrew on all patches, but I'm going to take the main
responsibility for getting things moving upstream from now on.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver
+++ a/MAINTAINERS
@@ -688,6 +688,12 @@ W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
 
+ATMEL AT91 / AT32 SERIAL DRIVER
+P:	Haavard Skinnemoen
+M:	hskinnemoen@atmel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 ATMEL LCDFB DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@atmel.com
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
