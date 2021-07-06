Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18996C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F8C61057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhGFTOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231819AbhGFTOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6A56023F;
        Tue,  6 Jul 2021 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598729;
        bh=yXws/ZmM9QaGfOfjtBIHYOmMBA9DK7CjGPY3EJUYEMU=;
        h=Date:From:To:Subject:From;
        b=kUzLHd9653FbxLpXmBmUheY8oRXjuo7Lpf2YGD9Vxpc8C72d99PSZy2W12yxhKwpM
         EXI8Uqcp9V75rbG1FjLmDMkslCtr+zNRCGKs2ufXcgwJMjw+GBM2VDHUS9vj5heXlv
         mwQxY0/QPixD6RjzvU0atRcz2QSBGBGTA5i68V7M=
Date:   Tue, 06 Jul 2021 12:12:08 -0700
From:   akpm@linux-foundation.org
To:     acme@kernel.org, alexander.shishkin@linux.intel.com, bp@alien8.de,
        catalin.marinas@arm.com, david@redhat.com, dzickus@redhat.com,
        ebiederm@xmission.com, feng.tang@intel.com, gerg@linux-m68k.org,
        hpa@zytor.com, jolsa@redhat.com, keescook@chromium.org,
        Kevin.Brodsky@arm.com, mark.rutland@arm.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, namhyung@kernel.org,
        peterz@infradead.org, rppt@kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 binfmt-remove-in-tree-usage-of-map_executable.patch removed from -mm tree
Message-ID: <20210706191208._tyQ-GmEz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt: remove in-tree usage of MAP_EXECUTABLE
has been removed from the -mm tree.  Its filename was
     binfmt-remove-in-tree-usage-of-map_executable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: binfmt: remove in-tree usage of MAP_EXECUTABLE

Ever since commit e9714acf8c43 ("mm: kill vma flag VM_EXECUTABLE and
mm->num_exe_file_vmas"), VM_EXECUTABLE is gone and MAP_EXECUTABLE is
essentially completely ignored.  Let's remove all usage of MAP_EXECUTABLE.

[akpm@linux-foundation.org: fix blooper in fs/binfmt_aout.c. per David]
Link: https://lkml.kernel.org/r/20210421093453.6904-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_aout.c |    4 ++--
 fs/binfmt_aout.c          |    4 ++--
 fs/binfmt_elf.c           |    2 +-
 fs/binfmt_elf_fdpic.c     |   11 ++---------
 fs/binfmt_flat.c          |    2 +-
 5 files changed, 8 insertions(+), 15 deletions(-)

--- a/arch/x86/ia32/ia32_aout.c~binfmt-remove-in-tree-usage-of-map_executable
+++ a/arch/x86/ia32/ia32_aout.c
@@ -203,7 +203,7 @@ static int load_aout_binary(struct linux
 		error = vm_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 				PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE |
-				MAP_EXECUTABLE | MAP_32BIT,
+				MAP_32BIT,
 				fd_offset);
 
 		if (error != N_TXTADDR(ex))
@@ -212,7 +212,7 @@ static int load_aout_binary(struct linux
 		error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE |
-				MAP_EXECUTABLE | MAP_32BIT,
+				MAP_32BIT,
 				fd_offset + ex.a_text);
 		if (error != N_DATADDR(ex))
 			return error;
--- a/fs/binfmt_aout.c~binfmt-remove-in-tree-usage-of-map_executable
+++ a/fs/binfmt_aout.c
@@ -222,7 +222,7 @@ static int load_aout_binary(struct linux
 
 		error = vm_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 			PROT_READ | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
+			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 			fd_offset);
 
 		if (error != N_TXTADDR(ex))
@@ -230,7 +230,7 @@ static int load_aout_binary(struct linux
 
 		error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
-				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
+				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 				fd_offset + ex.a_text);
 		if (error != N_DATADDR(ex))
 			return error;
--- a/fs/binfmt_elf.c~binfmt-remove-in-tree-usage-of-map_executable
+++ a/fs/binfmt_elf.c
@@ -1070,7 +1070,7 @@ out_free_interp:
 		elf_prot = make_prot(elf_ppnt->p_flags, &arch_state,
 				     !!interpreter, false);
 
-		elf_flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE;
+		elf_flags = MAP_PRIVATE | MAP_DENYWRITE;
 
 		vaddr = elf_ppnt->p_vaddr;
 		/*
--- a/fs/binfmt_elf_fdpic.c~binfmt-remove-in-tree-usage-of-map_executable
+++ a/fs/binfmt_elf_fdpic.c
@@ -928,7 +928,7 @@ static int elf_fdpic_map_file_constdisp_
 {
 	struct elf32_fdpic_loadseg *seg;
 	struct elf32_phdr *phdr;
-	unsigned long load_addr, base = ULONG_MAX, top = 0, maddr = 0, mflags;
+	unsigned long load_addr, base = ULONG_MAX, top = 0, maddr = 0;
 	int loop, ret;
 
 	load_addr = params->load_addr;
@@ -948,12 +948,8 @@ static int elf_fdpic_map_file_constdisp_
 	}
 
 	/* allocate one big anon block for everything */
-	mflags = MAP_PRIVATE;
-	if (params->flags & ELF_FDPIC_FLAG_EXECUTABLE)
-		mflags |= MAP_EXECUTABLE;
-
 	maddr = vm_mmap(NULL, load_addr, top - base,
-			PROT_READ | PROT_WRITE | PROT_EXEC, mflags, 0);
+			PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE, 0);
 	if (IS_ERR_VALUE(maddr))
 		return (int) maddr;
 
@@ -1046,9 +1042,6 @@ static int elf_fdpic_map_file_by_direct_
 		if (phdr->p_flags & PF_X) prot |= PROT_EXEC;
 
 		flags = MAP_PRIVATE | MAP_DENYWRITE;
-		if (params->flags & ELF_FDPIC_FLAG_EXECUTABLE)
-			flags |= MAP_EXECUTABLE;
-
 		maddr = 0;
 
 		switch (params->flags & ELF_FDPIC_FLAG_ARRANGEMENT) {
--- a/fs/binfmt_flat.c~binfmt-remove-in-tree-usage-of-map_executable
+++ a/fs/binfmt_flat.c
@@ -573,7 +573,7 @@ static int load_flat_file(struct linux_b
 		pr_debug("ROM mapping of file (we hope)\n");
 
 		textpos = vm_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
-				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
+				  MAP_PRIVATE, 0);
 		if (!textpos || IS_ERR_VALUE(textpos)) {
 			ret = textpos;
 			if (!textpos)
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-complete-admin-guide-overhaul.patch

