From: akpm@linux-foundation.org
Subject: [merged] sdhci-protect-header-file-against-multi-inclusion.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:42 -0800
Message-ID: <200912182026.nBIKQgwa016548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZLRU0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdhci: protect header file against multi inclusion
has been removed from the -mm tree.  Its filename was
     sdhci-protect-header-file-against-multi-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sdio-recognize-io-card-without-powercycle.patch

