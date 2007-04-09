From: akpm@linux-foundation.org
Subject: + slob-handle-slab_panic-flag.patch added to -mm tree
Date: Mon, 09 Apr 2007 16:59:53 -0700
Message-ID: <200704092359.l39NxrcP026882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbXDJAAI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 20:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, mpm@selenic.com


The patch titled
     slob: handle SLAB_PANIC flag
has been added to the -mm tree.  Its filename is
     slob-handle-slab_panic-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slob: handle SLAB_PANIC flag
From: Akinobu Mita <akinobu.mita@gmail.com>

kmem_cache_create() for slob doesn't handle SLAB_PANIC.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slob.c~slob-handle-slab_panic-flag mm/slob.c
--- a/mm/slob.c~slob-handle-slab_panic-flag
+++ a/mm/slob.c
@@ -298,7 +298,8 @@ struct kmem_cache *kmem_cache_create(con
 		c->align = (flags & SLAB_MUST_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
 		if (c->align < align)
 			c->align = align;
-	}
+	} else if (flags & SLAB_PANIC)
+		panic("Cannot create slab cache %s\n", name);
 
 	return c;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

auth_gss-unregister-gss_domain-when-unloading-module.patch
slob-handle-slab_panic-flag.patch
simplify-the-stacktrace-code.patch
