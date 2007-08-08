From: akpm@linux-foundation.org
Subject: - avoid-ssb-compililation-on-s390.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:10 -0700
Message-ID: <200708082359.l78Nx1HO005044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763155AbXHIAAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 20:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, linville@tuxdriver.com, mb@bu3sch.de, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Avoid ssb compililation on s390
has been removed from the -mm tree.  Its filename was
     avoid-ssb-compililation-on-s390.patch

This patch was dropped because an updated version will be merged

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

slow-down-printk-during-boot-fix-4.patch
git-s390.patch
git-wireless.patch
avoid-ssb-compililation-on-s390.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
