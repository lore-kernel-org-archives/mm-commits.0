From: akpm@linux-foundation.org
Subject: - h8300-kallsyms-exclude-local-symbols-update.patch removed from -mm tree
Date: Wed, 20 Aug 2008 16:31:41 -0700
Message-ID: <200808202331.m7KNVfUJ004941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbYHTXcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 19:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, pmarques@grupopie.com, mm-commits@vger.kernel.org


The patch titled
     h8300-kallsyms-exclude-local-symbols-update
has been removed from the -mm tree.  Its filename was
     h8300-kallsyms-exclude-local-symbols-update.patch

This patch was dropped because it was folded into h8300-kallsyms-exclude-local-symbols.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300-kallsyms-exclude-local-symbols-update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

At Thu, 07 Aug 2008 13:00:05 +0100,
Paulo Marques wrote:
>
> Yoshinori Sato wrote:
> > h8300's nm output include '.Lfoo' local symbols.
> > [...]
> >  	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
> > -	else if (str[0] == '$')
> > +	else if (str[0] == '$' || str[0] == '.')
>
> The comment above needs some updating too. Something along these lines:
>
> /* exclude also MIPS ELF local symbols (eg. $L123) and h8300 (eg .LM10) */
>
> Other than that, the patch seems fine.
>
> --
> Paulo Marques - www.grupopie.com
>
> "...so she told me it was either her or the ham radio, over."

Thanks reply.

Update comment.
And same problem in modpost.

Warning message dirty.
WARNING: vmlinux.o(.text+0x304b): Section mismatch in reference from the variable .LM10 to the variable .init.text:_free_area_init
The function .LM10() references
the variable __init _free_area_init.
This is often because .LM10 lacks a __init
annotation or the annotation of _free_area_init is wrong.

fix it.
WARNING: vmlinux.o(.text+0x304b): Section mismatch in reference from the variable _paging_init to the variable .init.text:___alloc_bootmem
The function _paging_init() references
the variable __init ___alloc_bootmem.
This is often because _paging_init lacks a __init
annotation or the annotation of ___alloc_bootmem is wrong.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c    |    5 +++--
 scripts/mod/modpost.c |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols-update scripts/kallsyms.c
--- a/scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols-update
+++ a/scripts/kallsyms.c
@@ -105,8 +105,9 @@ static int read_symbol(FILE *in, struct 
 	else if (toupper(stype) == 'U' ||
 		 is_arm_mapping_symbol(sym))
 		return -1;
-	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
-	else if (str[0] == '$' || str[0] == '.')
+	/* exclude also MIPS ELF (e.g. $L123) and h8300 elf (e.g. .LM123)
+	   local symbols */
+ 	else if (str[0] == '$' || str[0] == '.')
 		return -1;
 	/* exclude debugging symbols */
 	else if (stype == 'N')
diff -puN scripts/mod/modpost.c~h8300-kallsyms-exclude-local-symbols-update scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~h8300-kallsyms-exclude-local-symbols-update
+++ a/scripts/mod/modpost.c
@@ -1042,7 +1042,9 @@ static inline int is_valid_name(struct e
 {
 	const char *name = elf->strtab + sym->st_name;
 
-	if (!name || !strlen(name))
+	if (!name || !strlen(name) ||
+	/* exclude h8300 elf local symbols (e.g. .LM123) */
+	    name[0] == '.')
 		return 0;
 	return !is_arm_mapping_symbol(name);
 }
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
h8300-kallsyms-exclude-local-symbols.patch
h8300-kallsyms-exclude-local-symbols-update.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch
h8300-kconfig-cleanup.patch
h8300-generic_bug-support.patch
h8300-generic_bug-support-checkpatch-fixes.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch

