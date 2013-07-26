From: akpm@linux-foundation.org
Subject: + vmcore-introduce-remap_oldmem_pfn_range.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:20:55 -0700
Message-ID: <51f2da27.2Pkpe9fUmNn74Qf4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3GZUU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + vmcore-introduce-remap_oldmem_pfn_range.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:55 -0700


The patch titled
     Subject: vmcore: introduce remap_oldmem_pfn_range()
has been added to the -mm tree.  Its filename is
     vmcore-introduce-remap_oldmem_pfn_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-introduce-remap_oldmem_pfn_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-introduce-remap_oldmem_pfn_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: vmcore: introduce remap_oldmem_pfn_range()

For zfcpdump we can't map the HSA storage because it is only available via
a read interface.  Therefore, for the new vmcore mmap feature we have
introduce a new mechanism to create mappings on demand.

This patch introduces a new architecture function remap_oldmem_pfn_range()
that should be used to create mappings with remap_pfn_range() for oldmem
areas that can be directly mapped.  For zfcpdump this is everything
besides of the HSA memory.  For the areas that are not mapped by
remap_oldmem_pfn_range() a generic vmcore a new generic vmcore fault
handler mmap_vmcore_fault() is called.

This handler works as follows:

* Get already available or new page from page cache (find_or_create_page)
* Check if /proc/vmcore page is filled with data (PageUptodate)
* If yes:
  Return that page
* If no:
  Fill page using __vmcore_read(), set PageUptodate, and return page

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |   91 +++++++++++++++++++++++++++++++----
 include/linux/crash_dump.h |    3 +
 2 files changed, 86 insertions(+), 8 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-introduce-remap_oldmem_pfn_range fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-introduce-remap_oldmem_pfn_range
+++ a/fs/proc/vmcore.c
@@ -21,6 +21,7 @@
 #include <linux/crash_dump.h>
 #include <linux/list.h>
 #include <linux/vmalloc.h>
+#include <linux/pagemap.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -153,11 +154,35 @@ ssize_t __weak elfcorehdr_read_notes(cha
 	return read_from_oldmem(buf, count, ppos, 0);
 }
 
+/*
+ * Architectures may override this function to map oldmem
+ */
+int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+				  unsigned long from, unsigned long pfn,
+				  unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
+ * Copy to either kernel or user space
+ */
+static int copy_to(void *target, void *src, size_t size, int userbuf)
+{
+	if (userbuf) {
+		if (copy_to_user(target, src, size))
+			return -EFAULT;
+	} else {
+		memcpy(target, src, size);
+	}
+	return 0;
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
-static ssize_t read_vmcore(struct file *file, char __user *buffer,
-				size_t buflen, loff_t *fpos)
+static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
+			     int userbuf)
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
@@ -174,7 +199,7 @@ static ssize_t read_vmcore(struct file *
 	/* Read ELF core header */
 	if (*fpos < elfcorebuf_sz) {
 		tsz = min(elfcorebuf_sz - (size_t)*fpos, buflen);
-		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
+		if (copy_to(buffer, elfcorebuf + *fpos, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -192,7 +217,7 @@ static ssize_t read_vmcore(struct file *
 
 		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos, buflen);
 		kaddr = elfnotes_buf + *fpos - elfcorebuf_sz;
-		if (copy_to_user(buffer, kaddr, tsz))
+		if (copy_to(buffer, kaddr, tsz, userbuf))
 			return -EFAULT;
 		buflen -= tsz;
 		*fpos += tsz;
@@ -208,7 +233,7 @@ static ssize_t read_vmcore(struct file *
 		if (*fpos < m->offset + m->size) {
 			tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start, 1);
+			tmp = read_from_oldmem(buffer, tsz, &start, userbuf);
 			if (tmp < 0)
 				return tmp;
 			buflen -= tsz;
@@ -225,6 +250,55 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
+static ssize_t read_vmcore(struct file *file, char __user *buffer,
+			   size_t buflen, loff_t *fpos)
+{
+	return __read_vmcore(buffer, buflen, fpos, 1);
+}
+
+/*
+ * The vmcore fault handler uses the page cache and fills data using the
+ * standard __vmcore_read() function.
+ *
+ * On s390 the fault handler is used for memory regions that can't be mapped
+ * directly with remap_pfn_range().
+ */
+static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+#ifdef CONFIG_S390
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	pgoff_t index = vmf->pgoff;
+	struct page *page;
+	loff_t offset;
+	char *buf;
+	int rc;
+
+	page = find_or_create_page(mapping, index, GFP_KERNEL);
+	if (!page)
+		return VM_FAULT_OOM;
+	if (!PageUptodate(page)) {
+		offset = (loff_t) index << PAGE_CACHE_SHIFT;
+		buf = __va((page_to_pfn(page) << PAGE_SHIFT));
+		rc = __read_vmcore(buf, PAGE_SIZE, &offset, 0);
+		if (rc < 0) {
+			unlock_page(page);
+			page_cache_release(page);
+			return (rc == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
+		}
+		SetPageUptodate(page);
+	}
+	unlock_page(page);
+	vmf->page = page;
+	return 0;
+#else
+	return VM_FAULT_SIGBUS;
+#endif
+}
+
+static const struct vm_operations_struct vmcore_mmap_ops = {
+	.fault = mmap_vmcore_fault,
+};
+
 /**
  * alloc_elfnotes_buf - allocate buffer for ELF note segment in
  *                      vmalloc memory
@@ -271,6 +345,7 @@ static int mmap_vmcore(struct file *file
 
 	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_ops = &vmcore_mmap_ops;
 
 	len = 0;
 
@@ -312,9 +387,9 @@ static int mmap_vmcore(struct file *file
 
 			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
-			if (remap_pfn_range(vma, vma->vm_start + len,
-					    paddr >> PAGE_SHIFT, tsz,
-					    vma->vm_page_prot))
+			if (remap_oldmem_pfn_range(vma, vma->vm_start + len,
+						   paddr >> PAGE_SHIFT, tsz,
+						   vma->vm_page_prot))
 				goto fail;
 			size -= tsz;
 			start += tsz;
diff -puN include/linux/crash_dump.h~vmcore-introduce-remap_oldmem_pfn_range include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~vmcore-introduce-remap_oldmem_pfn_range
+++ a/include/linux/crash_dump.h
@@ -17,6 +17,9 @@ extern int __weak elfcorehdr_alloc(unsig
 extern void __weak elfcorehdr_free(unsigned long long addr);
 extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
 extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
+					 unsigned long from, unsigned long pfn,
+					 unsigned long size, pgprot_t prot);
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch

