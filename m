From: akpm@linux-foundation.org
Subject: + avoid-ssb-compililation-on-s390.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:37:29 -0700
Message-ID: <200707270437.l6R4bTLh005593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbXG0Ei6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, linville@tuxdriver.com, mb@bu3sch.de, schwidefsky@de.ibm.com


The patch titled
     Avoid ssb compililation on s390
has been added to the -mm tree.  Its filename is
     avoid-ssb-compililation-on-s390.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid ssb compililation on s390
From: Heiko Carstens <heiko.carstens@de.ibm.com>

drivers/ssb/main.c: In function 'ssb_ssb_read16':
drivers/ssb/main.c:444: error: implicit declaration of function 'readw'
drivers/ssb/main.c: In function 'ssb_ssb_read32':
drivers/ssb/main.c:452: error: implicit declaration of function 'readl'
drivers/ssb/main.c: In function 'ssb_ssb_write16':
drivers/ssb/main.c:460: error: implicit declaration of function 'writew'
drivers/ssb/main.c: In function 'ssb_ssb_write32':
drivers/ssb/main.c:468: error: implicit declaration of function 'writel'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ssb/Kconfig~avoid-ssb-compililation-on-s390 drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig~avoid-ssb-compililation-on-s390
+++ a/drivers/ssb/Kconfig
@@ -2,7 +2,7 @@ menu "Sonics Silicon Backplane"
 
 config SSB
 	tristate "Sonics Silicon Backplane support"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && HAS_IOMEM
 	help
 	  Support for the Sonics Silicon Backplane bus
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

git-s390.patch
avoid-ssb-compililation-on-s390.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
