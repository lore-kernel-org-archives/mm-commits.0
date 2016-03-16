From: akpm@linux-foundation.org
Subject: [merged]
 x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch removed from -mm
 tree
Date: Wed, 16 Mar 2016 12:57:36 -0700
Message-ID: <56e9bab0.QESFO/QdFnOuZl0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, linux@roeck-us.net, mingo@kernel.org, mmarek@suse.cz, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kallsyms: disable absolute percpu symbols on !SMP
has been removed from the -mm tree.  Its filename was
     x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: x86: kallsyms: disable absolute percpu symbols on !SMP

scripts/kallsyms.c has a special --absolute-percpu command line
option which deals with the zero based per cpu offsets that are
used when building for SMP on x86_64. This means that the option
should only be passed in that case, so add a Kconfig symbol with
the correct predicate, and use that instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig            |    4 ++++
 scripts/link-vmlinux.sh |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~x86-kallsyms-disable-absolute-percpu-symbols-on-smp init/Kconfig
--- a/init/Kconfig~x86-kallsyms-disable-absolute-percpu-symbols-on-smp
+++ a/init/Kconfig
@@ -1420,6 +1420,10 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
+config KALLSYMS_ABSOLUTE_PERCPU
+	bool
+	default X86_64 && SMP
+
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
diff -puN scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp scripts/link-vmlinux.sh
--- a/scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp
+++ a/scripts/link-vmlinux.sh
@@ -86,7 +86,7 @@ kallsyms()
 		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
 	fi
 
-	if [ -n "${CONFIG_X86_64}" ]; then
+	if [ -n "${CONFIG_KALLSYMS_ABSOLUTE_PERCPU}" ]; then
 		kallsymopt="${kallsymopt} --absolute-percpu"
 	fi
 
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch

