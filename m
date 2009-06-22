From: akpm@linux-foundation.org
Subject: [merged] bootmemc-avoid-c90-declaration-warning.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:01 -0700
Message-ID: <200906221700.n5MH01B5009228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177AbZFVRLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, benh@kernel.crashing.org, hannes@cmpxchg.org, penberg@cs.helsinki.fi, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     bootmem.c: avoid c90 declaration warning
has been removed from the -mm tree.  Its filename was
     bootmemc-avoid-c90-declaration-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem.c: avoid c90 declaration warning
From: Joe Perches <joe@perches.com>

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~bootmemc-avoid-c90-declaration-warning mm/bootmem.c
--- a/mm/bootmem.c~bootmemc-avoid-c90-declaration-warning
+++ a/mm/bootmem.c
@@ -536,11 +536,15 @@ static void * __init alloc_arch_preferre
 		return kzalloc(size, GFP_NOWAIT);
 
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
-	bootmem_data_t *p_bdata;
+	{
+		bootmem_data_t *p_bdata;
 
-	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
-	if (p_bdata)
-		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
+							goal, limit);
+		if (p_bdata)
+			return alloc_bootmem_core(p_bdata, size, align,
+							goal, limit);
+	}
 #endif
 	return NULL;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

