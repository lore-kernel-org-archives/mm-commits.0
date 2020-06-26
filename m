From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 18/32] media: omap3isp: remove cacheflush.h
Date: Thu, 25 Jun 2020 20:30:11 -0700
Message-ID: <20200626033011.My1dp5EMX%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZDaM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:12 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, hch@lst.de, laurent.pinchart@ideasonboard.com, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, torvalds@linux-foundation.org

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
