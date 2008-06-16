From: akpm@linux-foundation.org
Subject: - rtc-make-hpet_rtc_irq-track-hpet_emulate_rtc.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:12 -0700
Message-ID: <200806160604.m5G64Cog010666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbYFPGEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, maximlevitsky@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: make HPET_RTC_IRQ track HPET_EMULATE_RTC
has been removed from the -mm tree.  Its filename was
     rtc-make-hpet_rtc_irq-track-hpet_emulate_rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: make HPET_RTC_IRQ track HPET_EMULATE_RTC
From: David Brownell <dbrownell@users.sourceforge.net>

More Kconfig tweaks related to the legacy PC RTC code:

 - Describe the legacy PC RTC driver as such ... it's never quite
   been clear that this driver is for PC RTCs, and now it's fair
   to call this the "legacy" driver.

 - Force it to understand about HPET stealing its IRQs ... kernel
   code does this always when HPET is in use, there should be no
   option for users to goof up the config.

This seems to fix kernel bugzilla #10729.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/Kconfig~rtc-make-hpet_rtc_irq-track-hpet_emulate_rtc drivers/char/Kconfig
--- a/drivers/char/Kconfig~rtc-make-hpet_rtc_irq-track-hpet_emulate_rtc
+++ a/drivers/char/Kconfig
@@ -749,7 +749,7 @@ config NVRAM
 if RTC_LIB=n
 
 config RTC
-	tristate "Enhanced Real Time Clock Support"
+	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
 			&& !ARM && !SUPERH && !S390 && !AVR32
 	---help---
@@ -1036,9 +1036,9 @@ config HPET
 	  non-periodic and/or periodic.
 
 config HPET_RTC_IRQ
-	bool "HPET Control RTC IRQ" if !HPET_EMULATE_RTC
-	default n
-	depends on HPET
+	bool
+	default HPET_EMULATE_RTC
+	depends on RTC && HPET
 	help
 	  If you say Y here, you will disable RTC_IRQ in drivers/char/rtc.c. It
 	  is assumed the platform called hpet_alloc with the RTC IRQ values for
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
gpio-sysfs-interface-updated.patch

