From: akpm@linux-foundation.org
Subject: - slob-handle-slab_panic-flag.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:11 -0700
Message-ID: <200705080003.l4803BTG008924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967333AbXEHADk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: handle SLAB_PANIC flag
has been removed from the -mm tree.  Its filename was
     slob-handle-slab_panic-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slob: handle SLAB_PANIC flag
From: Akinobu Mita <akinobu.mita@gmail.com>

kmem_cache_create() for slob doesn't handle SLAB_PANIC.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
