From: akpm@linux-foundation.org
Subject: + mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
 added to -mm tree
Date: Wed, 09 Jul 2014 15:04:47 -0700
Message-ID: <53bdbc7f.PnwSWw3DhzSFd5+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51489 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaGIWEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jul 2014 18:04:48 -0400
Received: by mail-qa0-f73.google.com with SMTP id m5so1178998qaj.0
        for <mm-commits@vger.kernel.org>; Wed, 09 Jul 2014 15:04:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, david.vrabel@citrix.com, drjones@redhat.com, holzheu@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/vmcore.c:mmap_vmcore: skip non-ram pages reported by hypervisors
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   89 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 5 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors
+++ a/fs/proc/vmcore.c
@@ -328,6 +328,67 @@ static inline char *alloc_elfnotes_buf(s
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+/*
+ * remap_oldmem_pfn_checked - do remap_oldmem_pfn replacing all pages reported
+ * as not being ram with the zero page.
+ *
+ * @vma: vm_area_struct describing requested mapping
+ * @vma_addr: start remapping from
+ * @pfn: page frame number to start remapping to
+ * @size: remapping size
+ *
+ * Returns the remapped length. If no errors were hit during the remapping it
+ * should be equal to size.
+ */
+static u64 remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long vma_addr, unsigned long pfn,
+				    unsigned long size)
+{
+	size_t map_size;
+	unsigned long pos_start, pos_end, pos;
+	unsigned long zeropage_pfn = my_zero_pfn(0);
+	u64 len = 0;
+
+	pos_start = pfn;
+	pos_end = pfn + (size >> PAGE_SHIFT);
+
+	for (pos = pos_start; pos < pos_end; ++pos) {
+		if (!pfn_is_ram(pos)) {
+			/* We hit a page which is not ram. Remap the continuous
+			 * region between pos_start and pos-1 and replace
+			 * the non-ram page at pos with the zero page.
+			 */
+			if (pos > pos_start) {
+				/* Remap continuous region */
+				map_size = (pos - pos_start) << PAGE_SHIFT;
+				if (remap_oldmem_pfn_range(vma, vma_addr + len,
+							   pos_start, map_size,
+							   vma->vm_page_prot))
+					return len;
+				len += map_size;
+			}
+			/* Remap the zero page */
+			if (remap_oldmem_pfn_range(vma, vma_addr + len,
+						   zeropage_pfn,
+						   PAGE_SIZE,
+						   vma->vm_page_prot))
+				return len;
+			len += PAGE_SIZE;
+			pos_start = pos + 1;
+		}
+	}
+	if (pos > pos_start) {
+		/* Remap the rest */
+		map_size = (pos - pos_start) << PAGE_SHIFT;
+		if (remap_oldmem_pfn_range(vma, vma_addr + len, pos_start,
+					   map_size,
+					   vma->vm_page_prot))
+			return len;
+		len += map_size;
+	}
+	return len;
+}
+
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -387,13 +448,31 @@ static int mmap_vmcore(struct file *file
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
-						   paddr >> PAGE_SHIFT, tsz,
-						   vma->vm_page_prot))
-				goto fail;
+
+			/* Check if oldmem_pfn_is_ram was registered to avoid
+			   looping over all pages without a reason. */
+			if (oldmem_pfn_is_ram) {
+				u64 original_len;
+				unsigned long pfn, vma_addr;
+
+				pfn = paddr >> PAGE_SHIFT;
+				vma_addr = vma->vm_start + len;
+				original_len = len;
+				len += remap_oldmem_pfn_checked(vma, vma_addr,
+								pfn, tsz);
+				if (len != original_len + tsz)
+					goto fail;
+			} else {
+				if (remap_oldmem_pfn_range(vma,
+							   vma->vm_start + len,
+							   paddr >> PAGE_SHIFT,
+							   tsz,
+							   vma->vm_page_prot))
+					goto fail;
+				len += tsz;
+			}
 			size -= tsz;
 			start += tsz;
-			len += tsz;
 
 			if (size == 0)
 				return 0;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

