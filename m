From: akpm@linux-foundation.org
Subject: - agpgart-allow-drm-populated-agp-memory-types-update.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:41:18 -0800
Message-ID: <200702052041.l15KfI13030561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933432AbXBEUlc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@tungstengraphics.com, airlied@linux.ie, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     agpgart: Allow drm-populated agp memory types (update)
has been removed from the -mm tree.  Its filename was
     agpgart-allow-drm-populated-agp-memory-types-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: agpgart: Allow drm-populated agp memory types (update)
From: Thomas Hellstrom <thomas@tungstengraphics.com>

Signed-off-by: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/agp/agp.h       |    4 +-
 drivers/char/agp/generic.c   |   60 ++++++++++++++++++---------------
 drivers/char/agp/intel-agp.c |    6 ++-
 3 files changed, 40 insertions(+), 30 deletions(-)

diff -puN drivers/char/agp/agp.h~agpgart-allow-drm-populated-agp-memory-types-update drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~agpgart-allow-drm-populated-agp-memory-types-update
+++ a/drivers/char/agp/agp.h
@@ -278,8 +278,8 @@ struct agp_bridge_data *agp_generic_find
 
 /* generic functions for user-populated AGP memory types */
 struct agp_memory *agp_generic_alloc_user(size_t page_count, int type);
-void agp_vkmalloc(size_t size, unsigned long **addr, u8 *vmalloc_flag);
-void agp_vkfree(unsigned long *addr, u8 vmalloc_flag);
+void agp_alloc_page_array(size_t size, struct agp_memory *mem);
+void agp_free_page_array(struct agp_memory *mem);
 
 
 /* generic routines for agp>=3 */
diff -puN drivers/char/agp/generic.c~agpgart-allow-drm-populated-agp-memory-types-update drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agpgart-allow-drm-populated-agp-memory-types-update
+++ a/drivers/char/agp/generic.c
@@ -107,41 +107,43 @@ static int agp_get_key(void)
  * regions.
  */
 
-void agp_vkmalloc(size_t size, unsigned long **addr, u8 *vmalloc_flag)
+void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 {
-	void *tmp = NULL;
+	mem->memory = NULL;
+	mem->vmalloc_flag = 0;
 
-	*vmalloc_flag = 0;
-
-	if (size <= 2*PAGE_SIZE)
-		tmp = kmalloc(size, GFP_KERNEL);
-	if (tmp == NULL) {
-		tmp = vmalloc(size);
-		*vmalloc_flag = 1;
+	if (size <= 2*PAGE_SIZE) {
+		mem->memory = kmalloc(size, GFP_KERNEL | __GFP_NORETRY);
+	}
+	if (mem->memory == NULL) {
+		mem->memory = vmalloc(size);
+		mem->vmalloc_flag = 1;
 	}
-
-	*addr = tmp;
 }
-EXPORT_SYMBOL(agp_vkmalloc);
+EXPORT_SYMBOL(agp_alloc_page_array);
 
-void agp_vkfree(unsigned long *addr, u8 vmalloc_flag)
+void agp_free_page_array(struct agp_memory *mem)
 {
-	if (vmalloc_flag)
-		vfree(addr);
-	else
-		kfree(addr);
+	if (mem->vmalloc_flag) {
+		vfree(mem->memory);
+	} else {
+		kfree(mem->memory);
+	}
 }
-EXPORT_SYMBOL(agp_vkfree);
+EXPORT_SYMBOL(agp_free_page_array);
+
 
 static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
 {
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
-	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
+	new = kmalloc(sizeof(struct agp_memory), GFP_KERNEL);
+
 	if (new == NULL)
 		return NULL;
 
+	memset(new, 0, sizeof(struct agp_memory));
 	new->key = agp_get_key();
 
 	if (new->key < 0) {
@@ -149,7 +151,7 @@ static struct agp_memory *agp_create_use
 		return NULL;
 	}
 
-	agp_vkmalloc(alloc_size, &new->memory, &new->vmalloc_flag);
+	agp_alloc_page_array(alloc_size, new);
 
 	if (new->memory == NULL) {
 		agp_free_key(new->key);
@@ -160,6 +162,7 @@ static struct agp_memory *agp_create_use
 	return new;
 }
 
+
 struct agp_memory *agp_create_memory(int scratch_pages)
 {
 	struct agp_memory *new;
@@ -175,8 +178,7 @@ struct agp_memory *agp_create_memory(int
 		return NULL;
 	}
 
-	agp_vkmalloc(PAGE_SIZE * scratch_pages,
-		     &new->memory, &new->vmalloc_flag);
+	agp_alloc_page_array(PAGE_SIZE * scratch_pages, new);
 
 	if (new->memory == NULL) {
 		agp_free_key(new->key);
@@ -184,6 +186,7 @@ struct agp_memory *agp_create_memory(int
 		return NULL;
 	}
 	new->num_scratch_pages = scratch_pages;
+	new->type = AGP_NORMAL_MEMORY;
 	return new;
 }
 EXPORT_SYMBOL(agp_create_memory);
@@ -222,7 +225,7 @@ void agp_free_memory(struct agp_memory *
 		flush_agp_mappings();
 	}
 	agp_free_key(curr->key);
-	agp_vkfree(curr->memory, curr->vmalloc_flag);
+	agp_free_page_array(curr);
 	kfree(curr);
 }
 EXPORT_SYMBOL(agp_free_memory);
@@ -1068,8 +1071,9 @@ int agp_generic_insert_memory(struct agp
 	num_entries -= agp_memory_reserved/PAGE_SIZE;
 	if (num_entries < 0) num_entries = 0;
 
-	if (type != mem->type)
+	if (type != mem->type) {
 		return -EINVAL;
+	}
 
 	mask_type = bridge->driver->agp_type_to_mask_type(bridge, type);
 	if (mask_type != 0) {
@@ -1139,15 +1143,17 @@ int agp_generic_remove_memory(struct agp
 }
 EXPORT_SYMBOL(agp_generic_remove_memory);
 
+
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type)
 {
 	return NULL;
 }
 EXPORT_SYMBOL(agp_generic_alloc_by_type);
 
+
 void agp_generic_free_by_type(struct agp_memory *curr)
 {
-	agp_vkfree(curr->memory, curr->vmalloc_flag);
+	agp_free_page_array(curr);
 	agp_free_key(curr->key);
 	kfree(curr);
 }
@@ -1164,8 +1170,9 @@ struct agp_memory *agp_generic_alloc_use
 	if (new == NULL)
 		return NULL;
 
-	for (i = 0; i < page_count; i++)
+	for (i = 0; i < page_count; i++) {
 		new->memory[i] = 0;
+	}
 	new->page_count = 0;
 	new->type = type;
 	new->num_scratch_pages = pages;
@@ -1174,6 +1181,7 @@ struct agp_memory *agp_generic_alloc_use
 }
 EXPORT_SYMBOL(agp_generic_alloc_user);
 
+
 /*
  * Basic Page Allocation Routines -
  * These routines handle page allocation and by default they reserve the allocated
diff -puN drivers/char/agp/intel-agp.c~agpgart-allow-drm-populated-agp-memory-types-update drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agpgart-allow-drm-populated-agp-memory-types-update
+++ a/drivers/char/agp/intel-agp.c
@@ -88,6 +88,7 @@ static struct _intel_i810_private {
 	int num_dcache_entries;
 } intel_i810_private;
 
+
 static int intel_i810_fetch_size(void)
 {
 	u32 smram_miscc;
@@ -259,6 +260,7 @@ static int intel_i810_insert_entries(str
 		readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
 		break;
 	case AGP_PHYS_MEMORY:
+	case AGP_NORMAL_MEMORY:
 		if (!mem->is_flushed)
 			global_cache_flush();
 		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
@@ -359,7 +361,7 @@ static struct agp_memory *intel_i810_all
 		new->type = AGP_DCACHE_MEMORY;
 		new->page_count = pg_count;
 		new->num_scratch_pages = 0;
-		agp_vkfree(new->memory, new->vmalloc_flag);
+		agp_free_page_array(new);
 		return new;
 	}
 	if (type == AGP_PHYS_MEMORY)
@@ -378,7 +380,7 @@ static void intel_i810_free_by_type(stru
 				 gart_to_virt(curr->memory[0]));
 			global_flush_tlb();
 		}
-		agp_vkfree(curr->memory, curr->vmalloc_flag);
+		agp_free_page_array(curr);
 	}
 	kfree(curr);
 }
_

Patches currently in -mm which might be from thomas@tungstengraphics.com are

git-agpgart.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
