From: akpm@linux-foundation.org
Subject: + pci-clean-up-resource-alignment-management.patch added to -mm tree
Date: Thu, 03 Apr 2008 11:56:50 -0700
Message-ID: <200804031856.m33IuoRw017202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbYDCS5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 14:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, garyhade@us.ibm.com, greg@kroah.com, torvalds@linux-foundation.org


The patch titled
     pci: clean up resource alignment management
has been added to the -mm tree.  Its filename is
     pci-clean-up-resource-alignment-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: clean up resource alignment management
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Done per Linus' request and suggestions. Linus has explained that
better than I'll be able to explain:

On Thu, Mar 27, 2008 at 10:12:10AM -0700, Linus Torvalds wrote:
> Actually, before we go any further, there might be a less intrusive
> alternative: add just a couple of flags to the resource flags field (we
> still have something like 8 unused bits on 32-bit), and use those to
> implement a generic "resource_alignment()" routine.
>
> Two flags would do it:
>
>  - IORESOURCE_SIZEALIGN: size indicates alignment (regular PCI device
>    resources)
>
>  - IORESOURCE_STARTALIGN: start field is alignment (PCI bus resources
>    during probing)
>
> and then the case of both flags zero (or both bits set) would actually be
> "invalid", and we would also clear the IORESOURCE_STARTALIGN flag when we
> actually allocate the resource (so that we don't use the "start" field as
> alignment incorrectly when it no longer indicates alignment).
>
> That wouldn't be totally generic, but it would have the nice property of
> automatically at least add sanity checking for that whole "res->start has
> the odd meaning of 'alignment' during probing" and remove the need for a
> new field, and it would allow us to have a generic "resource_alignment()"
> routine that just gets a resource pointer.

Besides, I removed IORESOURCE_BUS_HAS_VGA flag which was unused for ages.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c     |    5 ++--
 drivers/pci/setup-bus.c |    3 ++
 drivers/pci/setup-res.c |   42 ++++++++++++++++++++------------------
 include/linux/ioport.h  |    5 +++-
 kernel/resource.c       |   18 ++++++++++++++++
 5 files changed, 51 insertions(+), 22 deletions(-)

diff -puN drivers/pci/probe.c~pci-clean-up-resource-alignment-management drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-clean-up-resource-alignment-management
+++ a/drivers/pci/probe.c
@@ -235,7 +235,7 @@ static void pci_read_bases(struct pci_de
 			res->flags |= l & ~PCI_BASE_ADDRESS_IO_MASK;
 		}
 		res->end = res->start + (unsigned long) sz;
-		res->flags |= pci_calc_resource_flags(l);
+		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
 		if (is_64bit_memory(l)) {
 			u32 szhi, lhi;
 
@@ -288,7 +288,8 @@ static void pci_read_bases(struct pci_de
 			if (sz) {
 				res->flags = (l & IORESOURCE_ROM_ENABLE) |
 				  IORESOURCE_MEM | IORESOURCE_PREFETCH |
-				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE;
+				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
+				  IORESOURCE_SIZEALIGN;
 				res->start = l & PCI_ROM_ADDRESS_MASK;
 				res->end = res->start + (unsigned long) sz;
 			}
diff -puN drivers/pci/setup-bus.c~pci-clean-up-resource-alignment-management drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~pci-clean-up-resource-alignment-management
+++ a/drivers/pci/setup-bus.c
@@ -65,6 +65,7 @@ static void pbus_assign_resources_sorted
 		res = list->res;
 		idx = res - &list->dev->resource[0];
 		if (pci_assign_resource(list->dev, idx)) {
+			/* FIXME: get rid of this */
 			res->start = 0;
 			res->end = 0;
 			res->flags = 0;
@@ -326,6 +327,7 @@ static void pbus_size_io(struct pci_bus 
 	/* Alignment of the IO window is always 4K */
 	b_res->start = 4096;
 	b_res->end = b_res->start + size - 1;
+	b_res->flags |= IORESOURCE_STARTALIGN;
 }
 
 /* Calculate the size of the bus and minimal alignment which
@@ -400,6 +402,7 @@ static int pbus_size_mem(struct pci_bus 
 	}
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
+	b_res->flags |= IORESOURCE_STARTALIGN;
 	return 1;
 }
 
diff -puN drivers/pci/setup-res.c~pci-clean-up-resource-alignment-management drivers/pci/setup-res.c
--- a/drivers/pci/setup-res.c~pci-clean-up-resource-alignment-management
+++ a/drivers/pci/setup-res.c
@@ -137,10 +137,16 @@ int pci_assign_resource(struct pci_dev *
 
 	size = res->end - res->start + 1;
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
-	/* The bridge resources are special, as their
-	   size != alignment. Sizing routines return
-	   required alignment in the "start" field. */
-	align = (resno < PCI_BRIDGE_RESOURCES) ? size : res->start;
+
+	align = resource_alignment(res);
+	if (!align) {
+		printk(KERN_ERR "PCI: Cannot allocate resource (bogus "
+			"alignment) %d [%llx:%llx] (flags %lx) of %s\n",
+			resno, (unsigned long long)res->start,
+			(unsigned long long)res->end, res->flags,
+			pci_name(dev));
+		return -EINVAL;
+	}
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
@@ -164,8 +170,10 @@ int pci_assign_resource(struct pci_dev *
 			res->flags & IORESOURCE_IO ? "I/O" : "mem",
 			resno, (unsigned long long)size,
 			(unsigned long long)res->start, pci_name(dev));
-	} else if (resno < PCI_BRIDGE_RESOURCES) {
-		pci_update_resource(dev, res, resno);
+	} else {
+		res->flags &= ~IORESOURCE_STARTALIGN;
+		if (resno < PCI_BRIDGE_RESOURCES)
+			pci_update_resource(dev, res, resno);
 	}
 
 	return ret;
@@ -226,29 +234,25 @@ void pdev_sort_resources(struct pci_dev 
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
-		r_align = r->end - r->start;
-		
 		if (!(r->flags) || r->parent)
 			continue;
+
+		r_align = resource_alignment(r);
 		if (!r_align) {
-			printk(KERN_WARNING "PCI: Ignore bogus resource %d "
-				"[%llx:%llx] of %s\n",
+			printk(KERN_WARNING "PCI: bogus alignment of resource "
+				"%d [%llx:%llx] (flags %lx) of %s\n",
 				i, (unsigned long long)r->start,
-				(unsigned long long)r->end, pci_name(dev));
+				(unsigned long long)r->end, r->flags,
+				pci_name(dev));
 			continue;
 		}
-		r_align = (i < PCI_BRIDGE_RESOURCES) ? r_align + 1 : r->start;
 		for (list = head; ; list = list->next) {
 			resource_size_t align = 0;
 			struct resource_list *ln = list->next;
-			int idx;
 
-			if (ln) {
-				idx = ln->res - &ln->dev->resource[0];
-				align = (idx < PCI_BRIDGE_RESOURCES) ?
-					ln->res->end - ln->res->start + 1 :
-					ln->res->start;
-			}
+			if (ln)
+				align = resource_alignment(ln->res);
+
 			if (r_align > align) {
 				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 				if (!tmp)
diff -puN include/linux/ioport.h~pci-clean-up-resource-alignment-management include/linux/ioport.h
--- a/include/linux/ioport.h~pci-clean-up-resource-alignment-management
+++ a/include/linux/ioport.h
@@ -44,7 +44,9 @@ struct resource_list {
 #define IORESOURCE_CACHEABLE	0x00004000
 #define IORESOURCE_RANGELENGTH	0x00008000
 #define IORESOURCE_SHADOWABLE	0x00010000
-#define IORESOURCE_BUS_HAS_VGA	0x00080000
+
+#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
+#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
@@ -110,6 +112,7 @@ extern int allocate_resource(struct reso
 			     void *alignf_data);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
+resource_size_t resource_alignment(struct resource *res);
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
diff -puN kernel/resource.c~pci-clean-up-resource-alignment-management kernel/resource.c
--- a/kernel/resource.c~pci-clean-up-resource-alignment-management
+++ a/kernel/resource.c
@@ -486,6 +486,24 @@ int adjust_resource(struct resource *res
 
 EXPORT_SYMBOL(adjust_resource);
 
+/**
+ * resource_alignment - calculate resource's alignment
+ * @res: resource pointer
+ *
+ * Returns alignment on success, 0 (invalid alignment) on failure.
+ */
+resource_size_t resource_alignment(struct resource *res)
+{
+	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
+	case IORESOURCE_SIZEALIGN:
+		return res->end - res->start + 1;
+	case IORESOURCE_STARTALIGN:
+		return res->start;
+	default:
+		return 0;
+	}
+}
+
 /*
  * This is compatibility stuff for IO resources.
  *
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-alsa-dma-mmap-crash.patch
alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
pci-clean-up-resource-alignment-management.patch
alpha-handle-kcalloc-failure.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch
make-sure-nobodys-leaking-resources.patch

