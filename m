From: akpm@osdl.org
Subject: + handle-slob-with-sparsemen.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:24:31 -0800
Message-ID: <200612192024.kBJKOV6h009343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60317 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbWLSUYv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:24:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, hugh@veritas.com, randy.dunlap@oracle.com


The patch titled
     handle SLOB with sparsemen
has been added to the -mm tree.  Its filename is
     handle-slob-with-sparsemen.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: handle SLOB with sparsemen
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This is to disallow to make SLOB with SMP or SPARSEMEM.  This avoids latent
troubles of SLOB with SLAB_DESTROY_BY_RCU.  And fix compile error.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~handle-slob-with-sparsemen init/Kconfig
--- a/init/Kconfig~handle-slob-with-sparsemen
+++ a/init/Kconfig
@@ -454,7 +454,7 @@ config SHMEM
 
 config SLAB
 	default y
-	bool "Use full SLAB allocator" if EMBEDDED
+	bool "Use full SLAB allocator" if (EMBEDDED && !SMP && !SPARSEMEM)
 	help
 	  Disabling this replaces the advanced SLAB allocator and
 	  kmalloc support with the drastically simpler SLOB allocator.
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

handle-slob-with-sparsemen.patch

