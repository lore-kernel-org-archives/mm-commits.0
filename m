From: akpm@linux-foundation.org
Subject: [patch 004/108] mn10300: remove wrapper header for
 asm/device.h
Date: Thu, 06 Jul 2017 15:35:34 -0700
Message-ID: <20170706223534.7N_p9Afx7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWff (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org, tklauser@distanz.ch, torvalds@linux-foundation.org

From: Tobias Klauser <tklauser@distanz.ch>
Subject: mn10300: remove wrapper header for asm/device.h

mn10300's asm/device.h is merely including asm-generic/device.h.  Thus,
the arch specific header can be omitted and the generic header can be used
directly.

Link: http://lkml.kernel.org/r/20170517124857.26834-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/Kbuild   |    1 +
 arch/mn10300/include/asm/device.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/include/asm/Kbuild~mn10300-remove-wrapper-header-for-asm-deviceh arch/mn10300/include/asm/Kbuild
--- a/arch/mn10300/include/asm/Kbuild~mn10300-remove-wrapper-header-for-asm-deviceh
+++ a/arch/mn10300/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
 generic-y += irq_work.h
diff -puN arch/mn10300/include/asm/device.h~mn10300-remove-wrapper-header-for-asm-deviceh /dev/null
--- a/arch/mn10300/include/asm/device.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/device.h>
_
