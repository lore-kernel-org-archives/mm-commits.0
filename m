From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-remove-unused-argument-in-fill_elf_header.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:02 -0800
Message-ID: <20130222204302.9C8BD5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:62950 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab3BVUnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:03 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so104125qen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: remove unused argument in fill_elf_header
has been removed from the -mm tree.  Its filename was
     binfmt_elf-remove-unused-argument-in-fill_elf_header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: binfmt_elf: remove unused argument in fill_elf_header

In fill_elf_header(), elf->e_ident[EI_OSABI] is always set to ELF_OSABI,
so remove the unused argument 'osabi'.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-remove-unused-argument-in-fill_elf_header fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-remove-unused-argument-in-fill_elf_header
+++ a/fs/binfmt_elf.c
@@ -1249,7 +1249,7 @@ static int writenote(struct memelfnote *
 #undef DUMP_WRITE
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
-			    u16 machine, u32 flags, u8 osabi)
+			    u16 machine, u32 flags)
 {
 	memset(elf, 0, sizeof(*elf));
 
@@ -1634,7 +1634,7 @@ static int fill_note_info(struct elfhdr 
 	 * Initialize the ELF file header.
 	 */
 	fill_elf_header(elf, phdrs,
-			view->e_machine, view->e_flags, view->ei_osabi);
+			view->e_machine, view->e_flags);
 
 	/*
 	 * Allocate a structure for each thread.
@@ -1874,7 +1874,7 @@ static int fill_note_info(struct elfhdr 
 	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
 
 	/* Set up header */
-	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS, ELF_OSABI);
+	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
 
 	/*
 	 * Set up the notes in similar form to SVR4 core dumps made
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

