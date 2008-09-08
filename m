From: akpm@linux-foundation.org
Subject: - h8300-kallsyms-exclude-local-symbols.patch removed from -mm tree
Date: Sun, 07 Sep 2008 23:56:44 -0700
Message-ID: <200809080656.m886uix5008379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbYIHG5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 02:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, pmarques@grupopie.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     h8300: kallsyms: exclude local symbols
has been removed from the -mm tree.  Its filename was
     h8300-kallsyms-exclude-local-symbols.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: kallsyms: exclude local symbols
From: Yoshinori Sato <ysato@users.sourceforge.jp>

h8300's nm output include '.Lfoo' local symbols.

This is head of System.map
00000000 T __vector
00000100 T _interrupt_redirect_table
00000100 T _text
00000200 T __start
00000200 T __stext
0000024c t _exit
00000252 T __platform_gpio_table
0000025a t gpio_table
00000270 t .LFB1596
00000270 t .LM1
00000270 t .LM2
00000270 t .Ltext0
00000270 t _run_init_process
0000027a t .LM3
00000286 t .LFB1597
00000286 t .LFE1596
00000286 t .LM4
00000286 t .LM5
00000286 t _init_post
0000028a t .LM6
00000296 t .LM7
000002aa t .LM8
000002ba t .L199
000002ba t .LM9
000002c0 t .LM10

exclude these symbols from kallsyms.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c    |    5 +++--
 scripts/mod/modpost.c |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols scripts/kallsyms.c
--- a/scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols
+++ a/scripts/kallsyms.c
@@ -105,8 +105,9 @@ static int read_symbol(FILE *in, struct 
 	else if (toupper(stype) == 'U' ||
 		 is_arm_mapping_symbol(sym))
 		return -1;
-	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
-	else if (str[0] == '$')
+	/* exclude also MIPS ELF (e.g. $L123) and h8300 elf (e.g. .LM123)
+	   local symbols */
+ 	else if (str[0] == '$' || str[0] == '.')
 		return -1;
 	/* exclude debugging symbols */
 	else if (stype == 'N')
diff -puN scripts/mod/modpost.c~h8300-kallsyms-exclude-local-symbols scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~h8300-kallsyms-exclude-local-symbols
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

h8300-kallsyms-exclude-local-symbols.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch
h8300-kconfig-cleanup.patch
h8300-generic_bug-support.patch
h8300-generic_bug-support-checkpatch-fixes.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch

