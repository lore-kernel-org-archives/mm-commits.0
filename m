From: akpm@linux-foundation.org
Subject: [nacked] vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:38 -0700
Message-ID: <20130320233238.8C51031C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38520 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:40 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so211845vcb.2
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: copy non page-size aligned head and tail pages in 2nd kernel
has been removed from the -mm tree.  Its filename was
     vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: copy non page-size aligned head and tail pages in 2nd kernel

Due to mmap() requirement, we need to copy pages not starting or ending
with page-size aligned address in 2nd kernel and to map them to
user-space.

For example, see the map below:

    00000000-00010000 : reserved
    00010000-0009f800 : System RAM
    0009f800-000a0000 : reserved

where the System RAM ends with 0x9f800 that is not page-size aligned. 
This map is divided into two parts:

    00010000-0009f000
    0009f000-0009f800

and the first one is kept in old memory and the 2nd one is copied into
buffer on 2nd kernel.

This kind of non-page-size-aligned area can always occur since any part of
System RAM can be converted into reserved area at runtime.

If not doing copying like this and if remapping non page-size aligned
pages on old memory directly, mmap() had to export memory which is not
dump target to user-space.  In the above example this is reserved
0x9f800-0xa0000.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |  192 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 172 insertions(+), 20 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel
+++ a/fs/proc/vmcore.c
@@ -472,11 +472,10 @@ static int __init process_ptload_program
 						size_t elfsz,
 						struct list_head *vc_list)
 {
-	int i;
+	int i, rc;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
@@ -486,20 +485,97 @@ static int __init process_ptload_program
 						  PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
+		u64 start, end, rest;
+
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
+		start = phdr_ptr->p_offset;
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		rest = phdr_ptr->p_memsz;
+
+		if (start & ~PAGE_MASK) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = start;
+			len = min(roundup(start,PAGE_SIZE), end) - start;
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
+					      &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0 &&
+		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
+			u64 paddr, len;
+			struct vmcore *new;
+
+			paddr = roundup(start, PAGE_SIZE);
+			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
+
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = paddr;
+			new->size = len;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = rounddown(end, PAGE_SIZE);
+			len = end - rounddown(end, PAGE_SIZE);
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf, len, &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
 
 		/* Update the program header offset. */
 		phdr_ptr->p_offset = vmcore_off;
-		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
+		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
 	}
 	return 0;
 }
@@ -508,11 +584,10 @@ static int __init process_ptload_program
 						size_t elfsz,
 						struct list_head *vc_list)
 {
-	int i;
+	int i, rc;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
@@ -522,20 +597,97 @@ static int __init process_ptload_program
 						 PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
+		u64 start, end, rest;
+
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
+		start = phdr_ptr->p_offset;
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		rest = phdr_ptr->p_memsz;
+
+		if (start & ~PAGE_MASK) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = start;
+			len = min(roundup(start,PAGE_SIZE), end) - start;
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
+					      &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0 &&
+		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
+			u64 paddr, len;
+			struct vmcore *new;
+
+			paddr = roundup(start, PAGE_SIZE);
+			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
+
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = paddr;
+			new->size = len;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = rounddown(end, PAGE_SIZE);
+			len = end - rounddown(end, PAGE_SIZE);
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf, len, &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
 
 		/* Update the program header offset */
 		phdr_ptr->p_offset = vmcore_off;
-		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
+		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch
vmcore-clean-up-read_vmcore.patch
vmcore-read-buffers-for-vmcore-objects-copied-from-old-memory.patch
vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch
kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

