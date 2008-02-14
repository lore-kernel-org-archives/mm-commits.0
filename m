From: akpm@linux-foundation.org
Subject: - elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch removed from -mm tree
Date: Thu, 14 Feb 2008 13:00:31 -0800
Message-ID: <200802142100.m1EL0VCY002588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750AbYBNVBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edgar.iglesias@axis.com, edgar@axis.com, ralf@linux-mips.org, starvik@axis.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     elf: use ELF_CORE_EFLAGS for kcore ELF header flags.
has been removed from the -mm tree.  Its filename was
     elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf: use ELF_CORE_EFLAGS for kcore ELF header flags.
From: "Edgar E. Iglesias" <edgar.iglesias@axis.com>

ELF_CORE_EFLAGS is already used by the binfmt_elf coredumper to set correct
arch specific ELF header flags on coredumps.  Use it for kcore as well. 
This corrects kcore files for the CRIS arch and I believe it corrects
ordinary coredumps for the H8/300.

Signed-off-by: Edgar E. Iglesias <edgar@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c         |   10 +++++-----
 include/asm-h8300/elf.h |    2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

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
@@ -32,6 +32,8 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_FLAGS       0x820000
 #endif
 
+#define ELF_CORE_EFLAGS ELF_FLAGS
+
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
 
 #define USE_ELF_CORE_DUMP
_

Patches currently in -mm which might be from edgar.iglesias@axis.com are

elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
