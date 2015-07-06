From: akpm@linux-foundation.org
Subject: [merged] drm-nouveau-gem-use-kvfree-in-u_free.patch removed from
 -mm tree
Date: Mon, 06 Jul 2015 12:47:49 -0700
Message-ID: <559adb65.pNvBZ3xvA7bEM9J/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbbGFTru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/nouveau/gem: use kvfree() in u_free()
has been removed from the -mm tree.  Its filename was
     drm-nouveau-gem-use-kvfree-in-u_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: drm/nouveau/gem: use kvfree() in u_free()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_gem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_gem.c~drm-nouveau-gem-use-kvfree-in-u_free drivers/gpu/drm/nouveau/nouveau_gem.c
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c~drm-nouveau-gem-use-kvfree-in-u_free
+++ a/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -555,10 +555,7 @@ nouveau_gem_pushbuf_validate(struct nouv
 static inline void
 u_free(void *addr)
 {
-	if (!is_vmalloc_addr(addr))
-		kfree(addr);
-	else
-		vfree(addr);
+	kvfree(addr);
 }
 
 static inline void *
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch

