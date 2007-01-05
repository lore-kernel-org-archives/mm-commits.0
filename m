From: akpm@osdl.org
Subject: + uml-memc-and-physmemc-formatting-fixes.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:33 -0800
Message-ID: <200701052013.l05KDXhk031093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbXAEUNh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: mem.c and physmem.c formatting fixes
has been added to the -mm tree.  Its filename is
     uml-memc-and-physmemc-formatting-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mem.c and physmem.c formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Fix a bunch of style violations in mem.c and physmem.c

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/kernel/mem.c     |   77 ++++++++++++++++---------------------
 arch/um/kernel/physmem.c |   57 +++++++++++----------------
 2 files changed, 57 insertions(+), 77 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-memc-and-physmemc-formatting-fixes arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-memc-and-physmemc-formatting-fixes
+++ a/arch/um/kernel/mem.c
@@ -65,8 +65,8 @@ void mem_init(void)
 {
 	max_low_pfn = (high_physmem - uml_physmem) >> PAGE_SHIFT;
 
-        /* clear the zero-page */
-        memset((void *) empty_zero_page, 0, PAGE_SIZE);
+	/* clear the zero-page */
+	memset((void *) empty_zero_page, 0, PAGE_SIZE);
 
 	/* Map in the area just after the brk now that kmalloc is about
 	 * to be turned on.
@@ -253,8 +253,10 @@ struct page *arch_validate(struct page *
 	int i;
 
  again:
-	if(page == NULL) return(page);
-	if(PageHighMem(page)) return(page);
+	if(page == NULL)
+		return page;
+	if(PageHighMem(page))
+		return page;
 
 	addr = (unsigned long) page_address(page);
 	for(i = 0; i < (1 << order); i++){
@@ -263,13 +265,15 @@ struct page *arch_validate(struct page *
 				     sizeof(zero),
 				     &current->thread.fault_addr,
 				     &current->thread.fault_catcher)){
-			if(!(mask & __GFP_WAIT)) return(NULL);
+			if(!(mask & __GFP_WAIT))
+				return NULL;
 			else break;
 		}
 		addr += PAGE_SIZE;
 	}
 
-	if(i == (1 << order)) return(page);
+	if(i == (1 << order))
+		return page;
 	page = alloc_pages(mask, order);
 	goto again;
 }
@@ -283,7 +287,6 @@ void free_initmem(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (start < end)
@@ -296,37 +299,36 @@ void free_initrd_mem(unsigned long start
 		totalram_pages++;
 	}
 }
-	
 #endif
 
 void show_mem(void)
 {
-        int pfn, total = 0, reserved = 0;
-        int shared = 0, cached = 0;
-        int highmem = 0;
+	int pfn, total = 0, reserved = 0;
+	int shared = 0, cached = 0;
+	int highmem = 0;
 	struct page *page;
 
-        printk("Mem-info:\n");
-        show_free_areas();
-        printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-        pfn = max_mapnr;
-        while(pfn-- > 0) {
+	printk("Mem-info:\n");
+	show_free_areas();
+	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
+	pfn = max_mapnr;
+	while(pfn-- > 0) {
 		page = pfn_to_page(pfn);
-                total++;
-                if(PageHighMem(page))
-                        highmem++;
-                if(PageReserved(page))
-                        reserved++;
-                else if(PageSwapCache(page))
-                        cached++;
-                else if(page_count(page))
-                        shared += page_count(page) - 1;
-        }
-        printk("%d pages of RAM\n", total);
-        printk("%d pages of HIGHMEM\n", highmem);
-        printk("%d reserved pages\n", reserved);
-        printk("%d pages shared\n", shared);
-        printk("%d pages swap cached\n", cached);
+		total++;
+		if(PageHighMem(page))
+			highmem++;
+		if(PageReserved(page))
+			reserved++;
+		else if(PageSwapCache(page))
+			cached++;
+		else if(page_count(page))
+			shared += page_count(page) - 1;
+	}
+	printk("%d pages of RAM\n", total);
+	printk("%d pages of HIGHMEM\n", highmem);
+	printk("%d reserved pages\n", reserved);
+	printk("%d pages shared\n", shared);
+	printk("%d pages swap cached\n", cached);
 }
 
 /*
@@ -362,18 +364,7 @@ pte_t *pte_alloc_one_kernel(struct mm_st
 struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *pte;
-   
+
 	pte = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
 	return pte;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/physmem.c~uml-memc-and-physmemc-formatting-fixes arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-memc-and-physmemc-formatting-fixes
+++ a/arch/um/kernel/physmem.c
@@ -40,7 +40,7 @@ static struct rb_node **find_rb(void *vi
 	while(*n != NULL){
 		d = rb_entry(*n, struct phys_desc, rb);
 		if(d->virt == virt)
-			return(n);
+			return n;
 
 		if(d->virt > virt)
 			n = &(*n)->rb_left;
@@ -48,7 +48,7 @@ static struct rb_node **find_rb(void *vi
 			n = &(*n)->rb_right;
 	}
 
-	return(n);
+	return n;
 }
 
 static struct phys_desc *find_phys_mapping(void *virt)
@@ -56,9 +56,9 @@ static struct phys_desc *find_phys_mappi
 	struct rb_node **n = find_rb(virt);
 
 	if(*n == NULL)
-		return(NULL);
+		return NULL;
 
-	return(rb_entry(*n, struct phys_desc, rb));
+	return rb_entry(*n, struct phys_desc, rb);
 }
 
 static void insert_phys_mapping(struct phys_desc *desc)
@@ -89,10 +89,10 @@ static struct desc_mapping *find_mapping
 	list_for_each(ele, &descriptor_mappings){
 		desc = list_entry(ele, struct desc_mapping, list);
 		if(desc->fd == fd)
-			return(desc);
+			return desc;
 	}
 
-	return(NULL);
+	return NULL;
 }
 
 static struct desc_mapping *descriptor_mapping(int fd)
@@ -101,11 +101,11 @@ static struct desc_mapping *descriptor_m
 
 	desc = find_mapping(fd);
 	if(desc != NULL)
-		return(desc);
+		return desc;
 
 	desc = kmalloc(sizeof(*desc), GFP_ATOMIC);
 	if(desc == NULL)
-		return(NULL);
+		return NULL;
 
 	*desc = ((struct desc_mapping)
 		{ .fd =		fd,
@@ -113,7 +113,7 @@ static struct desc_mapping *descriptor_m
 		  .pages =	LIST_HEAD_INIT(desc->pages) });
 	list_add(&desc->list, &descriptor_mappings);
 
-	return(desc);
+	return desc;
 }
 
 int physmem_subst_mapping(void *virt, int fd, __u64 offset, int w)
@@ -125,11 +125,11 @@ int physmem_subst_mapping(void *virt, in
 
 	fd_maps = descriptor_mapping(fd);
 	if(fd_maps == NULL)
-		return(-ENOMEM);
+		return -ENOMEM;
 
 	phys = __pa(virt);
 	desc = find_phys_mapping(virt);
-  	if(desc != NULL)
+	if(desc != NULL)
 		panic("Address 0x%p is already substituted\n", virt);
 
 	err = -ENOMEM;
@@ -155,7 +155,7 @@ int physmem_subst_mapping(void *virt, in
 	rb_erase(&desc->rb, &phys_mappings);
 	kfree(desc);
  out:
-	return(err);
+	return err;
 }
 
 static int physmem_fd = -1;
@@ -182,10 +182,10 @@ int physmem_remove_mapping(void *virt)
 	virt = (void *) ((unsigned long) virt & PAGE_MASK);
 	desc = find_phys_mapping(virt);
 	if(desc == NULL)
-		return(0);
+		return 0;
 
 	remove_mapping(desc);
-	return(1);
+	return 1;
 }
 
 void physmem_forget_descriptor(int fd)
@@ -239,9 +239,9 @@ void arch_free_page(struct page *page, i
 
 int is_remapped(void *virt)
 {
-  	struct phys_desc *desc = find_phys_mapping(virt);
+ 	struct phys_desc *desc = find_phys_mapping(virt);
 
-	return(desc != NULL);
+	return desc != NULL;
 }
 
 /* Changed during early boot */
@@ -276,7 +276,7 @@ int init_maps(unsigned long physmem, uns
 	else map = alloc_bootmem_low_pages(total_len);
 
 	if(map == NULL)
-		return(-ENOMEM);
+		return -ENOMEM;
 
 	for(i = 0; i < total_pages; i++){
 		p = &map[i];
@@ -286,7 +286,7 @@ int init_maps(unsigned long physmem, uns
 	}
 
 	max_mapnr = total_pages;
-	return(0);
+	return 0;
 }
 
 /* Changed during early boot */
@@ -296,7 +296,7 @@ unsigned long get_kmem_end(void)
 {
 	if(kmem_top == 0)
 		kmem_top = CHOOSE_MODE(kmem_end_tt, kmem_end_skas);
-	return(kmem_top);
+	return kmem_top;
 }
 
 void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
@@ -379,7 +379,7 @@ int phys_mapping(unsigned long phys, __u
 		*offset_out = phys - iomem_size;
 	}
 
-	return(fd);
+	return fd;
 }
 
 static int __init uml_mem_setup(char *line, int *add)
@@ -422,13 +422,13 @@ unsigned long find_iomem(char *driver, u
 	while(region != NULL){
 		if(!strcmp(region->driver, driver)){
 			*len_out = region->size;
-			return(region->virt);
+			return region->virt;
 		}
 
 		region = region->next;
 	}
 
-	return(0);
+	return 0;
 }
 
 int setup_iomem(void)
@@ -452,18 +452,7 @@ int setup_iomem(void)
 		region = region->next;
 	}
 
-	return(0);
+	return 0;
 }
 
 __initcall(setup_iomem);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
