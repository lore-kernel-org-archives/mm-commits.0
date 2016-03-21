From: akpm@linux-foundation.org
Subject: [merged] mm-slub-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:17 -0700
Message-ID: <56f03f99.cNCREgSxUtjKSiCV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     mm-slub-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

[akpm@linux-foundation.org: clean up code, per Christian]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting mm/slub.c
--- a/mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting
+++ a/mm/slub.c
@@ -254,11 +254,10 @@ static inline void *get_freepointer_safe
 {
 	void *p;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+	if (!debug_pagealloc_enabled())
+		return get_freepointer(s, object);
+
 	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
-#else
-	p = get_freepointer(s, object);
-#endif
 	return p;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


