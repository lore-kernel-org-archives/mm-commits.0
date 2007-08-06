From: akpm@linux-foundation.org
Subject: + uml-physmem-code-tidying.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:50:22 -0700
Message-ID: <200708061950.l76JoMaA011799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760578AbXHFTut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: physmem code tidying
has been added to the -mm tree.  Its filename is
     uml-physmem-code-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: physmem code tidying
From: Jeff Dike <jdike@addtoit.com>

Tidying of the UML physical memory system.  These are mostly style fixes,
however the includes were cleaned as well.  This uncovered a need for
mem_user.h to be included in mode_kern_skas.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/skas/mode_kern_skas.h |    3 -
 arch/um/kernel/physmem.c              |   50 ++++++++++--------------
 2 files changed, 23 insertions(+), 30 deletions(-)

diff -puN arch/um/include/skas/mode_kern_skas.h~uml-physmem-code-tidying arch/um/include/skas/mode_kern_skas.h
--- a/arch/um/include/skas/mode_kern_skas.h~uml-physmem-code-tidying
+++ a/arch/um/include/skas/mode_kern_skas.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
@@ -9,6 +9,7 @@
 #include "linux/sched.h"
 #include "asm/page.h"
 #include "asm/ptrace.h"
+#include "mem_user.h"
 
 extern void flush_thread_skas(void);
 extern void switch_to_skas(void *prev, void *next);
diff -puN arch/um/kernel/physmem.c~uml-physmem-code-tidying arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-physmem-code-tidying
+++ a/arch/um/kernel/physmem.c
@@ -1,25 +1,17 @@
 /*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "linux/rbtree.h"
-#include "linux/slab.h"
-#include "linux/vmalloc.h"
 #include "linux/bootmem.h"
-#include "linux/module.h"
+#include "linux/mm.h"
 #include "linux/pfn.h"
-#include "asm/types.h"
-#include "asm/pgtable.h"
-#include "kern_util.h"
+#include "asm/page.h"
 #include "as-layout.h"
+#include "init.h"
+#include "kern.h"
 #include "mode_kern.h"
-#include "mem.h"
-#include "mem_user.h"
 #include "os.h"
-#include "kern.h"
-#include "init.h"
 
 static int physmem_fd = -1;
 
@@ -49,10 +41,10 @@ int __init init_maps(unsigned long physm
 	total_len = phys_len + iomem_len + highmem_len;
 
 	map = alloc_bootmem_low_pages(total_len);
-	if(map == NULL)
+	if (map == NULL)
 		return -ENOMEM;
 
-	for(i = 0; i < total_pages; i++){
+	for (i = 0; i < total_pages; i++) {
 		p = &map[i];
 		memset(p, 0, sizeof(struct page));
 		SetPageReserved(p);
@@ -68,7 +60,7 @@ static unsigned long kmem_top = 0;
 
 unsigned long get_kmem_end(void)
 {
-	if(kmem_top == 0)
+	if (kmem_top == 0)
 		kmem_top = CHOOSE_MODE(kmem_end_tt, kmem_end_skas);
 	return kmem_top;
 }
@@ -81,8 +73,8 @@ void map_memory(unsigned long virt, unsi
 
 	fd = phys_mapping(phys, &offset);
 	err = os_map_memory((void *) virt, fd, offset, len, r, w, x);
-	if(err) {
-		if(err == -ENOMEM)
+	if (err) {
+		if (err == -ENOMEM)
 			printk("try increasing the host's "
 			       "/proc/sys/vm/max_map_count to <physical "
 			       "memory size>/4096\n");
@@ -106,7 +98,7 @@ void __init setup_physmem(unsigned long 
 	offset = uml_reserved - uml_physmem;
 	err = os_map_memory((void *) uml_reserved, physmem_fd, offset,
 			    len - offset, 1, 1, 1);
-	if(err < 0){
+	if (err < 0) {
 		os_print_error(err, "Mapping memory");
 		exit(1);
 	}
@@ -126,16 +118,16 @@ int phys_mapping(unsigned long phys, __u
 {
 	int fd = -1;
 
-	if(phys < physmem_size){
+	if (phys < physmem_size) {
 		fd = physmem_fd;
 		*offset_out = phys;
 	}
-	else if(phys < __pa(end_iomem)){
+	else if (phys < __pa(end_iomem)) {
 		struct iomem_region *region = iomem_regions;
 
-		while(region != NULL){
-			if((phys >= region->phys) &&
-			   (phys < region->phys + region->size)){
+		while (region != NULL) {
+			if ((phys >= region->phys) &&
+			    (phys < region->phys + region->size)) {
 				fd = region->fd;
 				*offset_out = phys - region->phys;
 				break;
@@ -143,7 +135,7 @@ int phys_mapping(unsigned long phys, __u
 			region = region->next;
 		}
 	}
-	else if(phys < __pa(end_iomem) + highmem){
+	else if (phys < __pa(end_iomem) + highmem) {
 		fd = physmem_fd;
 		*offset_out = phys - iomem_size;
 	}
@@ -188,8 +180,8 @@ unsigned long find_iomem(char *driver, u
 {
 	struct iomem_region *region = iomem_regions;
 
-	while(region != NULL){
-		if(!strcmp(region->driver, driver)){
+	while (region != NULL) {
+		if (!strcmp(region->driver, driver)) {
 			*len_out = region->size;
 			return region->virt;
 		}
@@ -206,10 +198,10 @@ int setup_iomem(void)
 	unsigned long iomem_start = high_physmem + PAGE_SIZE;
 	int err;
 
-	while(region != NULL){
+	while (region != NULL) {
 		err = os_map_memory((void *) iomem_start, region->fd, 0,
 				    region->size, 1, 1, 0);
-		if(err)
+		if (err)
 			printk("Mapping iomem region for driver '%s' failed, "
 			       "errno = %d\n", region->driver, -err);
 		else {
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
