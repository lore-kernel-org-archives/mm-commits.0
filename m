From: akpm@linux-foundation.org
Subject: + mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch added to -mm tree
Date: Fri, 11 Jul 2014 15:11:35 -0700
Message-ID: <53c06117.NiqwwJRwsBvWTFom%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:33221 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaGKWLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jul 2014 18:11:36 -0400
Received: by mail-ie0-f202.google.com with SMTP id rd18so360960iec.5
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2014 15:11:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, david.vrabel@citrix.com, drjones@redhat.com, holzheu@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch

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
Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4

Changes from v3:
- multi line comment style changes
- minor code style changes

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   86 +++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4
+++ a/fs/proc/vmcore.c
@@ -329,20 +329,20 @@ static inline char *alloc_elfnotes_buf(s
  */
 #ifdef CONFIG_MMU
 /*
- * remap_oldmem_pfn_checked - do remap_oldmem_pfn replacing all pages reported
- * as not being ram with the zero page.
+ * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
+ * reported as not being ram with the zero page.
  *
  * @vma: vm_area_struct describing requested mapping
- * @vma_addr: start remapping from
+ * @from: start remapping from
  * @pfn: page frame number to start remapping to
  * @size: remapping size
+ * @prot: protection bits
  *
- * Returns the remapped length. If no errors were hit during the remapping it
- * should be equal to size.
+ * Returns zero on success, -EAGAIN on failure.
  */
-static u64 remap_oldmem_pfn_checked(struct vm_area_struct *vma,
-				    unsigned long vma_addr, unsigned long pfn,
-				    unsigned long size)
+int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
+			     unsigned long pfn, unsigned long size,
+			     pgprot_t prot)
 {
 	size_t map_size;
 	unsigned long pos_start, pos_end, pos;
@@ -354,25 +354,25 @@ static u64 remap_oldmem_pfn_checked(stru
 
 	for (pos = pos_start; pos < pos_end; ++pos) {
 		if (!pfn_is_ram(pos)) {
-			/* We hit a page which is not ram. Remap the continuous
+			/*
+			 * We hit a page which is not ram. Remap the continuous
 			 * region between pos_start and pos-1 and replace
 			 * the non-ram page at pos with the zero page.
 			 */
 			if (pos > pos_start) {
 				/* Remap continuous region */
 				map_size = (pos - pos_start) << PAGE_SHIFT;
-				if (remap_oldmem_pfn_range(vma, vma_addr + len,
+				if (remap_oldmem_pfn_range(vma, from + len,
 							   pos_start, map_size,
-							   vma->vm_page_prot))
-					return len;
+							   prot))
+					goto fail;
 				len += map_size;
 			}
 			/* Remap the zero page */
-			if (remap_oldmem_pfn_range(vma, vma_addr + len,
+			if (remap_oldmem_pfn_range(vma, from + len,
 						   zeropage_pfn,
-						   PAGE_SIZE,
-						   vma->vm_page_prot))
-				return len;
+						   PAGE_SIZE, prot))
+				goto fail;
 			len += PAGE_SIZE;
 			pos_start = pos + 1;
 		}
@@ -380,13 +380,29 @@ static u64 remap_oldmem_pfn_checked(stru
 	if (pos > pos_start) {
 		/* Remap the rest */
 		map_size = (pos - pos_start) << PAGE_SHIFT;
-		if (remap_oldmem_pfn_range(vma, vma_addr + len, pos_start,
-					   map_size,
-					   vma->vm_page_prot))
-			return len;
+		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
+					   map_size, vma->vm_page_prot))
+			goto fail;
 		len += map_size;
 	}
-	return len;
+	return 0;
+fail:
+	do_munmap(vma->vm_mm, from, len);
+	return -EAGAIN;
+}
+
+int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
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
 }
 
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
@@ -448,31 +464,13 @@ static int mmap_vmcore(struct file *file
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-
-			/* Check if oldmem_pfn_is_ram was registered to avoid
-			   looping over all pages without a reason. */
-			if (oldmem_pfn_is_ram) {
-				u64 original_len;
-				unsigned long pfn, vma_addr;
-
-				pfn = paddr >> PAGE_SHIFT;
-				vma_addr = vma->vm_start + len;
-				original_len = len;
-				len += remap_oldmem_pfn_checked(vma, vma_addr,
-								pfn, tsz);
-				if (len != original_len + tsz)
-					goto fail;
-			} else {
-				if (remap_oldmem_pfn_range(vma,
-							   vma->vm_start + len,
-							   paddr >> PAGE_SHIFT,
-							   tsz,
-							   vma->vm_page_prot))
-					goto fail;
-				len += tsz;
-			}
+			if (vmcore_remap_oldmem_pfn(vma, vma->vm_start + len,
+						    paddr >> PAGE_SHIFT, tsz,
+						    vma->vm_page_prot))
+				goto fail;
 			size -= tsz;
 			start += tsz;
+			len += tsz;
 
 			if (size == 0)
 				return 0;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch

