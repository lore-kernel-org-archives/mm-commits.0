Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9AB37F72E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780438712; cv=none; b=QHw/XujpgIpkWkulwVY7Bu2yZUFOW5YGoQOj2YS9mSa5y2Z99kuIGVx3bVFs7/od9QWM2QnJe84n0DJlaz7Rgtc53kn+wgzvYTcyExrpe9Y6Bbvvb0bXDmXTIAiyMogFC96c+klqURI+kyaVHgzScDroQxtH4+BzVEybPSd3LAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780438712; c=relaxed/simple;
	bh=6Gkd/2bRccfujWTE4K3r5jTrrNF8Y3H9eeLOMXskjPk=;
	h=Date:To:From:Subject:Message-Id; b=B+6jR13+zLzDDgXKqmsTuLXEA8ziW3fU2voEYkb5+vL2kgZ2B2NxQ2pHm1TyhB88RTpHWy2vbnbwNmLXrEK+girv/b6F6peUSIKXQZDQa6kwt1IraSem/U+1PzSJ2RyheIt/bLhs5Uiwokgmt+i5ySBDc0TNmtVa2DJErDn3DlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2nx1Ba9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2nx1Ba9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7E51F00893;
	Tue,  2 Jun 2026 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780438710;
	bh=dy+NOF9/oFksCUyqx/wNHyVxg2cyRKgKU9IrQQa+9oc=;
	h=Date:To:From:Subject;
	b=G2nx1Ba9EeBYbYRerLRK1uRz1xeucOGJq5zZOaXmFxzIMSiuwVBKlC+iVg1FGgTwY
	 wP+fHr0xQTcF8WQ+QiaCWwDUsD1knStwddpuGruq4tUhy60LGiy0MgLkGz8wh7IwY1
	 +UDKfoSrs2giQrjlQaxOvzaTR9iM9m4VTILm/TxU=
Date: Tue, 02 Jun 2026 15:18:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch removed from -mm tree
Message-Id: <20260602221830.4C7E51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/dmapool: use static key for boot-time debug enablement
has been removed from the -mm tree.  Its filename was
     mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: mm/dmapool: use static key for boot-time debug enablement
Date: Sat, 23 May 2026 23:40:15 -0400

Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
static key (dmapool_debug_enabled).  This allows enabling dmapool
debugging at boot time via:

    dmapool_debug

Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:

- Debugging can be enabled without rebuilding the kernel
- Uses standard kernel static_key mechanism with minimal overhead

Link: https://lore.kernel.org/20260524034015.1830-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 +
 mm/dmapool.c                                    |   52 +++++++-------
 2 files changed, 34 insertions(+), 23 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-dmapool-use-static-key-for-boot-time-debug-enablement
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1333,6 +1333,11 @@ Kernel parameters
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dmapool_debug	[MM]
+			Enable DMA pool debugging. This enables memory
+			poisoning and validation for DMA pool allocations.
+			Useful for debugging DMA API misuse.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
--- a/mm/dmapool.c~mm-dmapool-use-static-key-for-boot-time-debug-enablement
+++ a/mm/dmapool.c
@@ -35,10 +35,23 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/static_key.h>
+#include <linux/init.h>
 
-#ifdef CONFIG_SLUB_DEBUG_ON
-#define DMAPOOL_DEBUG 1
-#endif
+/*
+ * Debugging support for dmapool using static key.
+ *
+ * This allows enabling dmapool debug at boot time via:
+ *   dmapool_debug
+ */
+static DEFINE_STATIC_KEY_FALSE(dmapool_debug_enabled);
+
+static int __init dmapool_debug_setup(char *str)
+{
+	static_branch_enable(&dmapool_debug_enabled);
+	return 1;
+}
+__setup("dmapool_debug", dmapool_debug_setup);
 
 struct dma_block {
 	struct dma_block *next_block;
@@ -92,13 +105,15 @@ static ssize_t pools_show(struct device
 
 static DEVICE_ATTR_RO(pools);
 
-#ifdef DMAPOOL_DEBUG
 static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
 			     gfp_t mem_flags)
 {
 	u8 *data = (void *)block;
 	int i;
 
+	if (!static_branch_unlikely(&dmapool_debug_enabled))
+		return;
+
 	for (i = sizeof(struct dma_block); i < pool->size; i++) {
 		if (data[i] == POOL_POISON_FREED)
 			continue;
@@ -133,8 +148,14 @@ static struct dma_page *pool_find_page(s
 
 static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
-	struct dma_block *block = pool->next_block;
 	struct dma_page *page;
+	struct dma_block *block;
+
+	if (!static_branch_unlikely(&dmapool_debug_enabled)) {
+		if (want_init_on_free())
+			memset(vaddr, 0, pool->size);
+		return false;
+	}
 
 	page = pool_find_page(pool, dma);
 	if (!page) {
@@ -143,6 +164,7 @@ static bool pool_block_err(struct dma_po
 		return true;
 	}
 
+	block = pool->next_block;
 	while (block) {
 		if (block != vaddr) {
 			block = block->next_block;
@@ -159,25 +181,9 @@ static bool pool_block_err(struct dma_po
 
 static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
 {
-	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
-}
-#else
-static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
-			     gfp_t mem_flags)
-{
-}
-
-static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
-{
-	if (want_init_on_free())
-		memset(vaddr, 0, pool->size);
-	return false;
-}
-
-static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
-{
+	if (static_branch_unlikely(&dmapool_debug_enabled))
+		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 }
-#endif
 
 static struct dma_block *pool_block_pop(struct dma_pool *pool)
 {
_

Patches currently in -mm which might be from lirongqing@baidu.com are


