From: akpm@linux-foundation.org
Subject: [merged] sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
 removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:17 -0700
Message-ID: <53d170d5.954Mjwphdt817Oz2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:56667 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaGXUrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:18 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so583383qap.4
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, ast@plumgrid.com, dborkman@redhat.com, fengguang.wu@intel.com, linux@roeck-us.net, magnus.damm@gmail.com, tony@bakeyournoodle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: also try passing -m4-nofpu for SH2A builds
has been removed from the -mm tree.  Its filename was
     sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

