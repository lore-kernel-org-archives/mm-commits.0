From: akpm@linux-foundation.org
Subject: - elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:08 -0700
Message-ID: <200807252301.m6PN18BQ003684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbYGYXB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edgar.iglesias@axis.com, edgar@axis.com, ralf@linux-mips.org, starvik@axis.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     elf: use ELF_CORE_EFLAGS for kcore ELF header flags
has been removed from the -mm tree.  Its filename was
     elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf: use ELF_CORE_EFLAGS for kcore ELF header flags
From: "Edgar E. Iglesias" <edgar.iglesias@axis.com>

ELF_CORE_EFLAGS is already used by the binfmt_elf coredumper to set correct
arch specific ELF header flags on coredumps.  Use it for kcore dumps as well. 
At the moment, this affects the CRIS and the H8300 arch.

Signed-off-by: Edgar E. Iglesias <edgar@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c         |   10 +++++-----
 include/asm-h8300/elf.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/kcore.c~elf-use-elf_core_eflags-for-kcore-elf-header-flags fs/proc/kcore.c
--- a/fs/proc/kcore.c~elf-use-elf_core_eflags-for-kcore-elf-header-flags
+++ a/fs/proc/kcore.c
@@ -23,6 +23,10 @@
 
 #define CORE_STR "CORE"
 
+#ifndef ELF_CORE_EFLAGS
+#define ELF_CORE_EFLAGS	0
+#endif
+
 static int open_kcore(struct inode * inode, struct file * filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
@@ -164,11 +168,7 @@ static void elf_kcore_store_hdr(char *bu
 	elf->e_entry	= 0;
 	elf->e_phoff	= sizeof(struct elfhdr);
 	elf->e_shoff	= 0;
-#if defined(CONFIG_H8300)
-	elf->e_flags	= ELF_FLAGS;
-#else
-	elf->e_flags	= 0;
-#endif
+	elf->e_flags	= ELF_CORE_EFLAGS;
 	elf->e_ehsize	= sizeof(struct elfhdr);
 	elf->e_phentsize= sizeof(struct elf_phdr);
 	elf->e_phnum	= nphdr;
diff -puN include/asm-h8300/elf.h~elf-use-elf_core_eflags-for-kcore-elf-header-flags include/asm-h8300/elf.h
--- a/include/asm-h8300/elf.h~elf-use-elf_core_eflags-for-kcore-elf-header-flags
+++ a/include/asm-h8300/elf.h
@@ -26,10 +26,10 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_DATA	ELFDATA2MSB
 #define ELF_ARCH	EM_H8_300
 #if defined(__H8300H__)
-#define ELF_FLAGS       0x810000
+#define ELF_CORE_EFLAGS 0x810000
 #endif
 #if defined(__H8300S__)
-#define ELF_FLAGS       0x820000
+#define ELF_CORE_EFLAGS 0x820000
 #endif
 
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
_

Patches currently in -mm which might be from edgar.iglesias@axis.com are

origin.patch

