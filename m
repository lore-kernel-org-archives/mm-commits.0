From: akpm@linux-foundation.org
Subject: + sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch added to -mm tree
Date: Tue, 08 Jul 2014 14:41:29 -0700
Message-ID: <53bc6589.jYbtGcOSjxfco5Ci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34776 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaGHVla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 17:41:30 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so932138veb.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 14:41:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, ast@plumgrid.com, dborkman@redhat.com, fengguang.wu@intel.com, linux@roeck-us.net, magnus.damm@gmail.com, tony@bakeyournoodle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: also try passing -m4-nofpu for SH2A builds
has been added to the -mm tree.  Its filename is
     sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: also try passing -m4-nofpu for SH2A builds

When compiling a SH2A kernel (e.g.  se7206_defconfig or rsk7203_defconfig)
using sh4-linux-gcc, linking fails with:

net/built-in.o: In function `__sk_run_filter':
net/core/filter.c:566: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/built-in.o:net/core/filter.c:580: more undefined references to `__fpscr_values' follow

This happens because sh4-linux-gcc doesn't support the "-m2a-nofpu", which
is thus filtered out by "$(call cc-option, ...)".

As compiling using sh4-linux-gcc is useful for compile coverage, also try
passing "-m4-nofpu" (which is presumably filtered out when using a real
sh2a-linux toolchain) to disable the generation of FPU instructions and
references to __fpscr_values[].

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/sh/Makefile~sh-also-try-passing-m4-nofpu-for-sh2a-builds arch/sh/Makefile
--- a/arch/sh/Makefile~sh-also-try-passing-m4-nofpu-for-sh2a-builds
+++ a/arch/sh/Makefile
@@ -32,7 +32,8 @@ endif
 
 cflags-$(CONFIG_CPU_SH2)		:= $(call cc-option,-m2,)
 cflags-$(CONFIG_CPU_SH2A)		+= $(call cc-option,-m2a,) \
-					   $(call cc-option,-m2a-nofpu,)
+					   $(call cc-option,-m2a-nofpu,) \
+					   $(call cc-option,-m4-nofpu,)
 cflags-$(CONFIG_CPU_SH3)		:= $(call cc-option,-m3,)
 cflags-$(CONFIG_CPU_SH4)		:= $(call cc-option,-m4,) \
 	$(call cc-option,-mno-implicit-fp,-m4-nofpu)
_

Patches currently in -mm which might be from geert+renesas@glider.be are

sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
linux-next.patch

