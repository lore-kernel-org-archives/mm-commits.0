From: akpm@linux-foundation.org
Subject: + sdhci-protect-header-file-against-multi-inclusion.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:47:56 -0800
Message-ID: <200912162247.nBGMluSF019637__6352.35163285888$1261003719$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762640AbZLPWr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:47:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org


The patch titled
     sdhci: protect header file against multi inclusion
has been added to the -mm tree.  Its filename is
     sdhci-protect-header-file-against-multi-inclusion.patch

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
Subject: sdhci: protect header file against multi inclusion
From: Albert Herranz <albert_herranz@yahoo.es>

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/mmc/host/sdhci.h~sdhci-protect-header-file-against-multi-inclusion drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-protect-header-file-against-multi-inclusion
+++ a/drivers/mmc/host/sdhci.h
@@ -8,6 +8,8 @@
  * the Free Software Foundation; either version 2 of the License, or (at
  * your option) any later version.
  */
+#ifndef __SDHCI_H
+#define __SDHCI_H
 
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
@@ -408,3 +410,5 @@ extern void sdhci_remove_host(struct sdh
 extern int sdhci_suspend_host(struct sdhci_host *host, pm_message_t state);
 extern int sdhci_resume_host(struct sdhci_host *host);
 #endif
+
+#endif /* __SDHCI_H */
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

origin.patch
linux-next.patch
sdhci-protect-header-file-against-multi-inclusion.patch
sdhci-of-rename-main-driver-file-prior-to-reorganization.patch
sdhci-of-reorganize-driver-to-support-additional-hardware.patch
sdhci-of-add-support-for-the-wii-sdhci-controller.patch
sdio-recognize-io-card-without-powercycle.patch

