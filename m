From: akpm@linux-foundation.org
Subject: + uml-more-__init-annotations.patch added to -mm tree
Date: Mon, 23 Jul 2007 13:33:04 -0700
Message-ID: <200707232033.l6NKX5nm010434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933464AbXGWUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: more __init annotations
has been added to the -mm tree.  Its filename is
     uml-more-__init-annotations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: more __init annotations
From: Jeff Dike <jdike@addtoit.com>

2.6.23-rc1 turned up another batch of references from non-__init code to
__init code.  In most cases, these were missing __init annotations.  In one
case (os_drop_memory), the annotation was present but wrong.

init_maps is __init, but for some reason was being very careful about the
mechanism by which it allocated memory, checking whether it was OK to use
kmalloc (at this point in the boot, it definitely isn't) and using either
alloc_bootmem_low_pages or kmalloc/vmalloc.  So, the kmalloc/vmalloc code is
removed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    4 ++--
 arch/um/drivers/net_kern.c      |    2 +-
 arch/um/kernel/mem.c            |    2 +-
 arch/um/kernel/physmem.c        |   15 +++++----------
 arch/um/kernel/skas/process.c   |    4 ++--
 arch/um/os-Linux/process.c      |    2 +-
 6 files changed, 12 insertions(+), 17 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-more-__init-annotations arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-more-__init-annotations
+++ a/arch/um/drivers/mconsole_kern.c
@@ -499,7 +499,7 @@ static struct mc_device mem_mc = {
 	.remove		= mem_remove,
 };
 
-static int mem_mc_init(void)
+static int __init mem_mc_init(void)
 {
 	if(can_drop_memory())
 		mconsole_register_dev(&mem_mc);
@@ -798,7 +798,7 @@ void mconsole_stack(struct mc_request *r
  */
 static char *notify_socket = NULL;
 
-static int mconsole_init(void)
+static int __init mconsole_init(void)
 {
 	/* long to avoid size mismatch warnings from gcc */
 	long sock;
diff -puN arch/um/drivers/net_kern.c~uml-more-__init-annotations arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-more-__init-annotations
+++ a/arch/um/drivers/net_kern.c
@@ -623,7 +623,7 @@ static int eth_setup_common(char *str, i
 	return found;
 }
 
-static int eth_setup(char *str)
+static int __init eth_setup(char *str)
 {
 	struct eth_init *new;
 	char *error;
diff -puN arch/um/kernel/mem.c~uml-more-__init-annotations arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-more-__init-annotations
+++ a/arch/um/kernel/mem.c
@@ -62,7 +62,7 @@ static void setup_highmem(unsigned long 
 }
 #endif
 
-void mem_init(void)
+void __init mem_init(void)
 {
 	/* clear the zero-page */
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
diff -puN arch/um/kernel/physmem.c~uml-more-__init-annotations arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-more-__init-annotations
+++ a/arch/um/kernel/physmem.c
@@ -28,7 +28,8 @@ unsigned long high_physmem;
 
 extern unsigned long long physmem_size;
 
-int init_maps(unsigned long physmem, unsigned long iomem, unsigned long highmem)
+int __init init_maps(unsigned long physmem, unsigned long iomem,
+		     unsigned long highmem)
 {
 	struct page *p, *map;
 	unsigned long phys_len, phys_pages, highmem_len, highmem_pages;
@@ -47,13 +48,7 @@ int init_maps(unsigned long physmem, uns
 	total_pages = phys_pages + iomem_pages + highmem_pages;
 	total_len = phys_len + iomem_len + highmem_len;
 
-	if(kmalloc_ok){
-		map = kmalloc(total_len, GFP_KERNEL);
-		if(map == NULL)
-			map = vmalloc(total_len);
-	}
-	else map = alloc_bootmem_low_pages(total_len);
-
+	map = alloc_bootmem_low_pages(total_len);
 	if(map == NULL)
 		return -ENOMEM;
 
@@ -98,8 +93,8 @@ void map_memory(unsigned long virt, unsi
 
 extern int __syscall_stub_start;
 
-void setup_physmem(unsigned long start, unsigned long reserve_end,
-		   unsigned long len, unsigned long long highmem)
+void __init setup_physmem(unsigned long start, unsigned long reserve_end,
+			  unsigned long len, unsigned long long highmem)
 {
 	unsigned long reserve = reserve_end - start;
 	int pfn = PFN_UP(__pa(reserve_end));
diff -puN arch/um/kernel/skas/process.c~uml-more-__init-annotations arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-more-__init-annotations
+++ a/arch/um/kernel/skas/process.c
@@ -145,7 +145,7 @@ void init_idle_skas(void)
 
 extern void start_kernel(void);
 
-static int start_kernel_proc(void *unused)
+static int __init start_kernel_proc(void *unused)
 {
 	int pid;
 
@@ -165,7 +165,7 @@ extern int userspace_pid[];
 
 extern char cpu0_irqstack[];
 
-int start_uml_skas(void)
+int __init start_uml_skas(void)
 {
 	stack_protections((unsigned long) &cpu0_irqstack);
 	set_sigstack(cpu0_irqstack, THREAD_SIZE);
diff -puN arch/um/os-Linux/process.c~uml-more-__init-annotations arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-more-__init-annotations
+++ a/arch/um/os-Linux/process.c
@@ -194,7 +194,7 @@ int os_unmap_memory(void *addr, int len)
 #define MADV_REMOVE KERNEL_MADV_REMOVE
 #endif
 
-int __init os_drop_memory(void *addr, int length)
+int os_drop_memory(void *addr, int length)
 {
 	int err;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-string-exporting-on-uml-i386.patch
uml-fix-aio-compilation-bug.patch
uml-more-__init-annotations.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
