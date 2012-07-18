From: akpm@linux-foundation.org
Subject: + mips-fix-bugh-build-regression.patch added to -mm tree
Date: Wed, 18 Jul 2012 14:10:14 -0700
Message-ID: <20120718211014.B98D01E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61619 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2GRVKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 17:10:15 -0400
Received: by qcqs25 with SMTP id s25so217773qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 14:10:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuasa@linux-mips.org, blogic@openwrt.org, ddaney@caviumnetworks.com, ralf@linux-mips.org


The patch titled
     Subject: mips: fix bug.h build regression
has been added to the -mm tree.  Its filename is
     mips-fix-bugh-build-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yoichi Yuasa <yuasa@linux-mips.org>
Subject: mips: fix bug.h build regression

377780887 ("bug.h: need linux/kernel.h for TAINT_WARN.") breaks all MIPS
builds.

  CC      arch/mips/kernel/machine_kexec.o
include/linux/log2.h: In function '__ilog2_u32':
include/linux/log2.h:34:2: error: implicit declaration of function 'fls' [-Werror=implicit-function-declaration]
include/linux/log2.h: In function '__ilog2_u64':
include/linux/log2.h:42:2: error: implicit declaration of function 'fls64' [-Werror=implicit-function-declaration]
include/linux/log2.h: In function '__roundup_pow_of_two':
include/linux/log2.h:63:2: error: implicit declaration of function 'fls_long' [-Werror=implicit-function-declaration]
In file included from include/linux/bitops.h:22:0,
                 from include/linux/signal.h:38,
                 from include/linux/elfcore.h:5,
                 from include/linux/kexec.h:60,
                 from arch/mips/kernel/machine_kexec.c:9:
/home/yuasa/src/linux/kernel/git/linux-2.6/arch/mips/include/asm/bitops.h: At top level:
/home/yuasa/src/linux/kernel/git/linux-2.6/arch/mips/include/asm/bitops.h:615:19: error: static declaration of 'fls' follows non-static declaration
include/linux/log2.h:34:9: note: previous implicit declaration of 'fls' was here
In file included from /home/yuasa/src/linux/kernel/git/linux-2.6/arch/mips/include/asm/bitops.h:651:0,
                 from include/linux/bitops.h:22,
                 from include/linux/signal.h:38,
                 from include/linux/elfcore.h:5,
                 from include/linux/kexec.h:60,
                 from arch/mips/kernel/machine_kexec.c:9:
include/asm-generic/bitops/fls64.h:18:28: error: static declaration of 'fls64' follows non-static declaration
include/linux/log2.h:42:9: note: previous implicit declaration of 'fls64' was here
In file included from include/linux/signal.h:38:0,
                 from include/linux/elfcore.h:5,
                 from include/linux/kexec.h:60,
                 from arch/mips/kernel/machine_kexec.c:9:
include/linux/bitops.h:160:24: error: conflicting types for 'fls_long'
include/linux/log2.h:63:16: note: previous implicit declaration of 'fls_long' was here

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Tested-by: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/bitops.h |    1 -
 arch/mips/include/asm/io.h     |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/bitops.h~mips-fix-bugh-build-regression arch/mips/include/asm/bitops.h
--- a/arch/mips/include/asm/bitops.h~mips-fix-bugh-build-regression
+++ a/arch/mips/include/asm/bitops.h
@@ -17,7 +17,6 @@
 #include <linux/irqflags.h>
 #include <linux/types.h>
 #include <asm/barrier.h>
-#include <asm/bug.h>
 #include <asm/byteorder.h>		/* sigh ... */
 #include <asm/cpu-features.h>
 #include <asm/sgidefs.h>
diff -puN arch/mips/include/asm/io.h~mips-fix-bugh-build-regression arch/mips/include/asm/io.h
--- a/arch/mips/include/asm/io.h~mips-fix-bugh-build-regression
+++ a/arch/mips/include/asm/io.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 
 #include <asm/addrspace.h>
+#include <asm/bug.h>
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
_
Subject: Subject: mips: fix bug.h build regression

Patches currently in -mm which might be from yuasa@linux-mips.org are

mips-fix-bugh-build-regression.patch
linux-next.patch

