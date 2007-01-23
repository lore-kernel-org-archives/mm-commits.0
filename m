From: akpm@osdl.org
Subject: + add-vm_alwaysdump.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:48:52 -0800
Message-ID: <200701231948.l0NJmqaT029445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965449AbXAWTtd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     Add VM_ALWAYSDUMP
has been added to the -mm tree.  Its filename is
     add-vm_alwaysdump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add VM_ALWAYSDUMP
From: Roland McGrath <roland@redhat.com>

This patch adds the VM_ALWAYSDUMP flag for vm_flags in vm_area_struct.  This
provides a clean explicit way to have a vma always included in core dumps, as
is needed for vDSO's.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c    |    4 ++++
 include/linux/mm.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN fs/binfmt_elf.c~add-vm_alwaysdump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~add-vm_alwaysdump
+++ a/fs/binfmt_elf.c
@@ -1178,6 +1178,10 @@ static int dump_seek(struct file *file, 
  */
 static int maydump(struct vm_area_struct *vma)
 {
+	/* The vma can be set up to tell us the answer directly.  */
+	if (vma->vm_flags & VM_ALWAYSDUMP)
+		return 1;
+
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
diff -puN include/linux/mm.h~add-vm_alwaysdump include/linux/mm.h
--- a/include/linux/mm.h~add-vm_alwaysdump
+++ a/include/linux/mm.h
@@ -168,6 +168,7 @@ extern unsigned int kobjsize(const void 
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
_

Patches currently in -mm which might be from roland@redhat.com are

fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
