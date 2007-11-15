From: akpm@linux-foundation.org
Subject: - slab-fix-typo-in-allocation-failure-handling.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:10 -0800
Message-ID: <200711152108.lAFL8A4t015334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765601AbXKOVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab: fix typo in allocation failure handling
has been removed from the -mm tree.  Its filename was
     slab-fix-typo-in-allocation-failure-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: fix typo in allocation failure handling
From: "Akinobu Mita" <akinobu.mita@gmail.com>

This patch fixes wrong array index in allocation failure handling.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-typo-in-allocation-failure-handling mm/slab.c
--- a/mm/slab.c~slab-fix-typo-in-allocation-failure-handling
+++ a/mm/slab.c
@@ -1043,7 +1043,7 @@ static struct array_cache **alloc_alien_
 			}
 			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d);
 			if (!ac_ptr[i]) {
-				for (i--; i <= 0; i--)
+				for (i--; i >= 0; i--)
 					kfree(ac_ptr[i]);
 				kfree(ac_ptr);
 				return NULL;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
