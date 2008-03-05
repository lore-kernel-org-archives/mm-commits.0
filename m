From: akpm@linux-foundation.org
Subject: + ehea-fix-missing-kconfig-dependency.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:02:30 -0800
Message-ID: <200803052202.m25M2Utb023313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbYCEWDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, jeff@garzik.org, raisch@de.ibm.com, stefan.roscher@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: fix missing Kconfig dependency
has been added to the -mm tree.  Its filename is
     ehea-fix-missing-kconfig-dependency.patch

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
Subject: ehea: fix missing Kconfig dependency
From: Thomas Klein <osstklei@de.ibm.com>

Fixed Kconfig: ehea driver requires sparse mem

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: "Jan-Bernd Themann" <themann@de.ibm.com>
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~ehea-fix-missing-kconfig-dependency drivers/net/Kconfig
--- a/drivers/net/Kconfig~ehea-fix-missing-kconfig-dependency
+++ a/drivers/net/Kconfig
@@ -2520,7 +2520,7 @@ config CHELSIO_T3
 
 config EHEA
 	tristate "eHEA Ethernet support"
-	depends on IBMEBUS && INET
+	depends on IBMEBUS && INET && SPARSEMEM
 	select INET_LRO
 	---help---
 	  This driver supports the IBM pSeries eHEA ethernet adapter.
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fix-missing-kconfig-dependency.patch

