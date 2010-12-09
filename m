From: akpm@linux-foundation.org
Subject: [merged] drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch removed from -mm tree
Date: Thu, 09 Dec 2010 11:38:49 -0800
Message-ID: <201012091940.oB9Jef3i002891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab0LITkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 14:40:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dma/: use the ccflag-y instead of EXTRA_CFLAGS
has been removed from the -mm tree.  Its filename was
     drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/: use the ccflag-y instead of EXTRA_CFLAGS
From: Tracey Dent <tdent48227@gmail.com>

Use the ccflag-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/Makefile~drivers-dma-use-the-ccflag-y-instead-of-extra_cflags drivers/dma/Makefile
--- a/drivers/dma/Makefile~drivers-dma-use-the-ccflag-y-instead-of-extra_cflags
+++ a/drivers/dma/Makefile
@@ -1,8 +1,8 @@
 ifeq ($(CONFIG_DMADEVICES_DEBUG),y)
-	EXTRA_CFLAGS	+= -DDEBUG
+	ccflags-y	+= -DDEBUG
 endif
 ifeq ($(CONFIG_DMADEVICES_VDEBUG),y)
-	EXTRA_CFLAGS	+= -DVERBOSE_DEBUG
+	ccflags-y	+= -DVERBOSE_DEBUG
 endif
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

