Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1B8C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 02:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhLGClg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:41:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47550 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhLGClf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 21:41:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EF7CCE18BD
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 02:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF62C004DD;
        Tue,  7 Dec 2021 02:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638844683;
        bh=8wxneXNzWhiQaGoFMPTtIlmVX2qgVEUqZTJzubSzY/Y=;
        h=Date:From:To:Subject:From;
        b=gCWEUIQdsuPGOX1JgAI7/Z6F4zZUi70swfNaurqd+hikJOyha34k8K/hzNwLUaAH7
         MBRKurO9bvFb5JpxHYv6+gVEuKl5WuKgI+SiKShOzjeUhv/F74REZ6Wp0tFgwjHlV2
         +1eMrKA9pnmvx2DK2MJLBmrrF3d29aHEJGgjfB20=
Date:   Mon, 06 Dec 2021 18:38:02 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akirakawata1@gmail.com, ebiederm@xmission.com,
        keescook@chromium.org, lkp@intel.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [nacked]
 fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch removed from -mm tree
Message-ID: <20211207023802.m0hMU_9r7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: Fix AT_PHDR for unusual ELF files
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Akira Kawata <akirakawata1@gmail.com>
Subject: fs/binfmt_elf: Fix AT_PHDR for unusual ELF files

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=197921

As pointed out in the discussion of buglink, we cannot calculate AT_PHDR
as the sum of load_addr and exec->e_phoff.

: The AT_PHDR of ELF auxiliary vectors should point to the memory address of
: program header. But binfmt_elf.c calculates this address as follows:
: 
: NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
: 
: which is wrong since e_phoff is the file offset of program header and
: load_addr is the memory base address from PT_LOAD entry.
: 
: The ld.so uses AT_PHDR as the memory address of program header.  In normal
: case, since the e_phoff is usually 64 and in the first PT_LOAD region, it
: is the correct program header address.
: 
: But if the address of program header isn't equal to the first PT_LOAD
: address + e_phoff (e.g.  Put the program header in other non-consecutive
: PT_LOAD region), ld.so will try to read program header from wrong address
: then crash or use incorrect program header.

This is because exec->e_phoff
is the offset of PHDRs in the file and the address of PHDRs in the
memory may differ from it. This patch fixes the bug by calculating the
address of program headers from PT_LOADs directly.

Link: https://lkml.kernel.org/r/20211130115906.414176-1-akirakawata1@gmail.com
Signed-off-by: Akira Kawata <akirakawata1@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files
+++ a/fs/binfmt_elf.c
@@ -170,8 +170,8 @@ static int padzero(unsigned long elf_bss
 
 static int
 create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
-		unsigned long load_addr, unsigned long interp_load_addr,
-		unsigned long e_entry)
+		unsigned long interp_load_addr,
+		unsigned long e_entry, unsigned long phdr_addr)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long p = bprm->p;
@@ -257,7 +257,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
-	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
+	NEW_AUX_ENT(AT_PHDR, phdr_addr);
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
@@ -823,7 +823,7 @@ static int parse_elf_properties(struct f
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+	unsigned long load_addr, load_bias = 0, phdr_addr = 0;
 	int load_addr_set = 0;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
@@ -1169,6 +1169,13 @@ out_free_interp:
 				reloc_func_desc = load_bias;
 			}
 		}
+
+		if (elf_ppnt->p_offset <= elf_ex->e_phoff &&
+		    elf_ex->e_phoff < elf_ppnt->p_offset + elf_ppnt->p_filesz) {
+			phdr_addr = elf_ex->e_phoff - elf_ppnt->p_offset +
+				    elf_ppnt->p_vaddr;
+		}
+
 		k = elf_ppnt->p_vaddr;
 		if ((elf_ppnt->p_flags & PF_X) && k < start_code)
 			start_code = k;
@@ -1204,6 +1211,7 @@ out_free_interp:
 	}
 
 	e_entry = elf_ex->e_entry + load_bias;
+	phdr_addr += load_bias;
 	elf_bss += load_bias;
 	elf_brk += load_bias;
 	start_code += load_bias;
@@ -1267,8 +1275,8 @@ out_free_interp:
 		goto out;
 #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
 
-	retval = create_elf_tables(bprm, elf_ex,
-			  load_addr, interp_load_addr, e_entry);
+	retval = create_elf_tables(bprm, elf_ex, interp_load_addr,
+				   e_entry, phdr_addr);
 	if (retval < 0)
 		goto out;
 
_

Patches currently in -mm which might be from akirakawata1@gmail.com are


