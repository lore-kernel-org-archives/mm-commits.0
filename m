From: akpm@linux-foundation.org
Subject: + drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch added to -mm tree
Date: Tue, 26 May 2009 13:31:53 -0700
Message-ID: <200905262031.n4QKVrU7013243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbZEZUcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 16:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it, david-b@pacbell.net, hch@lst.de, lethal@linux-sh.org


The patch titled
     drivers/char/rtc: disable legacy RTC driver on Blackfin systems
has been added to the -mm tree.  Its filename is
     drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -794,7 +794,7 @@ if RTC_LIB=n
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

linux-next.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch

