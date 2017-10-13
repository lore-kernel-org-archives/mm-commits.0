From: akpm@linux-foundation.org
Subject: [patch 09/18] scripts/kallsyms.c: ignore symbol type 'n'
Date: Fri, 13 Oct 2017 15:57:58 -0700
Message-ID: <59e144f6.JEECJ8dXAcj3v5C6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbdJMW57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, ard.biesheuvel@linaro.org, jpoimboe@redhat.com

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
