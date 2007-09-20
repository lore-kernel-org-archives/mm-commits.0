From: akpm@linux-foundation.org
Subject: + agp-fix-race-condition-between-unmapping-and-freeing-pages.patch added to -mm tree
Date: Wed, 19 Sep 2007 19:24:48 -0700
Message-ID: <200709200224.l8K2OmZC024022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbXITCZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 22:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: airlied@redhat.com, airlied@linux.ie


The patch titled
     agp: fix race condition between unmapping and freeing pages
has been added to the -mm tree.  Its filename is
     agp-fix-race-condition-between-unmapping-and-freeing-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: agp: fix race condition between unmapping and freeing pages
From: Dave Airlie <airlied@redhat.com>

With Andi's clflush fixup, we were getting hangs on server exit, flushing the
mappings after freeing each page helped.

This showed up a race condition where the pages after being freed could be
reused before the agp mappings had been flushed.  Flushing after each single
page is a bad thing for future drm work, so make the page destroy a two pass
unmapping all the pages, flushing the mappings, and then destroying the pages.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h       |    7 +++++--
 drivers/char/agp/ali-agp.c   |   27 ++++++++++++++++-----------
 drivers/char/agp/backend.c   |   12 ++++++++----
 drivers/char/agp/generic.c   |   20 ++++++++++++++------
 drivers/char/agp/i460-agp.c  |    4 ++--
 drivers/char/agp/intel-agp.c |    6 ++++--
 6 files changed, 49 insertions(+), 27 deletions(-)

diff -puN drivers/char/agp/agp.h~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/agp.h
@@ -58,6 +58,9 @@ struct gatt_mask {
 	 * devices this will probably be ignored */
 };
 
+#define AGP_PAGE_DESTROY_UNMAP 1
+#define AGP_PAGE_DESTROY_FREE 2
+
 struct aper_size_info_8 {
 	int size;
 	int num_entries;
@@ -113,7 +116,7 @@ struct agp_bridge_driver {
 	struct agp_memory *(*alloc_by_type) (size_t, int);
 	void (*free_by_type)(struct agp_memory *);
 	void *(*agp_alloc_page)(struct agp_bridge_data *);
-	void (*agp_destroy_page)(void *);
+	void (*agp_destroy_page)(void *, int flags);
         int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 };
 
@@ -267,7 +270,7 @@ int agp_generic_remove_memory(struct agp
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
 void agp_generic_free_by_type(struct agp_memory *curr);
 void *agp_generic_alloc_page(struct agp_bridge_data *bridge);
-void agp_generic_destroy_page(void *addr);
+void agp_generic_destroy_page(void *addr, int flags);
 void agp_free_key(int key);
 int agp_num_entries(void);
 u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 mode, u32 command);
diff -puN drivers/char/agp/ali-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/ali-agp.c
--- a/drivers/char/agp/ali-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/ali-agp.c
@@ -156,29 +156,34 @@ static void *m1541_alloc_page(struct agp
 	return addr;
 }
 
-static void ali_destroy_page(void * addr)
+static void ali_destroy_page(void * addr, int flags)
 {
 	if (addr) {
-		global_cache_flush();	/* is this really needed?  --hch */
-		agp_generic_destroy_page(addr);
-		global_flush_tlb();
+		if (flags & AGP_PAGE_DESTROY_UNMAP) {
+			global_cache_flush();	/* is this really needed?  --hch */
+			agp_generic_destroy_page(addr, flags);
+			global_flush_tlb();
+		} else
+			agp_generic_destroy_page(addr, flags);
 	}
 }
 
-static void m1541_destroy_page(void * addr)
+static void m1541_destroy_page(void * addr, int flags)
 {
 	u32 temp;
 
 	if (addr == NULL)
 		return;
 
-	global_cache_flush();
+	if (flags & AGP_PAGE_DESTROY_UNMAP) {
+		global_cache_flush();
 
-	pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
-	pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
-			(((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
-			  virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN));
-	agp_generic_destroy_page(addr);
+		pci_read_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL, &temp);
+		pci_write_config_dword(agp_bridge->dev, ALI_CACHE_FLUSH_CTRL,
+				       (((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
+					 virt_to_gart(addr)) | ALI_CACHE_FLUSH_EN));
+	}
+	agp_generic_destroy_page(addr, flags);
 }
 
 
diff -puN drivers/char/agp/backend.c~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/backend.c
@@ -189,9 +189,11 @@ static int agp_backend_initialize(struct
 
 err_out:
 	if (bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(
-				gart_to_virt(bridge->scratch_page_real));
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_UNMAP);
 		flush_agp_mappings();
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_FREE);
 	}
 	if (got_gatt)
 		bridge->driver->free_gatt_table(bridge);
@@ -215,9 +217,11 @@ static void agp_backend_cleanup(struct a
 
 	if (bridge->driver->agp_destroy_page &&
 	    bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(
-				gart_to_virt(bridge->scratch_page_real));
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_UNMAP);
 		flush_agp_mappings();
+		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
+						 AGP_PAGE_DESTROY_FREE);
 	}
 }
 
diff -puN drivers/char/agp/generic.c~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/generic.c
@@ -195,9 +195,12 @@ void agp_free_memory(struct agp_memory *
 	}
 	if (curr->page_count != 0) {
 		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]));
+			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_UNMAP);
 		}
 		flush_agp_mappings();
+		for (i = 0; i < curr->page_count; i++) {
+			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_FREE);
+		}
 	}
 	agp_free_key(curr->key);
 	agp_free_page_array(curr);
@@ -1176,7 +1179,7 @@ void *agp_generic_alloc_page(struct agp_
 EXPORT_SYMBOL(agp_generic_alloc_page);
 
 
-void agp_generic_destroy_page(void *addr)
+void agp_generic_destroy_page(void *addr, int flags)
 {
 	struct page *page;
 
@@ -1184,10 +1187,15 @@ void agp_generic_destroy_page(void *addr
 		return;
 
 	page = virt_to_page(addr);
-	unmap_page_from_agp(page);
-	put_page(page);
-	free_page((unsigned long)addr);
-	atomic_dec(&agp_bridge->current_memory_agp);
+	if (flags & AGP_PAGE_DESTROY_UNMAP) {
+		unmap_page_from_agp(page);
+	}
+
+	if (flags & AGP_PAGE_DESTROY_FREE) {
+		put_page(page);
+		free_page((unsigned long)addr);
+		atomic_dec(&agp_bridge->current_memory_agp);
+	}
 }
 EXPORT_SYMBOL(agp_generic_destroy_page);
 
diff -puN drivers/char/agp/i460-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/i460-agp.c
--- a/drivers/char/agp/i460-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/i460-agp.c
@@ -536,10 +536,10 @@ static void *i460_alloc_page (struct agp
 	return page;
 }
 
-static void i460_destroy_page (void *page)
+static void i460_destroy_page (void *page, int flags)
 {
 	if (I460_IO_PAGE_SHIFT <= PAGE_SHIFT) {
-		agp_generic_destroy_page(page);
+		agp_generic_destroy_page(page, flags);
 		global_flush_tlb();
 	}
 }
diff -puN drivers/char/agp/intel-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-fix-race-condition-between-unmapping-and-freeing-pages
+++ a/drivers/char/agp/intel-agp.c
@@ -407,9 +407,11 @@ static void intel_i810_free_by_type(stru
 		if (curr->page_count == 4)
 			i8xx_destroy_pages(gart_to_virt(curr->memory[0]));
 		else {
-			agp_bridge->driver->agp_destroy_page(
-				 gart_to_virt(curr->memory[0]));
+			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+							     AGP_PAGE_DESTROY_UNMAP);
 			global_flush_tlb();
+			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+							     AGP_PAGE_DESTROY_FREE);
 		}
 		agp_free_page_array(curr);
 	}
_

Patches currently in -mm which might be from airlied@redhat.com are

git-drm.patch
agp-fix-race-condition-between-unmapping-and-freeing-pages.patch
