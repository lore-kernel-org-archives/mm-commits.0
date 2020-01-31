From: akpm@linux-foundation.org
Subject: [merged]
 elf-smaller-code-generation-around-auxv-vector-fill.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:20:41 -0800
Message-ID: <20200131232041.3RURkE5FD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgAaXUm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: smaller code generation around auxv vector fill
has been removed from the -mm tree.  Its filename was
     elf-smaller-code-generation-around-auxv-vector-fill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: smaller code generation around auxv vector fill

Filling auxv vector as array with index (auxv[i++] = ...) generates
terrible code.  "saved_auxv" should be reworked because it is the worst
member of mm_struct by size/usefullness ratio but do it later.

Meanwhile help gcc a little with *auxv++ idiom.

Space savings on x86_64:

	add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-127 (-127)
	Function                                     old     new   delta
	load_elf_binary                             5470    5343    -127

Link: http://lkml.kernel.org/r/20191208172301.GD19716@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/binfmt_elf.c~elf-smaller-code-generation-around-auxv-vector-fill
+++ a/fs/binfmt_elf.c
@@ -176,7 +176,7 @@ create_elf_tables(struct linux_binprm *b
 	unsigned char k_rand_bytes[16];
 	int items;
 	elf_addr_t *elf_info;
-	int ei_index = 0;
+	int ei_index;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
 
@@ -230,8 +230,8 @@ create_elf_tables(struct linux_binprm *b
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
 #define NEW_AUX_ENT(id, val) \
 	do { \
-		elf_info[ei_index++] = id; \
-		elf_info[ei_index++] = val; \
+		*elf_info++ = id; \
+		*elf_info++ = val; \
 	} while (0)
 
 #ifdef ARCH_DLINFO
@@ -275,12 +275,13 @@ create_elf_tables(struct linux_binprm *b
 	}
 #undef NEW_AUX_ENT
 	/* AT_NULL is zero; clear the rest too */
-	memset(&elf_info[ei_index], 0,
-	       sizeof current->mm->saved_auxv - ei_index * sizeof elf_info[0]);
+	memset(elf_info, 0, (char *)current->mm->saved_auxv +
+			sizeof(current->mm->saved_auxv) - (char *)elf_info);
 
 	/* And advance past the AT_NULL entry.  */
-	ei_index += 2;
+	elf_info += 2;
 
+	ei_index = elf_info - (elf_addr_t *)current->mm->saved_auxv;
 	sp = STACK_ADD(p, ei_index);
 
 	items = (argc + 1) + (envc + 1) + 1;
@@ -338,7 +339,7 @@ create_elf_tables(struct linux_binprm *b
 	current->mm->env_end = p;
 
 	/* Put the elf_info on the stack in the right place.  */
-	if (copy_to_user(sp, elf_info, ei_index * sizeof(elf_addr_t)))
+	if (copy_to_user(sp, current->mm->saved_auxv, ei_index * sizeof(elf_addr_t)))
 		return -EFAULT;
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-decouple-proc-from-vfs-with-struct-proc_ops.patch
proc-convert-everything-to-struct-proc_ops.patch
