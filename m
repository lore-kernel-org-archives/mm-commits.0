From: akpm@linux-foundation.org
Subject: [merged]
 vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:28 -0700
Message-ID: <51db1228.uSNc2vdL8N5r0gB5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: [merged] vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:28 -0700


The patch titled
     Subject: vmcore: calculate vmcore file size from buffer size and total size of vmcore objects
has been removed from the -mm tree.  Its filename was
     vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: calculate vmcore file size from buffer size and total size of vmcore objects

The previous patches newly added holes before each chunk of memory and the
holes need to be count in vmcore file size.  There are two ways to count
file size in such a way:

1) suppose m is a poitner to the last vmcore object in vmcore_list.
   Then file size is (m->offset + m->size), or

2) calculate sum of size of buffers for ELF header, program headers,
   ELF note segments and objects in vmcore_list.

Although 1) is more direct and simpler than 2), 2) seems better in that it
reflects internal object structure of /proc/vmcore.  Thus, this patch
changes get_vmcore_size_elf{64, 32} so that it calculates size in the way
of 2).

As a result, both get_vmcore_size_elf{64, 32} have the same definition. 
Merge them as get_vmcore_size.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects
+++ a/fs/proc/vmcore.c
@@ -204,36 +204,15 @@ static struct vmcore* __init get_new_ele
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
-static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
+static u64 __init get_vmcore_size(size_t elfsz, size_t elfnotesegsz,
+				  struct list_head *vc_list)
 {
-	int i;
 	u64 size;
-	Elf64_Ehdr *ehdr_ptr;
-	Elf64_Phdr *phdr_ptr;
-
-	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
-	size = elfsz;
-	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
-		size += phdr_ptr->p_memsz;
-		phdr_ptr++;
-	}
-	return size;
-}
-
-static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
-{
-	int i;
-	u64 size;
-	Elf32_Ehdr *ehdr_ptr;
-	Elf32_Phdr *phdr_ptr;
+	struct vmcore *m;
 
-	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
-	size = elfsz;
-	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
-		size += phdr_ptr->p_memsz;
-		phdr_ptr++;
+	size = elfsz + elfnotesegsz;
+	list_for_each_entry(m, vc_list, list) {
+		size += m->size;
 	}
 	return size;
 }
@@ -856,20 +835,19 @@ static int __init parse_crash_elf_header
 		rc = parse_crash_elf64_headers();
 		if (rc)
 			return rc;
-
-		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = parse_crash_elf32_headers();
 		if (rc)
 			return rc;
