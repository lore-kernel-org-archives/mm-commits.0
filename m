From: akpm@linux-foundation.org
Subject: [merged] drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:30 -0700
Message-ID: <200906182244.n5IMiUdU003601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758931AbZFRWom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.zummo@towertech.it, david-b@pacbell.net, hch@lst.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rtc: disable legacy RTC driver on Blackfin systems
has been removed from the -mm tree.  Its filename was
     drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc: disable legacy RTC driver on Blackfin systems
From: Mike Frysinger <vapier@gentoo.org>

Blackfin platforms do not support the hardware which this driver drives.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems drivers/char/Kconfig
--- a/drivers/char/Kconfig~drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems
+++ a/drivers/char/Kconfig
@@ -807,7 +807,7 @@ if RTC_LIB=n
 config RTC
 	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 && !AVR32
+			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
istallion-add-missing-__devexit-marking.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch

