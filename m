Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BA51C5D5E
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746664; cv=none; b=hHPAIYnnwQZ/+L7H0wUscSK/gRYo40jkxPWN2uiDeUEZ+2SqSKCx/EM+FceMinnLhNSn+PvAqRZ5G9vCvWAU7uiJESo+wHtPgNsU2nT5zIZddspX6l6Fma0TLjw0ZDUGTc6ERFkR4q4FcXVnWQjtonGrOMeoLUp1dZ9urasPMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746664; c=relaxed/simple;
	bh=t2xW2wo1QwKH5WZSGjYSH+6rM7nOshh12fZKHiqYfAc=;
	h=Date:To:From:Subject:Message-Id; b=dzH5+0hzP4JQXfGmX855kqn4YW1BIIwz+c5lRp3MggsVdQSkrNz5HARzjem10EfpHd2qR/VBzSFJpiUzaiB7O0C77VPXMvNrE6XoXtJXRFJqE9pGbEaXsHJcfW7WbZCHpoj+ckxrJp5FGQNroUJQYpEuet7CUHdDXoyv+Rks5Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+Oy2cHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+Oy2cHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ED01F000E9;
	Mon, 25 May 2026 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779746663;
	bh=GKDEH/2EDsBwnwjqzQYhxmPa2j78mnLmH6svThQWSJc=;
	h=Date:To:From:Subject;
	b=l+Oy2cHaDRc4Kjz9s/saNGRd/w+F91vuQALN7d1VzGYSQrUZ08g/TX56mpkj1SUkH
	 jUPA9Scs71iIqocpLiUjNVrVjhHx729fUouraIq31NseTp9436rqF7ikG0XWlZOmaf
	 vwXyIKRllR16e6ck2wadOehPpiI9u8Ak2aGzJVJs=
Date: Mon, 25 May 2026 15:04:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch added to mm-new branch
Message-Id: <20260525220422.F1ED01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/dmapool: use static key for boot-time debug enablement
has been added to the -mm mm-new branch.  Its filename is
     mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
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

mm-dmapool-use-static-key-for-boot-time-debug-enablement.patch

