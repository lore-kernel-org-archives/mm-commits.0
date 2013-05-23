From: akpm@linux-foundation.org
Subject: +
 vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch added
 to -mm tree
Date: Thu, 23 May 2013 15:25:01 -0700
Message-ID: <519e973d.U9LeIIzOVv272Lqu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab3EWWZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 18:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: + vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 15:25:01 -0700


The patch titled
     Subject: vmcore: allocate buffer for ELF headers on page-size alignment
has been added to the -mm tree.  Its filename is
     vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: allocate buffer for ELF headers on page-size alignment

Allocate ELF headers on page-size boundary using __get_free_pages()
instead of kmalloc().

Later patch will merge PT_NOTE entries into a single unique one and
decrease the buffer size actually used.  Keep original buffer size in
variable elfcorebuf_sz_orig to kfree the buffer later and actually used
buffer size with rounded up to page-size boundary in variable
elfcorebuf_sz separately.

The size of part of the ELF buffer exported from /proc/vmcore is
elfcorebuf_sz.

The merged, removed PT_NOTE entries, i.e.  the range [elfcorebuf_sz,
elfcorebuf_sz_orig], is filled with 0.

Use size of the ELF headers as an initial offset value in
set_vmcore_list_offsets_elf{64,32} and
process_ptload_program_headers_elf{64,32} in order to indicate that the
offset includes the holes towards the page boundary.

As a result, both set_vmcore_list_offsets_elf{64,32} have the same
definition.  Merge them as set_vmcore_list_offsets.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   94 ++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 52 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment
+++ a/fs/proc/vmcore.c
@@ -32,6 +32,7 @@ static LIST_HEAD(vmcore_list);
 /* Stores the pointer to the buffer containing kernel elf core headers. */
 static char *elfcorebuf;
 static size_t elfcorebuf_sz;
+static size_t elfcorebuf_sz_orig;
 
 /* Total size of vmcore file. */
 static u64 vmcore_size;
@@ -186,7 +187,7 @@ static struct vmcore* __init get_new_ele
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
-static u64 __init get_vmcore_size_elf64(char *elfptr)
+static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
 {
 	int i;
 	u64 size;
@@ -195,7 +196,7 @@ static u64 __init get_vmcore_size_elf64(
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
-	size = sizeof(Elf64_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
+	size = elfsz;
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -203,7 +204,7 @@ static u64 __init get_vmcore_size_elf64(
 	return size;
 }
 
-static u64 __init get_vmcore_size_elf32(char *elfptr)
+static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
 {
 	int i;
 	u64 size;
@@ -212,7 +213,7 @@ static u64 __init get_vmcore_size_elf32(
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
-	size = sizeof(Elf32_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
+	size = elfsz;
 	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
 		size += phdr_ptr->p_memsz;
 		phdr_ptr++;
@@ -294,6 +295,8 @@ static int __init merge_note_headers_elf
 	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
 	*elfsz = *elfsz - i;
 	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
+	memset(elfptr + *elfsz, 0, i);
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -375,6 +378,8 @@ static int __init merge_note_headers_elf
 	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
 	*elfsz = *elfsz - i;
 	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf32_Ehdr)-sizeof(Elf32_Phdr)));
+	memset(elfptr + *elfsz, 0, i);
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
@@ -398,8 +403,7 @@ static int __init process_ptload_program
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
+	vmcore_off = elfsz +
 			phdr_ptr->p_memsz; /* Note sections */
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
@@ -435,8 +439,7 @@ static int __init process_ptload_program
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
+	vmcore_off = elfsz +
 			phdr_ptr->p_memsz; /* Note sections */
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
@@ -459,38 +462,14 @@ static int __init process_ptload_program
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
-						struct list_head *vc_list)
+static void __init set_vmcore_list_offsets(size_t elfsz,
+					   struct list_head *vc_list)
 {
 	loff_t vmcore_off;
-	Elf64_Ehdr *ehdr_ptr;
 	struct vmcore *m;
 
-	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-
-	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
-
-	list_for_each_entry(m, vc_list, list) {
-		m->offset = vmcore_off;
-		vmcore_off += m->size;
-	}
-}
-
-/* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
-						struct list_head *vc_list)
-{
-	loff_t vmcore_off;
-	Elf32_Ehdr *ehdr_ptr;
-	struct vmcore *m;
-
-	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
@@ -526,30 +505,35 @@ static int __init parse_crash_elf64_head
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
+	elfcorebuf_sz = elfcorebuf_sz_orig;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	rc = process_ptload_program_headers_elf64(elfcorebuf, elfcorebuf_sz,
 							&vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -581,30 +565,35 @@ static int __init parse_crash_elf32_head
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
+	elfcorebuf_sz = elfcorebuf_sz_orig;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
+	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	rc = process_ptload_program_headers_elf32(elfcorebuf, elfcorebuf_sz,
 								&vmcore_list);
 	if (rc) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets(elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -629,14 +618,14 @@ static int __init parse_crash_elf_header
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
+		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = parse_crash_elf32_headers();
 		if (rc)
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
+		vmcore_size = get_vmcore_size_elf32(elfcorebuf, elfcorebuf_sz);
 	} else {
 		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
@@ -683,7 +672,8 @@ void vmcore_cleanup(void)
 		list_del(&m->list);
 		kfree(m);
 	}
-	kfree(elfcorebuf);
+	free_pages((unsigned long)elfcorebuf,
+		   get_order(elfcorebuf_sz_orig));
 	elfcorebuf = NULL;
 }
 EXPORT_SYMBOL_GPL(vmcore_cleanup);
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

include-linux-mmh-add-page_aligned-helper.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch

