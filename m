From: akpm@linux-foundation.org
Subject: [merged] vmcore-support-mmap-on-proc-vmcore.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:25:30 -0700
Message-ID: <51db122a.1tshRQiGWW6Fs3gU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHTZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, muvarov@gmail.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, arnd@arndb.de, d.hatayama@jp.fujitsu.com

Subject: [merged] vmcore-support-mmap-on-proc-vmcore.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,arnd@arndb.de,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,muvarov@gmail.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:30 -0700


The patch titled
     Subject: vmcore: support mmap() on /proc/vmcore
has been removed from the -mm tree.  Its filename was
     vmcore-support-mmap-on-proc-vmcore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: support mmap() on /proc/vmcore

This patch introduces mmap_vmcore().

Don't permit writable nor executable mapping even with mprotect() because
this mmap() is aimed at reading crash dump memory.  Non-writable mapping
is also requirement of remap_pfn_range() when mapping linear pages on
non-consecutive physical pages; see is_cow_mapping().

Set VM_MIXEDMAP flag to remap memory by remap_pfn_range and by
remap_vmalloc_range_pertial at the same time for a single vma. 
do_munmap() can correctly clean partially remapped vma with two functions
in abnormal case.  See zap_pte_range(), vm_normal_page() and their
comments for details.

On x86-32 PAE kernels, mmap() supports at most 16TB memory only.  This
limitation comes from the fact that the third argument of
remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.

[akpm@linux-foundation.org: use min(), switch to conventional error-unwinding approach]
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Tested-by: Maxim Uvarov <muvarov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |  136 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 116 insertions(+), 20 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore
+++ a/fs/proc/vmcore.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/crash_dump.h>
 #include <linux/list.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -194,9 +195,122 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
+/**
+ * alloc_elfnotes_buf - allocate buffer for ELF note segment in
+ *                      vmalloc memory
+ *
+ * @notes_sz: size of buffer
+ *
+ * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
+ * the buffer to user-space by means of remap_vmalloc_range().
+ *
+ * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
+ * disabled and there's no need to allow users to mmap the buffer.
+ */
+static inline char *alloc_elfnotes_buf(size_t notes_sz)
+{
+#ifdef CONFIG_MMU
+	return vmalloc_user(notes_sz);
+#else
+	return vzalloc(notes_sz);
+#endif
+}
+
+/*
+ * Disable mmap_vmcore() if CONFIG_MMU is not defined. MMU is
+ * essential for mmap_vmcore() in order to map physically
+ * non-contiguous objects (ELF header, ELF note segment and memory
+ * regions in the 1st kernel pointed to by PT_LOAD entries) into
+ * virtually contiguous user-space in ELF layout.
+ */
+#ifdef CONFIG_MMU
+static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size = vma->vm_end - vma->vm_start;
+	u64 start, end, len, tsz;
+	struct vmcore *m;
+
+	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	end = start + size;
+
+	if (size > vmcore_size || end > vmcore_size)
+		return -EINVAL;
+
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+		return -EPERM;
+
+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	len = 0;
+
+	if (start < elfcorebuf_sz) {
+		u64 pfn;
+
+		tsz = min(elfcorebuf_sz - (size_t)start, size);
+		pfn = __pa(elfcorebuf + start) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, vma->vm_start, pfn, tsz,
+				    vma->vm_page_prot))
+			return -EAGAIN;
+		size -= tsz;
+		start += tsz;
+		len += tsz;
+
+		if (size == 0)
+			return 0;
+	}
+
+	if (start < elfcorebuf_sz + elfnotes_sz) {
+		void *kaddr;
+
+		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)start, size);
+		kaddr = elfnotes_buf + start - elfcorebuf_sz;
+		if (remap_vmalloc_range_partial(vma, vma->vm_start + len,
+						kaddr, tsz))
+			goto fail;
+		size -= tsz;
+		start += tsz;
+		len += tsz;
+
+		if (size == 0)
+			return 0;
+	}
+
+	list_for_each_entry(m, &vmcore_list, list) {
+		if (start < m->offset + m->size) {
+			u64 paddr = 0;
+
+			tsz = min_t(size_t, m->offset + m->size - start, size);
+			paddr = m->paddr + start - m->offset;
+			if (remap_pfn_range(vma, vma->vm_start + len,
+					    paddr >> PAGE_SHIFT, tsz,
+					    vma->vm_page_prot))
+				goto fail;
+			size -= tsz;
+			start += tsz;
+			len += tsz;
+
+			if (size == 0)
+				return 0;
+		}
+	}
+
+	return 0;
+fail:
+	do_munmap(vma->vm_mm, vma->vm_start, len);
+	return -EAGAIN;
+}
+#else
+static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
+{
+	return -ENOSYS;
+}
+#endif
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 	.llseek		= default_llseek,
+	.mmap		= mmap_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)
@@ -348,7 +462,6 @@ static int __init merge_note_headers_elf
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
-	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
@@ -361,18 +474,10 @@ static int __init merge_note_headers_elf
 		return rc;
 
 	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
-	*notes_buf = vzalloc(*notes_sz);
+	*notes_buf = alloc_elfnotes_buf(*notes_sz);
 	if (!*notes_buf)
 		return -ENOMEM;
 
-	/*
-	 * Allow users to remap ELF note segment buffer on vmalloc memory using
-	 * remap_vmalloc_range.()
-	 */
-	vm = find_vm_area(*notes_buf);
-	BUG_ON(!vm);
-	vm->flags |= VM_USERMAP;
-
 	rc = copy_notes_elf64(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
@@ -536,7 +641,6 @@ static int __init merge_note_headers_elf
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
-	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
@@ -549,18 +653,10 @@ static int __init merge_note_headers_elf
 		return rc;
 
 	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
-	*notes_buf = vzalloc(*notes_sz);
+	*notes_buf = alloc_elfnotes_buf(*notes_sz);
 	if (!*notes_buf)
 		return -ENOMEM;
 
-	/*
-	 * Allow users to remap ELF note segment buffer on vmalloc memory using
-	 * remap_vmalloc_range()
-	 */
-	vm = find_vm_area(*notes_buf);
-	BUG_ON(!vm);
-	vm->flags |= VM_USERMAP;
