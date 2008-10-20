From: akpm@linux-foundation.org
Subject: - make-mm-rmapc-anon_vma_cachep-static.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:33 -0700
Message-ID: <200810202037.m9KKbX1k011657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbYJTUrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     make mm/rmap.c:anon_vma_cachep static
has been removed from the -mm tree.  Its filename was
     make-mm-rmapc-anon_vma_cachep-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make mm/rmap.c:anon_vma_cachep static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global anon_vma_cachep static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   12 ------------
 mm/rmap.c            |   12 +++++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN include/linux/rmap.h~make-mm-rmapc-anon_vma_cachep-static include/linux/rmap.h
--- a/include/linux/rmap.h~make-mm-rmapc-anon_vma_cachep-static
+++ a/include/linux/rmap.h
@@ -39,18 +39,6 @@ struct anon_vma {
 
 #ifdef CONFIG_MMU
 
-extern struct kmem_cache *anon_vma_cachep;
-
-static inline struct anon_vma *anon_vma_alloc(void)
-{
-	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
-}
-
-static inline void anon_vma_free(struct anon_vma *anon_vma)
-{
-	kmem_cache_free(anon_vma_cachep, anon_vma);
-}
-
 static inline void anon_vma_lock(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
diff -puN mm/rmap.c~make-mm-rmapc-anon_vma_cachep-static mm/rmap.c
--- a/mm/rmap.c~make-mm-rmapc-anon_vma_cachep-static
+++ a/mm/rmap.c
@@ -55,7 +55,17 @@
 
 #include "internal.h"
 
-struct kmem_cache *anon_vma_cachep;
+static struct kmem_cache *anon_vma_cachep;
+
+static inline struct anon_vma *anon_vma_alloc(void)
+{
+	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+}
+
+static inline void anon_vma_free(struct anon_vma *anon_vma)
+{
+	kmem_cache_free(anon_vma_cachep, anon_vma);
+}
 
 /* This must be called under the mmap_sem. */
 int anon_vma_prepare(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

