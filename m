From: akpm@linux-foundation.org
Subject: + binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch added to -mm tree
Date: Tue, 12 Feb 2008 14:29:42 -0800
Message-ID: <200802122229.m1CMTg6S025653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbYBLWaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 17:30:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     BINFMT: fill_elf_header cleanup - use straight memset first
has been added to the -mm tree.  Its filename is
     binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BINFMT: fill_elf_header cleanup - use straight memset first
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does simplify fill_elf_header function by setting
to zero the whole elf header first. So we fillup the fields
we really need only.

before:
   text    data     bss     dec     hex filename
  11735      80       0   11815    2e27 fs/binfmt_elf.o

after:
   text    data     bss     dec     hex filename
  11710      80       0   11790    2e0e fs/binfmt_elf.o

viola, 25 bytes of text is freed

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt-fill_elf_header-cleanup-use-straight-memset-first fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt-fill_elf_header-cleanup-use-straight-memset-first
+++ a/fs/binfmt_elf.c
@@ -1276,26 +1276,23 @@ static int writenote(struct memelfnote *
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
+	memset(elf, 0, sizeof(*elf));
+
 	memcpy(elf->e_ident, ELFMAG, SELFMAG);
 	elf->e_ident[EI_CLASS] = ELF_CLASS;
 	elf->e_ident[EI_DATA] = ELF_DATA;
 	elf->e_ident[EI_VERSION] = EV_CURRENT;
 	elf->e_ident[EI_OSABI] = ELF_OSABI;
-	memset(elf->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
 
 	elf->e_type = ET_CORE;
 	elf->e_machine = machine;
 	elf->e_version = EV_CURRENT;
-	elf->e_entry = 0;
 	elf->e_phoff = sizeof(struct elfhdr);
-	elf->e_shoff = 0;
 	elf->e_flags = flags;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
 	elf->e_phnum = segs;
-	elf->e_shentsize = 0;
-	elf->e_shnum = 0;
-	elf->e_shstrndx = 0;
+
 	return;
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-avr32.patch
git-dvb.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch
