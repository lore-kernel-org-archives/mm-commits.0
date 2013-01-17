From: akpm@linux-foundation.org
Subject: + binfmt_elf-remove-unused-argument-in-fill_elf_header.patch added to -mm tree
Date: Thu, 17 Jan 2013 14:44:33 -0800
Message-ID: <20130117224433.A383B31C129@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:61191 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3AQWoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 17:44:34 -0500
Received: by mail-ie0-f202.google.com with SMTP id s9so805484iec.5
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 14:44:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elf: remove unused argument in fill_elf_header
has been added to the -mm tree.  Its filename is
     binfmt_elf-remove-unused-argument-in-fill_elf_header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1248,7 +1248,7 @@ static int writenote(struct memelfnote *
 #undef DUMP_WRITE
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
-			    u16 machine, u32 flags, u8 osabi)
+			    u16 machine, u32 flags)
 {
 	memset(elf, 0, sizeof(*elf));
 
@@ -1630,7 +1630,7 @@ static int fill_note_info(struct elfhdr 
 	 * Initialize the ELF file header.
 	 */
 	fill_elf_header(elf, phdrs,
-			view->e_machine, view->e_flags, view->ei_osabi);
+			view->e_machine, view->e_flags);
 
 	/*
 	 * Allocate a structure for each thread.
@@ -1870,7 +1870,7 @@ static int fill_note_info(struct elfhdr 
 	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
 
 	/* Set up header */
-	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS, ELF_OSABI);
+	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
 
 	/*
 	 * Set up the notes in similar form to SVR4 core dumps made
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch

