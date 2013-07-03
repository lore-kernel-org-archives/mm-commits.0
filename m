From: akpm@linux-foundation.org
Subject: [folded-merged] vmcore-support-mmap-on-proc-vmcore-fix-2.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:31:39 -0700
Message-ID: <51d4983b.l7pukr6W9oNObX46%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GCVbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, arnd@arndb.de, d.hatayama@jp.fujitsu.com

Subject: [folded-merged] vmcore-support-mmap-on-proc-vmcore-fix-2.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,arnd@arndb.de,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:31:39 -0700


The patch titled
     Subject: vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
has been removed from the -mm tree.  Its filename was
     vmcore-support-mmap-on-proc-vmcore-fix-2.patch

This patch was dropped because it was folded into vmcore-support-mmap-on-proc-vmcore.patch

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined

From Arnd's report of a link-time build error in vmcore.c, it turned out
that mmap_vmcore() work overlooked no-MMU configuraiton.

In the current design, it's impossible to implement mmap_vmcore() for
no-MMU configuration since MMU is essential in order to map physically
non-contiguous objects (ELF header, ELF note segment and memory regions in
the 1st kernel pointed to by PT_LOAD entries) into virtually contiguous
user-space in ELF layout.

Hence, this patch disables mmap_vmcore() if CONFIG_MMU is not defined,
returning -ENOSYS.

Another change is to fix the build error by using vmalloc_user() instead
of calling vzalloc() and find_vm_area() in order, by which we no longer
need to call find_vm_area() in vmcore.c that has no counterpart on non-MMU
configuration.

Also, on no-MMU configuration, because we don't export buffer for ELF note
segment to user-space, we use vzalloc() to allocate the buffer. 
Therefore, we use differnet functions to allocate the buffer for ELF note
segment.  To avoid code duplication, introduce a helper
alloc_elfnotes_buf().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   57 +++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore-fix-2 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore-fix-2
+++ a/fs/proc/vmcore.c
@@ -195,6 +195,35 @@ static ssize_t read_vmcore(struct file *
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
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -271,6 +300,12 @@ fail:
 	do_munmap(vma->vm_mm, vma->vm_start, len);
 	return -EAGAIN;
 }
+#else
+static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
+{
+	return -ENOSYS;
+}
+#endif
 
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
@@ -427,7 +462,6 @@ static int __init merge_note_headers_elf
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
-	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
@@ -440,18 +474,10 @@ static int __init merge_note_headers_elf
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
@@ -615,7 +641,6 @@ static int __init merge_note_headers_elf
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
-	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
@@ -628,18 +653,10 @@ static int __init merge_note_headers_elf
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
