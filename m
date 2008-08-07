From: akpm@linux-foundation.org
Subject: + h8300-kallsyms-exclude-local-symbols.patch added to -mm tree
Date: Wed, 06 Aug 2008 22:04:44 -0700
Message-ID: <200808070504.m7754i5K000378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYHGFFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 01:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp, sam@ravnborg.org


The patch titled
     h8300: kallsyms: exclude local symbols
has been added to the -mm tree.  Its filename is
     h8300-kallsyms-exclude-local-symbols.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols scripts/kallsyms.c
--- a/scripts/kallsyms.c~h8300-kallsyms-exclude-local-symbols
+++ a/scripts/kallsyms.c
@@ -106,7 +106,7 @@ static int read_symbol(FILE *in, struct 
 		 is_arm_mapping_symbol(sym))
 		return -1;
 	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
-	else if (str[0] == '$')
+	else if (str[0] == '$' || str[0] == '.')
 		return -1;
 	/* exclude debugging symbols */
 	else if (stype == 'N')
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-fix-section-mismatch.patch
h8300-kallsyms-exclude-local-symbols.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch
h8300-kconfig-cleanup.patch
h8300-generic_bug-support.patch
h8300-generic_bug-support-checkpatch-fixes.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch

