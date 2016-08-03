From: akpm@linux-foundation.org
Subject: [merged] kexec-allow-architectures-to-override-boot-mapping.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:49 -0700
Message-ID: <57a2345d.OZ/2xXfKzV2DQUPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbcHCSNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: allow architectures to override boot mapping
has been removed from the -mm tree.  Its filename was
     kexec-allow-architectures-to-override-boot-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kexec: allow architectures to override boot mapping

kexec physical addresses are the boot-time view of the system.  For
certain ARM systems (such as Keystone 2), the boot view of the system does
not match the kernel's view of the system: the boot view uses a special
alias in the lower 4GB of the physical address space.

To cater for these kinds of setups, we need to translate between the boot
view physical addresses and the normal kernel view physical addresses. 
This patch extracts the current transation points into linux/kexec.h, and
allows an architecture to override the functions.

Due to the translations required, we unfortunately end up with six
translation functions, which are reduced down to four that the
architecture can override.

[akpm@linux-foundation.org: kexec.h needs asm/io.h for phys_to_virt()]
Link: http://lkml.kernel.org/r/E1b8koP-0004HZ-Vf@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c        |    3 ++-
 kernel/kexec_core.c   |   26 +++++++++++++-------------
 3 files changed, 55 insertions(+), 14 deletions(-)

diff -puN include/linux/kexec.h~kexec-allow-architectures-to-override-boot-mapping include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-allow-architectures-to-override-boot-mapping
+++ a/include/linux/kexec.h
@@ -14,6 +14,8 @@
 
 #if !defined(__ASSEMBLY__)
 
+#include <asm/io.h>
+
 #include <uapi/linux/kexec.h>
 
 #ifdef CONFIG_KEXEC_CORE
@@ -318,6 +320,44 @@ int __weak arch_kexec_apply_relocations(
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
 
+#ifndef page_to_boot_pfn
+static inline unsigned long page_to_boot_pfn(struct page *page)
+{
+	return page_to_pfn(page);
+}
+#endif
+
+#ifndef boot_pfn_to_page
+static inline struct page *boot_pfn_to_page(unsigned long boot_pfn)
+{
+	return pfn_to_page(boot_pfn);
+}
+#endif
+
+#ifndef phys_to_boot_phys
+static inline unsigned long phys_to_boot_phys(phys_addr_t phys)
+{
+	return phys;
+}
+#endif
+
+#ifndef boot_phys_to_phys
+static inline phys_addr_t boot_phys_to_phys(unsigned long boot_phys)
+{
+	return boot_phys;
+}
+#endif
+
+static inline unsigned long virt_to_boot_phys(void *addr)
+{
+	return phys_to_boot_phys(__pa((unsigned long)addr));
+}
+
+static inline void *boot_phys_to_virt(unsigned long entry)
+{
+	return phys_to_virt(boot_phys_to_phys(entry));
+}
+
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
diff -puN kernel/kexec.c~kexec-allow-architectures-to-override-boot-mapping kernel/kexec.c
--- a/kernel/kexec.c~kexec-allow-architectures-to-override-boot-mapping
+++ a/kernel/kexec.c
@@ -48,7 +48,8 @@ static int kimage_alloc_init(struct kima
 
 	if (kexec_on_panic) {
 		/* Verify we have a valid entry point */
-		if ((entry < crashk_res.start) || (entry > crashk_res.end))
+		if ((entry < phys_to_boot_phys(crashk_res.start)) ||
+		    (entry > phys_to_boot_phys(crashk_res.end)))
 			return -EADDRNOTAVAIL;
 	}
 
diff -puN kernel/kexec_core.c~kexec-allow-architectures-to-override-boot-mapping kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-allow-architectures-to-override-boot-mapping
+++ a/kernel/kexec_core.c
@@ -225,8 +225,8 @@ int sanity_check_segment_list(struct kim
 			mstart = image->segment[i].mem;
 			mend = mstart + image->segment[i].memsz - 1;
 			/* Ensure we are within the crash kernel limits */
-			if ((mstart < crashk_res.start) ||
-			    (mend > crashk_res.end))
+			if ((mstart < phys_to_boot_phys(crashk_res.start)) ||
+			    (mend > phys_to_boot_phys(crashk_res.end)))
 				return -EADDRNOTAVAIL;
 		}
 	}
@@ -350,7 +350,7 @@ static struct page *kimage_alloc_normal_
 		pages = kimage_alloc_pages(KEXEC_CONTROL_MEMORY_GFP, order);
 		if (!pages)
 			break;
-		pfn   = page_to_pfn(pages);
+		pfn   = page_to_boot_pfn(pages);
 		epfn  = pfn + count;
 		addr  = pfn << PAGE_SHIFT;
 		eaddr = epfn << PAGE_SHIFT;
@@ -476,7 +476,7 @@ static int kimage_add_entry(struct kimag
 			return -ENOMEM;
 
 		ind_page = page_address(page);
-		*image->entry = virt_to_phys(ind_page) | IND_INDIRECTION;
+		*image->entry = virt_to_boot_phys(ind_page) | IND_INDIRECTION;
 		image->entry = ind_page;
 		image->last_entry = ind_page +
 				      ((PAGE_SIZE/sizeof(kimage_entry_t)) - 1);
@@ -531,13 +531,13 @@ void kimage_terminate(struct kimage *ima
 #define for_each_kimage_entry(image, ptr, entry) \
 	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
 		ptr = (entry & IND_INDIRECTION) ? \
-			phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
+			boot_phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
 
 static void kimage_free_entry(kimage_entry_t entry)
 {
 	struct page *page;
 
-	page = pfn_to_page(entry >> PAGE_SHIFT);
+	page = boot_pfn_to_page(entry >> PAGE_SHIFT);
 	kimage_free_pages(page);
 }
 
@@ -631,7 +631,7 @@ static struct page *kimage_alloc_page(st
 	 * have a match.
 	 */
 	list_for_each_entry(page, &image->dest_pages, lru) {
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = page_to_boot_pfn(page) << PAGE_SHIFT;
 		if (addr == destination) {
 			list_del(&page->lru);
 			return page;
@@ -646,12 +646,12 @@ static struct page *kimage_alloc_page(st
 		if (!page)
 			return NULL;
 		/* If the page cannot be used file it away */
-		if (page_to_pfn(page) >
+		if (page_to_boot_pfn(page) >
 				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
 			list_add(&page->lru, &image->unusable_pages);
 			continue;
 		}
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = page_to_boot_pfn(page) << PAGE_SHIFT;
 
 		/* If it is the destination page we want use it */
 		if (addr == destination)
@@ -674,7 +674,7 @@ static struct page *kimage_alloc_page(st
 			struct page *old_page;
 
 			old_addr = *old & PAGE_MASK;
-			old_page = pfn_to_page(old_addr >> PAGE_SHIFT);
+			old_page = boot_pfn_to_page(old_addr >> PAGE_SHIFT);
 			copy_highpage(page, old_page);
 			*old = addr | (*old & ~PAGE_MASK);
 
@@ -730,7 +730,7 @@ static int kimage_load_normal_segment(st
 			result  = -ENOMEM;
 			goto out;
 		}
-		result = kimage_add_page(image, page_to_pfn(page)
+		result = kimage_add_page(image, page_to_boot_pfn(page)
 								<< PAGE_SHIFT);
 		if (result < 0)
 			goto out;
@@ -791,7 +791,7 @@ static int kimage_load_crash_segment(str
 		char *ptr;
 		size_t uchunk, mchunk;
 
-		page = pfn_to_page(maddr >> PAGE_SHIFT);
+		page = boot_pfn_to_page(maddr >> PAGE_SHIFT);
 		if (!page) {
 			result  = -ENOMEM;
 			goto out;
@@ -919,7 +919,7 @@ void __weak crash_free_reserved_phys_ran
 	unsigned long addr;
 
 	for (addr = begin; addr < end; addr += PAGE_SIZE)
-		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
+		free_reserved_page(boot_pfn_to_page(addr >> PAGE_SHIFT));
 }
 
 int crash_shrink_memory(unsigned long new_size)
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are


