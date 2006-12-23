From: akpm@osdl.org
Subject: - handle-slob-with-sparsemen.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:18 -0800
Message-ID: <200612230754.kBN7sIVK010200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbWLWHyn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, hugh@veritas.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     handle SLOB with sparsemen
has been removed from the -mm tree.  Its filename was
     handle-slob-with-sparsemen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~handle-slob-with-sparsemen init/Kconfig
--- a/init/Kconfig~handle-slob-with-sparsemen
+++ a/init/Kconfig
@@ -450,7 +450,7 @@ config SHMEM
 
 config SLAB
 	default y
-	bool "Use full SLAB allocator" if EMBEDDED
+	bool "Use full SLAB allocator" if (EMBEDDED && !SMP && !SPARSEMEM)
 	help
 	  Disabling this replaces the advanced SLAB allocator and
 	  kmalloc support with the drastically simpler SLOB allocator.
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch

