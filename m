From: akpm@linux-foundation.org
Subject: + media-platform-drivers-fix-build-on-cris-arch.patch added to
 -mm tree
Date: Mon, 04 Nov 2013 13:16:24 -0800
Message-ID: <52780ea8.LGlULVPDlYvCBUxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3KDVQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, stable@vger.kernel.org, jesper.nilsson@axis.com, ben@decadent.org.uk, m.chehab@samsung.com

Subject: + media-platform-drivers-fix-build-on-cris-arch.patch added to -mm tree
To: m.chehab@samsung.com,ben@decadent.org.uk,jesper.nilsson@axis.com,stable@vger.kernel.org,starvik@axis.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:16:24 -0800


The patch titled
     Subject: media platform drivers: fix build on cris arch
has been added to the -mm tree.  Its filename is
     media-platform-drivers-fix-build-on-cris-arch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-platform-drivers-fix-build-on-cris-arch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-platform-drivers-fix-build-on-cris-arch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: media platform drivers: fix build on cris arch

On cris arch, the functions below aren't defined:

        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':

        drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':

        drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_setup':
        drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]

        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_request_capture_stop':
        drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]

Yet, they're available, as CONFIG_GENERIC_IOMAP is defined.  What happens
is that asm/io.h was not including asm-generic/iomap.h.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/include/asm/io.h~media-platform-drivers-fix-build-on-cris-arch arch/cris/include/asm/io.h
--- a/arch/cris/include/asm/io.h~media-platform-drivers-fix-build-on-cris-arch
+++ a/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations
_

Patches currently in -mm which might be from m.chehab@samsung.com are

media-platform-drivers-fix-build-on-cris-arch.patch
linux-next.patch

