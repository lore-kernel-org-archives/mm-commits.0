From: akpm@linux-foundation.org
Subject: + arch-powerpc-include-asm-fsldmah-needs-slabh.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:40:43 -0700
Message-ID: <201009032340.o83NehWF019368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab0ICXks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iws@ovro.caltech.edu, benh@kernel.crashing.org, dan.j.williams@intel.com


The patch titled
     arch/powerpc/include/asm/fsldma.h needs slab.h
has been added to the -mm tree.  Its filename is
     arch-powerpc-include-asm-fsldmah-needs-slabh.patch

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
Subject: arch/powerpc/include/asm/fsldma.h needs slab.h
From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The slab.h header is required to use the kmalloc() family of functions. 
Due to recent kernel changes, this header must be directly included by
code that calls into the memory allocator.

Without this patch, any code which includes this header fails to build.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fsldma.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/include/asm/fsldma.h~arch-powerpc-include-asm-fsldmah-needs-slabh arch/powerpc/include/asm/fsldma.h
--- a/arch/powerpc/include/asm/fsldma.h~arch-powerpc-include-asm-fsldmah-needs-slabh
+++ a/arch/powerpc/include/asm/fsldma.h
@@ -11,6 +11,7 @@
 #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
 #define __ARCH_POWERPC_ASM_FSLDMA_H__
 
+#include <linux/slab.h>
 #include <linux/dmaengine.h>
 
 /*
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

linux-next.patch
arch-powerpc-include-asm-fsldmah-needs-slabh.patch
kfifo-fix-scatterlist-usage.patch

