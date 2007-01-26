From: akpm@osdl.org
Subject: - i386-vdso-use-vm_alwaysdump-tidy.patch removed from -mm tree
Date: Fri, 26 Jan 2007 00:46:04 -0800
Message-ID: <200701260846.l0Q8k5EH011750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030827AbXAZIqU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 03:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     i386-vdso-use-vm_alwaysdump-tidy
has been removed from the -mm tree.  Its filename was
     i386-vdso-use-vm_alwaysdump-tidy.patch

This patch was dropped because it was folded into i386-vdso-use-vm_alwaysdump.patch

------------------------------------------------------
Subject: i386-vdso-use-vm_alwaysdump-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump-tidy fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-vdso-use-vm_alwaysdump-tidy
+++ a/fs/binfmt_elf.c
@@ -1428,6 +1428,32 @@ static int elf_dump_thread_status(long s
 	return sz;
 }
 
+static struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret = tsk->mm->mmap;
+
+	if (ret)
+		return ret;
+	return gate_vma;
+}
+/*
+ * Helper function for iterating across a vma list.  It ensures that the caller
+ * will visit `gate_vma' prior to terminating the search.
+ */
+static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret;
+
+	ret = this_vma->vm_next;
+	if (ret)
+		return ret;
+	if (this_vma == gate_vma)
+		return NULL;
+	return gate_vma;
+}
+
 /*
  * Actual dumper
  *
@@ -1600,8 +1626,8 @@ static int elf_core_dump(long signr, str
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
 	/* Write program headers for segments dump */
-	for (vma = current->mm->mmap; vma != NULL;
-	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
 		size_t sz;
 
@@ -1650,8 +1676,8 @@ static int elf_core_dump(long signr, str
 	/* Align to page */
 	DUMP_SEEK(dataoff - foffset);
 
-	for (vma = current->mm->mmap; vma != NULL;
-	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
 
 		if (!maydump(vma))
_

Patches currently in -mm which might be from akpm@osdl.org are

i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
