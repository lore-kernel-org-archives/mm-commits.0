From: akpm@linux-foundation.org
Subject: + maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:45 -0800
Message-ID: <200801270517.m0R5HgO7031141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYA0FRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     MAINTAINERS: add Haavard as maintainer of the atmel_serial driver
has been added to the -mm tree.  Its filename is
     maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -670,6 +670,12 @@ W:	http://www.atmel.com/products/AT91/
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

git-avr32.patch
fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
git-mtd.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
add-have_oprofile.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
