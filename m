From: akpm@linux-foundation.org
Subject: + remove-linux-hardirqh-from-asm-generic-localh.patch added to -mm tree
Date: Sun, 14 Dec 2008 09:58:07 -0800
Message-ID: <200812141758.mBEHw7QD003494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYLNR6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 14 Dec 2008 12:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk


The patch titled
     remove linux/hardirq.h from asm-generic/local.h
has been added to the -mm tree.  Its filename is
     remove-linux-hardirqh-from-asm-generic-localh.patch

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
Subject: remove linux/hardirq.h from asm-generic/local.h
From: Russell King <rmk+kernel@arm.linux.org.uk>

While looking at reducing the amount of architecture namespace pollution
in the generic kernel, I found that asm/irq.h is included in the vast
majority of compilations on ARM (around 650 files.)

Since asm/irq.h includes a sub-architecture include file on ARM, this
causes a negative impact on the ccache's ability to re-use the build
results from other sub-architectures, so we have a desire to reduce the
dependencies on asm/irq.h.

It turns out that a major cause of this is the needless include of
linux/hardirq.h into asm-generic/local.h.  The patch below removes this
include, resulting in some 250 to 300 files (around half) of the kernel
then omitting asm/irq.h.

My test builds still succeed, provided two ARM files are fixed
(arch/arm/kernel/traps.c and arch/arm/mm/fault.c) - so there may be
negative impacts for this on other architectures.

Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
asm/local.h, so this patch can be viewed as bringing the generic version
into line with the x86 version.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/local.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-generic/local.h~remove-linux-hardirqh-from-asm-generic-localh include/asm-generic/local.h
--- a/include/asm-generic/local.h~remove-linux-hardirqh-from-asm-generic-localh
+++ a/include/asm-generic/local.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <asm/atomic.h>
 #include <asm/types.h>
 
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

linux-next.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
remove-linux-hardirqh-from-asm-generic-localh.patch

