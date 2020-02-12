From: Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-fix-unistd_32h-generation-format.patch
 added to -mm tree
Date: Wed, 12 Feb 2020 14:08:25 -0800
Message-ID: <20200212220825.H9Ijn-_0x%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgBLWI1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 17:08:27 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, mattst88@gmail.com, michal.simek@xilinx.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulburton@kernel.org, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, stefan.asserhall@xilinx.com, tony.luck@intel.com, ysato@users.sourceforge.jp


The patch titled
     Subject: asm-generic: fix unistd_32.h generation format
has been added to the -mm tree.  Its filename is
     asm-generic-fix-unistd_32h-generation-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-fix-unistd_32h-generation-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-fix-unistd_32h-generation-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: asm-generic: fix unistd_32.h generation format

Generated files are also checked by sparse that's why add newline to
remove sparse (C=1) warning.

The issue was found on Microblaze and reported like this:
./arch/microblaze/include/generated/uapi/asm/unistd_32.h:438:45: warning:
no newline at end of file

Mips and PowerPC have it already but let's align with style used by m68k.

Link: http://lkml.kernel.org/r/4d32ab4e1fb2edb691d2e1687e8fb303c09fd023.1581504803.git.michal.simek@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Stefan Asserhall <stefan.asserhall@xilinx.com>
Acked-by: Max Filippov <jcmvbkbc@gmail.com> (xtensa)
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscallhdr.sh      |    2 +-
 arch/ia64/kernel/syscalls/syscallhdr.sh       |    2 +-
 arch/microblaze/kernel/syscalls/syscallhdr.sh |    2 +-
 arch/mips/kernel/syscalls/syscallhdr.sh       |    3 +--
 arch/parisc/kernel/syscalls/syscallhdr.sh     |    2 +-
 arch/powerpc/kernel/syscalls/syscallhdr.sh    |    3 +--
 arch/sh/kernel/syscalls/syscallhdr.sh         |    2 +-
 arch/sparc/kernel/syscalls/syscallhdr.sh      |    2 +-
 arch/xtensa/kernel/syscalls/syscallhdr.sh     |    2 +-
 9 files changed, 9 insertions(+), 11 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/alpha/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/ia64/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/ia64/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/microblaze/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/microblaze/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/mips/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/mips/kernel/syscalls/syscallhdr.sh
@@ -32,6 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
-	printf "\n"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/parisc/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/parisc/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/powerpc/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/powerpc/kernel/syscalls/syscallhdr.sh
@@ -32,6 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
-	printf "\n"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/sh/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/sh/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/sparc/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/sparc/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
--- a/arch/xtensa/kernel/syscalls/syscallhdr.sh~asm-generic-fix-unistd_32h-generation-format
+++ a/arch/xtensa/kernel/syscalls/syscallhdr.sh
@@ -32,5 +32,5 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my
 	printf "#define __NR_syscalls\t%s\n" "${nxt}"
 	printf "#endif\n"
 	printf "\n"
-	printf "#endif /* %s */" "${fileguard}"
+	printf "#endif /* %s */\n" "${fileguard}"
 ) > "$out"
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

asm-generic-fix-unistd_32h-generation-format.patch
