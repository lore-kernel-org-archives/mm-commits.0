From: akpm@linux-foundation.org
Subject: + x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch added to -mm tree
Date: Mon, 25 Jan 2016 13:45:41 -0800
Message-ID: <56a69785.AOfmDPfWh3LPuCaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcAYVpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, linux@roeck-us.net, mingo@kernel.org, mmarek@suse.cz, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kallsyms: disable absolute percpu symbols on !SMP
has been added to the -mm tree.  Its filename is
     x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: x86: kallsyms: disable absolute percpu symbols on !SMP

scripts/kallsyms.c has a special --absolute-percpu command line option
which deals with the zero based per cpu offsets that are used when
building for SMP on x86_64.  This means that the option should only be
passed in that case, so add a check for CONFIG_SMP.  Otherwise, per cpu
variables are recorded as absolute quantities, (which they are not under
!CONFIG_SMP) and they are not relocated under CONFIG_RELOCATABLE=y.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> # powerpc
Cc: Kees Cook <keescook@chromium.org> # x86_64
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/link-vmlinux.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp scripts/link-vmlinux.sh
--- a/scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp
+++ a/scripts/link-vmlinux.sh
@@ -86,7 +86,7 @@ kallsyms()
 		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
 	fi
 
-	if [ -n "${CONFIG_X86_64}" ]; then
+	if [ -n "${CONFIG_X86_64}" ] && [ -n "${CONFIG_SMP}" ]; then
 		kallsymopt="${kallsymopt} --absolute-percpu"
 	fi
 
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

