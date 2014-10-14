From: akpm@linux-foundation.org
Subject: + cma-make-default-cma-area-size-zero-for-x86.patch added to -mm
 tree
Date: Tue, 14 Oct 2014 16:20:58 -0700
Message-ID: <543dafda.CGQSADX8T/Xh1tPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaJNXU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 19:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, andi@firstfloor.org, cebbert.lkml@gmail.com, ddutile@redhat.com, dwmw2@infradead.org, hpa@zytor.com, jdelvare@suse.de, konrad.wilk@oracle.com, m.szyprowski@samsung.com, mingo@redhat.com, peter@hurleysoftware.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: make default CMA area size zero for x86
has been added to the -mm tree.  Its filename is
     cma-make-default-cma-area-size-zero-for-x86.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-make-default-cma-area-size-zero-for-x86.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-make-default-cma-area-size-zero-for-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cma: make default CMA area size zero for x86

This makes CMA memory area size zero for x86 in default configuration
(doesn't change on the other architectures).  If default CMA size is zero,
DMA_CMA is disabled.  It can be enabled by passing cma= to the kernel.

This makes less impact on x86.  Because there is no mainline driver that
requires it for x86, and Peter Hurley reported the performance regression,
as this is trying to drive _all_ dma mapping allocations through a _very_
small window.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/base/Kconfig~cma-make-default-cma-area-size-zero-for-x86 drivers/base/Kconfig
--- a/drivers/base/Kconfig~cma-make-default-cma-area-size-zero-for-x86
+++ a/drivers/base/Kconfig
@@ -264,18 +264,24 @@ comment "Default contiguous memory area
 config CMA_SIZE_MBYTES
 	int "Size in Mega Bytes"
 	depends on !CMA_SIZE_SEL_PERCENTAGE
+	default 0 if X86
 	default 16
 	help
 	  Defines the size (in MiB) of the default memory area for Contiguous
-	  Memory Allocator.
+	  Memory Allocator.  If the size of 0 is selected, CMA is disabled by
+	  default, but it can be enabled by passing cma=size[MG] to the kernel.
+
 
 config CMA_SIZE_PERCENTAGE
 	int "Percentage of total memory"
 	depends on !CMA_SIZE_SEL_MBYTES
+	default 0 if X86
 	default 10
 	help
 	  Defines the size of the default memory area for Contiguous Memory
 	  Allocator as a percentage of the total memory in the system.
+	  If 0 percent is selected, CMA is disabled by default, but it can be
+	  enabled by passing cma=size[MG] to the kernel.
 
 choice
 	prompt "Selected region size"
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
cma-make-default-cma-area-size-zero-for-x86.patch
linux-next.patch

