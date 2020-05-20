From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-include-linux-time_typesh-for-sockios.patch added to
 -mm tree
Date: Tue, 19 May 2020 18:11:50 -0700
Message-ID: <20200520011150.gRbyMdQi1%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgETBLx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 May 2020 21:11:53 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dalias@libc.org, davem@davemloft.net, glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org, stable@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: include linux/time_types.h for sockios
has been added to the -mm tree.  Its filename is
     sh-include-linux-time_typesh-for-sockios.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-include-linux-time_typesh-for-sockios.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-include-linux-time_typesh-for-sockios.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: sh: include linux/time_types.h for sockios

Using the socket ioctls on arch/sh (and only there) causes build time
problems when __kernel_old_timeval/__kernel_old_timespec are not already
visible to the compiler.

Add an explict include line for the header that defines these
structures.

Link: http://lkml.kernel.org/r/20200519131327.1836482-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Fixes: 8c709f9a0693 ("y2038: sh: remove timeval/timespec usage from headers")
Fixes: 0768e17073dc ("net: socket: implement 64-bit timestamps")
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/uapi/asm/sockios.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sh/include/uapi/asm/sockios.h~sh-include-linux-time_typesh-for-sockios
+++ a/arch/sh/include/uapi/asm/sockios.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_SH_SOCKIOS_H
 #define __ASM_SH_SOCKIOS_H
 
+#include <linux/time_types.h>
+
 /* Socket-level I/O control calls. */
 #define FIOGETOWN	_IOR('f', 123, int)
 #define FIOSETOWN 	_IOW('f', 124, int)
_

Patches currently in -mm which might be from arnd@arndb.de are

sh-include-linux-time_typesh-for-sockios.patch
drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
arm64-add-support-for-folded-p4d-page-tables-fix.patch
