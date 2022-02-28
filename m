Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753EAC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiB1C6t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiB1C6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689672FFFD
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4958260EC7
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B61C36AE2;
        Mon, 28 Feb 2022 02:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017084;
        bh=YmF+TPv8Cr/MBl47pYms/yPwlEYrAK7pxdpFe07uaD4=;
        h=Date:To:From:Subject:From;
        b=qCBZw4tJWD8ETf8BOeLRQHKvx2b0RAF4B/4Hnur6Pz/fCWbr/BavPavg5UsA2XqxR
         TsDeBf+bVquAF3+pzdHtnYlIFgNph8qlKyFuCeNJNopvRxKQgCcgnRaAxcjD8Ex7Lj
         MBcku0ZlpSz8PSQhe5OC+WwrmDpYOHpLglCkLJCk=
Date:   Sun, 27 Feb 2022 18:58:03 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        lukas.bulwahn@gmail.com, lkp@intel.com, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com, akirakawata1@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch removed from -mm tree
Message-Id: <20220228025804.A0B61C36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: fix AT_PHDR for unusual ELF files
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akira Kawata <akirakawata1@gmail.com>
Subject: fs/binfmt_elf: fix AT_PHDR for unusual ELF files

Patch series "fs/binfmt_elf: Fix AT_PHDR for unusual ELF files", v4.

These patches fix a bug in AT_PHDR calculation.

We cannot calculate AT_PHDR as the sum of load_addr and exec->e_phoff. 
This is because exec->e_phoff is the offset of PHDRs in the file and the
address of PHDRs in the memory may differ from it.  These patches fix the
bug by calculating the address of program headers from PT_LOADs directly.


This patch (of 2):

As pointed out in the bugzilla discussion, we cannot calculate AT_PHDR as
the sum of load_addr and exec->e_phoff.

: The AT_PHDR of ELF auxiliary vectors should point to the memory address
: of program header. But binfmt_elf.c calculates this address as follows:
:
: NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
:
: which is wrong since e_phoff is the file offset of program header and
: load_addr is the memory base address from PT_LOAD entry.
:
: The ld.so uses AT_PHDR as the memory address of program header. In normal
: case, since the e_phoff is usually 64 and in the first PT_LOAD region, it
: is the correct program header address.
:
: But if the address of program header isn't equal to the first PT_LOAD
: address + e_phoff (e.g.  Put the program header in other non-consecutive
: PT_LOAD region), ld.so will try to read program header from wrong address
: then crash or use incorrect program header.

This is because exec->e_phoff is the offset of PHDRs in the file and the
address of PHDRs in the memory may differ from it.  This patch fixes the
bug by calculating the address of program headers from PT_LOADs directly.

Link: https://lkml.kernel.org/r/20211212232414.1402199-1-akirakawata1@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=197921
Link: https://lkml.kernel.org/r/20211212232414.1402199-2-akirakawata1@gmail.com
Signed-off-by: Akira Kawata <akirakawata1@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
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


