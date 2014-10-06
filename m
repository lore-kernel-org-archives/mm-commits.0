From: akpm@linux-foundation.org
Subject: + cma-document-cma=0.patch added to -mm tree
Date: Mon, 06 Oct 2014 11:23:59 -0700
Message-ID: <5432de3f.x3cbVDy0z2fnQALV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaJFSYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Oct 2014 14:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, akinobu.mita@gmail.com, cebbert.lkml@gmail.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: document cma=0
has been added to the -mm tree.  Its filename is
     cma-document-cma=0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-document-cma=0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-document-cma=0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: CMA: document cma=0

It isn't obvious that CMA can be disabled on the kernel's command line, so
document it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ++-
 drivers/base/Kconfig                |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~cma-document-cma=0 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cma-document-cma=0
+++ a/Documentation/kernel-parameters.txt
@@ -656,7 +656,8 @@ bytes respectively. Such letter suffixes
 			Sets the size of kernel global memory area for
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
-			memory allocations. For more information, see
+			memory allocations. A value of 0 disables CMA
+			altogether. For more information, see
 			include/linux/dma-contiguous.h
 
 	cmo_free_hint=	[PPC] Format: { yes | no }
diff -puN drivers/base/Kconfig~cma-document-cma=0 drivers/base/Kconfig
--- a/drivers/base/Kconfig~cma-document-cma=0
+++ a/drivers/base/Kconfig
@@ -231,6 +231,9 @@ config DMA_CMA
 	  to allocate big physically-contiguous blocks of memory for use with
 	  hardware components that do not support I/O map nor scatter-gather.
 
+	  You can disable CMA by specifying "cma=0" on the kernel's command
+	  line.
+
 	  For more information see <include/linux/dma-contiguous.h>.
 	  If unsure, say "n".
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

cma-document-cma=0.patch
linux-next.patch

