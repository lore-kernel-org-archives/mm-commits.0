From: akpm@linux-foundation.org
Subject: + scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch
 added to -mm tree
Date: Fri, 05 Feb 2016 11:31:28 -0800
Message-ID: <56b4f890.UICXgpjKtap1a6bh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbcBETb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 14:31:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, arnd@arndb.de, linux@roeck-us.net, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/link-vmlinux.sh: force error on kallsyms failure
has been added to the -mm tree.  Its filename is
     scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch

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
Subject: scripts/link-vmlinux.sh: force error on kallsyms failure

Since the output of the invocation of scripts/kallsyms is piped directly
into the assembler, error messages it emits are visible on stderr, but a
non-zero return code is ignored, and the build simply proceeds in that
case.  However, the resulting kernel is most likely broken, and will crash
at boot.

So instead, capture the output of kallsyms in a separate .S file, and pass
that to the assembler in a separate step.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/link-vmlinux.sh |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/link-vmlinux.sh~scripts-link-vmlinuxsh-force-error-on-kallsyms-failure scripts/link-vmlinux.sh
--- a/scripts/link-vmlinux.sh~scripts-link-vmlinuxsh-force-error-on-kallsyms-failure
+++ a/scripts/link-vmlinux.sh
@@ -97,9 +97,10 @@ kallsyms()
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-	${NM} -n ${1} | \
-		scripts/kallsyms ${kallsymopt} | \
-		${CC} ${aflags} -c -o ${2} -x assembler-with-cpp -
+	local afile="`basename ${2} .o`.S"
+
+	${NM} -n ${1} | scripts/kallsyms ${kallsymopt} > ${afile}
+	${CC} ${aflags} -c -o ${2} ${afile}
 }
 
 # Create map file with all symbols from ${1}
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

extable-add-support-for-relative-extables-to-search-and-sort-routines.patch
alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch
arm64-switch-to-relative-exception-tables.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch

