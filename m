From: akpm@linux-foundation.org
Subject: + media-omap3isp-remove-cacheflushh.patch added to -mm tree
Date: Wed, 24 Jun 2020 15:25:56 -0700
Message-ID: <20200624222556.ak5GX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388797AbgFXWZ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab+huawei@kernel.org, laurent.pinchart@ideasonboard.com, hch@lst.de, geert@linux-m68k.org, natechancellor@gmail.com


The patch titled
     Subject: media: omap3isp: remove cacheflush.h
has been added to the -mm tree.  Its filename is
     media-omap3isp-remove-cacheflushh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-omap3isp-remove-cacheflushh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-omap3isp-remove-cacheflushh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: media: omap3isp: remove cacheflush.h

After mm.h was removed from the asm-generic version of cacheflush.h, s390
allyesconfig shows several warnings of the following nature:

In file included from ./arch/s390/include/generated/asm/cacheflush.h:1,
                 from drivers/media/platform/omap3isp/isp.c:42:
./include/asm-generic/cacheflush.h:16:42: warning: 'struct mm_struct'
declared inside parameter list will not be visible outside of this
definition or declaration

As Geert and Laurent point out, this driver does not need this header in
the two files that include it.  Remove it so there are no warnings.

Link: http://lkml.kernel.org/r/20200622234740.72825-2-natechancellor@gmail.com
Fixes: e0cf615d725c ("asm-generic: don't include <linux/mm.h> in cacheflush.h")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/omap3isp/isp.c      |    2 --
 drivers/media/platform/omap3isp/ispvideo.c |    1 -
 2 files changed, 3 deletions(-)

--- a/drivers/media/platform/omap3isp/isp.c~media-omap3isp-remove-cacheflushh
+++ a/drivers/media/platform/omap3isp/isp.c
@@ -39,8 +39,6 @@
  *	Troy Laramy <t-laramy@ti.com>
  */
 
-#include <asm/cacheflush.h>
