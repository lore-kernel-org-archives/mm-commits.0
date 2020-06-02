From: akpm@linux-foundation.org
Subject: + sh-convert-ins-outs-macros-to-inline-functions.patch
 added to -mm tree
Date: Mon, 01 Jun 2020 17:55:45 -0700
Message-ID: <20200602005545.KlqFvUdQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAzr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: convert ins[bwl]/outs[bwl] macros to inline functions
has been added to the -mm tree.  Its filename is
     sh-convert-ins-outs-macros-to-inline-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-convert-ins-outs-macros-to-inline-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-convert-ins-outs-macros-to-inline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: convert ins[bwl]/outs[bwl] macros to inline functions

Macro ins[bwl]/outs[bwl] are just calling BUG(), but that results in
unused variable warnings all over the place.  This patch convert macro to
inline to avoid warning

We will get this kind of warning without this patch

	${LINUX}/drivers/iio/adc/ad7606_par.c:21:23: \
	  warning: unused variable 'st' [-Wunused-variable]
	struct ad7606_state *st = iio_priv(indio_dev);
	^~

Link: https://marc.info/?l=linux-sh&m=157656907716201
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io_noioport.h |   36 ++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- a/arch/sh/include/asm/io_noioport.h~sh-convert-ins-outs-macros-to-inline-functions
+++ a/arch/sh/include/asm/io_noioport.h
@@ -53,12 +53,34 @@ static inline void ioport_unmap(void __i
 #define outw_p(x, addr)	outw((x), (addr))
 #define outl_p(x, addr)	outl((x), (addr))
 
-#define insb(a, b, c)	BUG()
-#define insw(a, b, c)	BUG()
-#define insl(a, b, c)	BUG()
-
-#define outsb(a, b, c)	BUG()
-#define outsw(a, b, c)	BUG()
-#define outsl(a, b, c)	BUG()
+static inline void insb (unsigned long port, void *dst, unsigned long count)
+{
+	BUG();
+}
+
+static inline void insw (unsigned long port, void *dst, unsigned long count)
+{
+	BUG();
+}
+
+static inline void insl (unsigned long port, void *dst, unsigned long count)
+{
+	BUG();
+}
+
+static inline void outsb (unsigned long port, const void *src, unsigned long count)
+{
+	BUG();
+}
+
+static inline void outsw (unsigned long port, const void *src, unsigned long count)
+{
+	BUG();
+}
+
+static inline void outsl (unsigned long port, const void *src, unsigned long count)
+{
+	BUG();
+}
 
 #endif /* __ASM_SH_IO_NOIOPORT_H */
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are

sh-clkfwk-remove-r8-r16-r32.patch
sh-use-generic-strncpy.patch
sh-convert-ins-outs-macros-to-inline-functions.patch
sh-convert-iounmap-macros-to-inline-functions.patch
sh-add-missing-export_symbol-for-__delay.patch
