From: akpm@linux-foundation.org
Subject: [merged] rtc-disable-rtc_drv_cmos-on-atari.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:46 -0800
Message-ID: <52e2b8d6.HRKai450QUup7cNa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbaAXTCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, geert@linux-m68k.org

Subject: [merged] rtc-disable-rtc_drv_cmos-on-atari.patch removed from -mm tree
To: geert@linux-m68k.org,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:46 -0800


The patch titled
     Subject: drivers/rtc/Kconfig: disable RTC_DRV_CMOS on Atari
has been removed from the -mm tree.  Its filename was
     rtc-disable-rtc_drv_cmos-on-atari.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/rtc/Kconfig: disable RTC_DRV_CMOS on Atari

On ARAnyM (emulating an Atari Falcon, which doesn't have an RTC IRQ, as
the Second Multi Function Peripheral MFP 68901 is available on Atari TT
only), rtc-cmos doesn't work well:

  - The date is of by 32 years (2045 instead of 2013):

    rtc_cmos rtc_cmos: setting system clock to 2045-12-02 10:56:17 UTC
    (2395824977)

  - The hwclock utility doesn't work:

    hwclock: ioctl() to /dev/rtc to turn on update interrupts failed
    unexpectedly, errno=5: Input/output error.

As rtc-generic works fine for the RTC part, and nvram works for the NVRAM
part, we'll continue on using that.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-disable-rtc_drv_cmos-on-atari drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-disable-rtc_drv_cmos-on-atari
+++ a/drivers/rtc/Kconfig
@@ -637,7 +637,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ARM || M32R || ATARI || PPC || MIPS || SPARC64
+	depends on X86 || ARM || M32R || PPC || MIPS || SPARC64
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

