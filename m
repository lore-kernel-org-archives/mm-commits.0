From: akpm@linux-foundation.org
Subject: - binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:09 -0700
Message-ID: <200804300545.m3U5j9h7029479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849AbYD3Fpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     BINFMT: fill_elf_header cleanup - use straight memset first
has been removed from the -mm tree.  Its filename was
     binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1255,26 +1255,23 @@ static int writenote(struct memelfnote *
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
git-acpi.patch
git-m32r.patch

