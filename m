From: akpm@linux-foundation.org
Subject: - include-kern_-constant-in-printk-calls-in-mm-slabc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:13 -0700
Message-ID: <200705080003.l4803Dx6008928@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967341AbXEHADx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matze@riseup.net, matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include KERN_* constant in printk() calls in mm/slab.c
has been removed from the -mm tree.  Its filename was
     include-kern_-constant-in-printk-calls-in-mm-slabc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include KERN_* constant in printk() calls in mm/slab.c
From: matze <matze@riseup.net>

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~include-kern_-constant-in-printk-calls-in-mm-slabc mm/slab.c
--- a/mm/slab.c~include-kern_-constant-in-printk-calls-in-mm-slabc
+++ a/mm/slab.c
@@ -2168,13 +2168,15 @@ kmem_cache_create (const char *name, siz
 		 */
 		res = probe_kernel_address(pc->name, tmp);
 		if (res) {
-			printk("SLAB: cache with size %d has lost its name\n",
+			printk(KERN_ERR
+			       "SLAB: cache with size %d has lost its name\n",
 			       pc->buffer_size);
 			continue;
 		}
 
 		if (!strcmp(pc->name, name)) {
-			printk("kmem_cache_create: duplicate cache %s\n", name);
+			printk(KERN_ERR
+			       "kmem_cache_create: duplicate cache %s\n", name);
 			dump_stack();
 			goto oops;
 		}
@@ -2311,7 +2313,8 @@ kmem_cache_create (const char *name, siz
 	left_over = calculate_slab_order(cachep, size, align, flags);
 
 	if (!cachep->num) {
-		printk("kmem_cache_create: couldn't create cache %s.\n", name);
+		printk(KERN_ERR
+		       "kmem_cache_create: couldn't create cache %s.\n", name);
 		kmem_cache_free(&cache_cache, cachep);
 		cachep = NULL;
 		goto oops;
_

Patches currently in -mm which might be from matze@riseup.net are

origin.patch
