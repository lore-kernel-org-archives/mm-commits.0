From: akpm@linux-foundation.org
Subject: [patch 10/13] xtensa: use generic fb.h
Date: Fri, 14 Jul 2017 14:50:03 -0700
Message-ID: <59693c8b.lNqXALME3xUO9EFa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbdGNVuD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tklauser@distanz.ch, jcmvbkbc@gmail.com

From: Tobias Klauser <tklauser@distanz.ch>
Subject: xtensa: use generic fb.h

The arch uses a verbatim copy of the asm-generic version and does not add
any own implementations to the header, so use asm-generic/fb.h instead of
duplicating code.

Link: http://lkml.kernel.org/r/20170517083545.2115-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/Kbuild |    1 +
 arch/xtensa/include/asm/fb.h   |   12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/xtensa/include/asm/Kbuild~xtensa-use-generic-fbh arch/xtensa/include/asm/Kbuild
--- a/arch/xtensa/include/asm/Kbuild~xtensa-use-generic-fbh
+++ a/arch/xtensa/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += dma-contiguous.h
 generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += extable.h
+generic-y += fb.h
 generic-y += hardirq.h
 generic-y += irq_regs.h
 generic-y += irq_work.h
diff -puN arch/xtensa/include/asm/fb.h~xtensa-use-generic-fbh /dev/null
--- a/arch/xtensa/include/asm/fb.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_FB_H_
-#define _ASM_FB_H_
-#include <linux/fb.h>
-
-#define fb_pgprotect(...) do {} while (0)
-
-static inline int fb_is_primary_device(struct fb_info *info)
-{
-	return 0;
-}
