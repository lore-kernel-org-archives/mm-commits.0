From: akpm@linux-foundation.org
Subject: [merged] frv-remove-wrapper-header-for-asm-deviceh.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:41 -0700
Message-ID: <20170711192541.loOcAg4R5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbdGKTZm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org, tklauser@distanz.ch


The patch titled
     Subject: frv: remove wrapper header for asm/device.h
has been removed from the -mm tree.  Its filename was
     frv-remove-wrapper-header-for-asm-deviceh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: frv: remove wrapper header for asm/device.h

frv's asm/device.h is merely including asm-generic/device.h.  Thus, the
arch specific header can be omitted and the generic header can be used
directly.

Link: http://lkml.kernel.org/r/20170517124915.26904-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/Kbuild   |    1 +
 arch/frv/include/asm/device.h |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/frv/include/asm/Kbuild~frv-remove-wrapper-header-for-asm-deviceh arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~frv-remove-wrapper-header-for-asm-deviceh
+++ a/arch/frv/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
 generic-y += irq_work.h
diff -puN arch/frv/include/asm/device.h~frv-remove-wrapper-header-for-asm-deviceh /dev/null
--- a/arch/frv/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
