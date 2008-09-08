From: akpm@linux-foundation.org
Subject: + ehea-enable-dlpar-memory-remove.patch added to -mm tree
Date: Mon, 08 Sep 2008 15:25:58 -0700
Message-ID: <200809082225.m88MPwKC013386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbYIHW1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 18:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes.hering@gmx.de, hering2@de.ibm.com


The patch titled
     ehea: enable DLPAR memory remove
has been added to the -mm tree.  Its filename is
     ehea-enable-dlpar-memory-remove.patch

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
Subject: ehea: enable DLPAR memory remove
From: Hannes Hering <hannes.hering@gmx.de>

Add the capability flag to the capability list for dynamic LPAR memory
remove to enable this feature.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-enable-dlpar-memory-remove drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-enable-dlpar-memory-remove
+++ a/drivers/net/ehea/ehea.h
@@ -40,13 +40,13 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0092"
+#define DRV_VERSION	"EHEA_0093"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
 #define DLPAR_MEM_ADD      2
 #define DLPAR_MEM_REM      4
-#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD)
+#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD | DLPAR_MEM_REM)
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
_

Patches currently in -mm which might be from hannes.hering@gmx.de are

ehea-fix-dlpar-memory-handling.patch
ehea-enable-dlpar-memory-remove.patch

