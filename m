From: akpm@linux-foundation.org
Subject: - mlx4-fix-build-break.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:58 -0800
Message-ID: <200802132015.m1DKFwhF011417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046AbYBMUXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:23:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, jeff@garzik.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     mlx4: fix build break
has been removed from the -mm tree.  Its filename was
     mlx4-fix-build-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlx4: fix build break
From: Olof Johansson <olof@lixom.net>

Fix "mlx4_core: For 64-bit systems, vmap() kernel queue buffers":

It caused this to pop up on powerpc allyesconfig, looks like a missing
include file:

drivers/net/mlx4/alloc.c: In function 'mlx4_buf_alloc':
drivers/net/mlx4/alloc.c:162: error: implicit declaration of function 'vmap'
drivers/net/mlx4/alloc.c:162: error: 'VM_MAP' undeclared (first use in this function)
drivers/net/mlx4/alloc.c:162: error: (Each undeclared identifier is reported only once
drivers/net/mlx4/alloc.c:162: error: for each function it appears in.)
drivers/net/mlx4/alloc.c:162: warning: assignment makes pointer from integer without a cast
drivers/net/mlx4/alloc.c: In function 'mlx4_buf_free':
drivers/net/mlx4/alloc.c:187: error: implicit declaration of function 'vunmap'

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mlx4/alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/mlx4/alloc.c~mlx4-fix-build-break drivers/net/mlx4/alloc.c
--- a/drivers/net/mlx4/alloc.c~mlx4-fix-build-break
+++ a/drivers/net/mlx4/alloc.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
 
 #include "mlx4.h"
 
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
