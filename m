From: akpm@linux-foundation.org
Subject: [nacked] vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:29 -0700
Message-ID: <20130320233229.81EED5A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:33343 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3CTXca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:30 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so211824qea.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: allocate buffer for ELF headers on page-size alignment
has been removed from the -mm tree.  Its filename was
     vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: allocate buffer for ELF headers on page-size alignment

Allocate buffer for ELF headers on page-size aligned boudary to satisfy
mmap() requirement.  For this, __get_free_pages() is used instead of
kmalloc().

Also, later patch will decrease actually used buffer size for ELF headers,
so it's necessary to keep original buffer size and actually used buffer
size separately.  elfcorebuf_sz_orig keeps the original one and
elfcorebuf_sz the actually used one.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment
+++ a/fs/proc/vmcore.c
@@ -31,6 +31,7 @@ static LIST_HEAD(vmcore_list);
 /* Stores the pointer to the buffer containing kernel elf core headers. */
 static char *elfcorebuf;
 static size_t elfcorebuf_sz;
+static size_t elfcorebuf_sz_orig;
 
 /* Total size of vmcore file. */
 static u64 vmcore_size;
@@ -608,13 +609,16 @@ static int __init parse_crash_elf64_head
 
 	/* Read in all elf headers. */
 	elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = elfcorebuf_sz;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
 	rc = read_from_oldmem(elfcorebuf, sizeof(Elf64_Ehdr), &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	addr = elfcorehdr_addr + ehdr.e_phoff;
@@ -629,13 +633,15 @@ static int __init parse_crash_elf64_head
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
 	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
@@ -671,7 +677,9 @@ static int __init parse_crash_elf32_head
 
 	/* Read in all elf headers. */
 	elfcorebuf_sz = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
-	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
+	elfcorebuf_sz_orig = elfcorebuf_sz;
+	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
@@ -684,7 +692,8 @@ static int __init parse_crash_elf32_head
 	rc = read_from_oldmem(elfcorebuf + sizeof(Elf32_Ehdr),
 			      ehdr.e_phnum * sizeof(Elf32_Phdr), &addr, 0);
 	if (rc < 0) {
-		kfree(elfcorebuf);
+		free_pages((unsigned long)elfcorebuf,
+			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
 	((Elf32_Ehdr *)elfcorebuf)->e_phoff = sizeof(Elf32_Ehdr);
@@ -692,13 +701,15 @@ static int __init parse_crash_elf32_head
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
 	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
@@ -780,7 +791,8 @@ void vmcore_cleanup(void)
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

vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch
vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel.patch
vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel.patch
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

