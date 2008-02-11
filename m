From: akpm@linux-foundation.org
Subject: + mlx4-fix-build-break.patch added to -mm tree
Date: Mon, 11 Feb 2008 13:45:58 -0800
Message-ID: <200802112146.m1BLjwhJ001920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbYBKWUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, jeff@garzik.org, rolandd@cisco.com


The patch titled
     mlx4: fix build break
has been added to the -mm tree.  Its filename is
     mlx4-fix-build-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mlx4-fix-build-break.patch
