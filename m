From: akpm@linux-foundation.org
Subject: - fix-warning-in-mm-slubc.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:00 -0700
Message-ID: <200710292031.l9TKV0q7021813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbXJ2UbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, clameter@sgi.com, penberg@cs.helsinki.fi, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix warning in mm/slub.c
has been removed from the -mm tree.  Its filename was
     fix-warning-in-mm-slubc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix warning in mm/slub.c
From: Olof Johansson <olof@lixom.net>

"Make kmem_cache_node for SLUB on memory online to avoid panic" introduced
the following:

mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from
incompatible pointer type

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~fix-warning-in-mm-slubc mm/slub.c
--- a/mm/slub.c~fix-warning-in-mm-slubc
+++ a/mm/slub.c
@@ -2734,7 +2734,7 @@ static void slab_mem_offline_callback(vo
 			 * and offline_pages() function shoudn't call this
 			 * callback. So, we must fail.
 			 */
-			BUG_ON(atomic_read(&n->nr_slabs));
+			BUG_ON(atomic_long_read(&n->nr_slabs));
 
 			s->node[offline_node] = NULL;
 			kmem_cache_free(kmalloc_caches, n);
_

Patches currently in -mm which might be from olof@lixom.net are

radeonfb-remove-warning-with-config_pm=n.patch
bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
