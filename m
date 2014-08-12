From: akpm@linux-foundation.org
Subject: [merged]
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:26 -0700
Message-ID: <53ea6daa.6am6e3h447i5U1BV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54386 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaHLTk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:27 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1310095vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, david.vrabel@citrix.com, drjones@redhat.com, fengguang.wu@intel.com, holzheu@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/vmcore.c:mmap_vmcore: skip non-ram pages reported by hypervisors
has been removed from the -mm tree.  Its filename was
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: fs/proc/vmcore.c:mmap_vmcore: skip non-ram pages reported by hypervisors

We have a special check in read_vmcore() handler to check if the page was
reported as ram or not by the hypervisor (pfn_is_ram()).  However, when
vmcore is read with mmap() no such check is performed.  That can lead to
unpredictable results, e.g.  when running Xen PVHVM guest memcpy() after
mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
enormous load in both DomU and Dom0.

Fix the issue by mapping each non-ram page to the zero page.  Keep direct
path with remap_oldmem_pfn_range() to avoid looping through all pages on
bare metal.

The issue can also be solved by overriding remap_oldmem_pfn_range() in
xen-specific code, as remap_oldmem_pfn_range() was been designed for. 
That, however, would involve non-obvious xen code path for all x86 builds
with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
code on x86 arch from doing the same override.

[fengguang.wu@intel.com: remap_oldmem_pfn_checked() can be static]
[akpm@linux-foundation.org: clean up layout]
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   82 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors
+++ a/fs/proc/vmcore.c
@@ -328,6 +328,82 @@ static inline char *alloc_elfnotes_buf(s
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+/*
+ * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
+ * reported as not being ram with the zero page.
+ *
+ * @vma: vm_area_struct describing requested mapping
+ * @from: start remapping from
+ * @pfn: page frame number to start remapping to
+ * @size: remapping size
+ * @prot: protection bits
+ *
+ * Returns zero on success, -EAGAIN on failure.
+ */
+static int remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long from, unsigned long pfn,
+				    unsigned long size, pgprot_t prot)
+{
+	unsigned long map_size;
+	unsigned long pos_start, pos_end, pos;
+	unsigned long zeropage_pfn = my_zero_pfn(0);
+	size_t len = 0;
+
+	pos_start = pfn;
+	pos_end = pfn + (size >> PAGE_SHIFT);
+
+	for (pos = pos_start; pos < pos_end; ++pos) {
+		if (!pfn_is_ram(pos)) {
+			/*
+			 * We hit a page which is not ram. Remap the continuous
+			 * region between pos_start and pos-1 and replace
+			 * the non-ram page at pos with the zero page.
+			 */
+			if (pos > pos_start) {
+				/* Remap continuous region */
+				map_size = (pos - pos_start) << PAGE_SHIFT;
+				if (remap_oldmem_pfn_range(vma, from + len,
+							   pos_start, map_size,
+							   prot))
+					goto fail;
+				len += map_size;
+			}
+			/* Remap the zero page */
+			if (remap_oldmem_pfn_range(vma, from + len,
+						   zeropage_pfn,
+						   PAGE_SIZE, prot))
+				goto fail;
+			len += PAGE_SIZE;
+			pos_start = pos + 1;
+		}
+	}
+	if (pos > pos_start) {
+		/* Remap the rest */
+		map_size = (pos - pos_start) << PAGE_SHIFT;
+		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
+					   map_size, prot))
+			goto fail;
+	}
+	return 0;
+fail:
+	do_munmap(vma->vm_mm, from, len);
+	return -EAGAIN;
+}
+
+static int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
+			    unsigned long from, unsigned long pfn,
+			    unsigned long size, pgprot_t prot)
+{
+	/*
+	 * Check if oldmem_pfn_is_ram was registered to avoid
+	 * looping over all pages without a reason.
+	 */
+	if (oldmem_pfn_is_ram)
+		return remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
+	else
+		return remap_oldmem_pfn_range(vma, from, pfn, size, prot);
+}
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -387,9 +463,9 @@ static int mmap_vmcore(struct file *file
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
-						   paddr >> PAGE_SHIFT, tsz,
-						   vma->vm_page_prot))
+			if (vmcore_remap_oldmem_pfn(vma, vma->vm_start + len,
+						    paddr >> PAGE_SHIFT, tsz,
+						    vma->vm_page_prot))
 				goto fail;
 			size -= tsz;
 			start += tsz;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

origin.patch

