From: akpm@linux-foundation.org
Subject: + drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:02:07 -0800
Message-ID: <201011082202.oA8M27L9012048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0KHWCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, dan.j.williams@intel.com


The patch titled
     drivers/dma/: use the ccflag-y instead of EXTRA_CFLAGS
has been added to the -mm tree.  Its filename is
     drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch

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

drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

