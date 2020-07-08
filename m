From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-move-wtype-limits-to-w=2.patch added to -mm tree
Date: Wed, 08 Jul 2020 14:50:27 -0700
Message-ID: <20200708215027.qY7byzJgo%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgGHVu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 17:50:28 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy.shevchenko@gmail.com, arnd@arndb.de, emil.l.velikov@gmail.com, geert@linux-m68k.org, keescook@chromium.org, linus.walleij@linaro.org, michal.lkml@markovi.net, mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com, syednwaris@gmail.com, vilhelm.gray@gmail.com, yamada.masahiro@socionext.com


The patch titled
     Subject: kbuild: move -Wtype-limits to W=2
has been added to the -mm tree.  Its filename is
     kbuild-move-wtype-limits-to-w=2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kbuild-move-wtype-limits-to-w%3D2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kbuild-move-wtype-limits-to-w%3D2.patch

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
Subject: kbuild: move -Wtype-limits to W=2

-Wtype-limits is included in -Wextra which is added at W=1.  It warns
(among other things) that 'comparison of an unsigned variable `< 0` is
always false.  This causes noisy warnings, especially when used in macros,
hence it is more suitable for W=2.

Link: http://lkml.kernel.org/r/20200708190756.16810-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/Makefile.extrawarn~kbuild-move-wtype-limits-to-w=2
+++ a/scripts/Makefile.extrawarn
@@ -35,6 +35,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wstr
 # The following turn off the warnings enabled by -Wextra
 KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-sign-compare
+KBUILD_CFLAGS += -Wno-type-limits
 
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
@@ -66,6 +67,7 @@ KBUILD_CFLAGS += -Wshadow
 KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
 KBUILD_CFLAGS += -Wmissing-field-initializers
 KBUILD_CFLAGS += -Wsign-compare
+KBUILD_CFLAGS += -Wtype-limits
 KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
 
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

kbuild-move-wtype-limits-to-w=2.patch
bits-add-tests-of-genmask.patch
