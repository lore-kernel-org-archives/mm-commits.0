From: akpm@linux-foundation.org
Subject: - genrtc-disable-genrtc-on-blackfin-systems.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:49 -0800
Message-ID: <200901072218.n07MIn6b018241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839AbZAGWT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     genrtc: disable genrtc on Blackfin systems
has been removed from the -mm tree.  Its filename was
     genrtc-disable-genrtc-on-blackfin-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genrtc: disable genrtc on Blackfin systems
From: Mike Frysinger <vapier.adi@gmail.com>

Blackfin platforms do not support the hardware which this driver drives.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~genrtc-disable-genrtc-on-blackfin-systems drivers/char/Kconfig
--- a/drivers/char/Kconfig~genrtc-disable-genrtc-on-blackfin-systems
+++ a/drivers/char/Kconfig
@@ -841,7 +841,7 @@ config JS_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

