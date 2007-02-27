From: akpm@linux-foundation.org
Subject: + module-use-krealloc.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:46 -0800
Message-ID: <200702272058.l1RKwoEA028403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51989 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbXB0U65 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, rusty@rustcorp.com.au


The patch titled
     module: use krealloc
has been added to the -mm tree.  Its filename is
     module-use-krealloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: module: use krealloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

This converts an open-coded krealloc() to use the shiny new API.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/module.c~module-use-krealloc kernel/module.c
--- a/kernel/module.c~module-use-krealloc
+++ a/kernel/module.c
@@ -308,14 +308,14 @@ static int split_block(unsigned int i, u
 {
 	/* Reallocation required? */
 	if (pcpu_num_used + 1 > pcpu_num_allocated) {
-		int *new = kmalloc(sizeof(new[0]) * pcpu_num_allocated*2,
-				   GFP_KERNEL);
+		int *new;
+
+		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
+			       GFP_KERNEL);
 		if (!new)
 			return 0;
 
-		memcpy(new, pcpu_size, sizeof(new[0])*pcpu_num_allocated);
 		pcpu_num_allocated *= 2;
-		kfree(pcpu_size);
 		pcpu_size = new;
 	}
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-remove-colouroff-from-struct-slab.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch
