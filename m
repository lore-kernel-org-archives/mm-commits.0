From: akpm@linux-foundation.org
Subject: + linux-bitsh-fix-unsigned-less-than-zero-warnings.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 18:29:07 -0700
Message-ID: <20200618012907.4iBWo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbgFRB3I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yamada.masahiro@socionext.com, vilhelm.gray@gmail.com, syednwaris@gmail.com, lkp@intel.com, linus.walleij@linaro.org, keescook@chromium.org, geert@linux-m68k.org, emil.l.velikov@gmail.com, arnd@arndb.de, andy.shevchenko@gmail.com, rikard.falkeborn@gmail.com


The patch titled
     Subject: linux/bits.h: fix unsigned less than zero warnings
has been added to the -mm tree.  Its filename is
     linux-bitsh-fix-unsigned-less-than-zero-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-bitsh-fix-unsigned-less-than-zero-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-bitsh-fix-unsigned-less-than-zero-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: linux/bits.h: fix unsigned less than zero warnings

When calling the GENMASK and GENMASK_ULL macros with zero lower bit and an
unsigned unknown high bit, some gcc versions warn due to the comparisons
of the high and low bit in GENMASK_INPUT_CHECK.

To silence the warnings, only perform the check if both inputs are known. 
This does not trigger any warnings, from the Wtype-limits help:

	Warn if a comparison is always true or always false due to the
	limited range of the data type, but do not warn for constant
	expressions.

As an example of the warning, kindly reported by the kbuild test robot:

from drivers/mfd/atmel-smc.c:11:
drivers/mfd/atmel-smc.c: In function 'atmel_smc_cs_encode_ncycles':
include/linux/bits.h:26:28: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
26 |   __builtin_constant_p((l) > (h)), (l) > (h), 0)))
|                            ^
include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
|                                                              ^
include/linux/bits.h:39:3: note: in expansion of macro 'GENMASK_INPUT_CHECK'
39 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
|   ^~~~~~~~~~~~~~~~~~~
>> drivers/mfd/atmel-smc.c:49:25: note: in expansion of macro 'GENMASK'
49 |  unsigned int lsbmask = GENMASK(msbpos - 1, 0);
|                         ^~~~~~~

Link: http://lkml.kernel.org/r/20200608221823.35799-1-rikard.falkeborn@gmail.com
Fixes: 295bcca84916 ("linux/bits.h: add compile time sanity check of GENMASK inputs")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Emil Velikov <emil.l.velikov@gmail.com>
Reported-by: Syed Nayyar Waris <syednwaris@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bits.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/bits.h~linux-bitsh-fix-unsigned-less-than-zero-warnings
+++ a/include/linux/bits.h
@@ -23,7 +23,8 @@
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
+		__builtin_constant_p(l) && __builtin_constant_p(h), \
+		(l) > (h), 0)))
 #else
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

linux-bitsh-fix-unsigned-less-than-zero-warnings.patch
bits-add-tests-of-genmask.patch
