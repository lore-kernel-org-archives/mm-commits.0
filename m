From: akpm@linux-foundation.org
Subject: [merged] frv-use-generic-fbh.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:43 -0700
Message-ID: <20170711192543.-cPDwBy86%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbdGKTZo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org, tklauser@distanz.ch


The patch titled
     Subject: frv: use generic fb.h
has been removed from the -mm tree.  Its filename was
     frv-use-generic-fbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: frv: use generic fb.h

The arch uses a verbatim copy of the asm-generic version and does not add
any own implementations to the header, so use asm-generic/fb.h instead of
duplicating code.

Link: http://lkml.kernel.org/r/20170517083307.1697-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/Kbuild |    1 +
 arch/frv/include/asm/fb.h   |   12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/frv/include/asm/Kbuild~frv-use-generic-fbh arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~frv-use-generic-fbh
+++ a/arch/frv/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
+generic-y += fb.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
diff -puN arch/frv/include/asm/fb.h~frv-use-generic-fbh /dev/null
--- a/arch/frv/include/asm/fb.h
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
