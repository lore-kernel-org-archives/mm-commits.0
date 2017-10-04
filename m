From: akpm@linux-foundation.org
Subject: + scripts-kallsyms-ignore-symbol-type-n.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:08:03 -0700
Message-ID: <59d55bc3.eF5LLLuyr0xxmAgZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdJDWIE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, ard.biesheuvel@linaro.org, jpoimboe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kallsyms.c: ignore symbol type 'n'
has been added to the -mm tree.  Its filename is
     scripts-kallsyms-ignore-symbol-type-n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-kallsyms-ignore-symbol-type-n.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-kallsyms-ignore-symbol-type-n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: scripts/kallsyms.c: ignore symbol type 'n'

gcc on aarch64 may emit synbols of type 'n' if the kernel is built with
'-frecord-gcc-switches'.  In most cases, those symbols are reported with
nm as

	000000000000000e n $d

and with objdump as

	0000000000000000 l    d  .GCC.command.line	0000000000000000 .GCC.command.line
	000000000000000e l       .GCC.command.line	0000000000000000 $d

Those symbols are detected in is_arm_mapping_symbol() and ignored. 
However, if "--prefix-symbols=<prefix>" is configured as well, the
situation is different.  For example, in efi/libstub, arm64 images are
built with

	'--prefix-alloc-sections=.init --prefix-symbols=__efistub_'.

In combination with '-frecord-gcc-switches', the symbols are now reported
by nm as:

	000000000000000e n __efistub_$d
and by objdump as:
	0000000000000000 l    d  .GCC.command.line	0000000000000000 .GCC.command.line
	000000000000000e l       .GCC.command.line	0000000000000000 __efistub_$d

Those symbols are no longer ignored and included in the base address
calculation.  This results in a base address of 000000000000000e, which in
turn causes kallsyms to abort with

    kallsyms failure:
	relative symbol value 0xffffff900800a000 out of range in relative mode

The problem is seen in little endian arm64 builds with CONFIG_EFI enabled
and with '-frecord-gcc-switches' set in KCFLAGS.

Explicitly ignore symbols of type 'n' since those are clearly debug
symbols.

Link: http://lkml.kernel.org/r/1507136063-3139-1-git-send-email-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kallsyms.c~scripts-kallsyms-ignore-symbol-type-n scripts/kallsyms.c
--- a/scripts/kallsyms.c~scripts-kallsyms-ignore-symbol-type-n
+++ a/scripts/kallsyms.c
@@ -158,7 +158,7 @@ static int read_symbol(FILE *in, struct
 	else if (str[0] == '$')
 		return -1;
 	/* exclude debugging symbols */
-	else if (stype == 'N')
+	else if (stype == 'N' || stype == 'n')
 		return -1;
 
 	/* include the type field in the symbol name, so that it gets
_

Patches currently in -mm which might be from linux@roeck-us.net are

scripts-kallsyms-ignore-symbol-type-n.patch

